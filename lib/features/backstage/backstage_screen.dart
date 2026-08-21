import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/reminders.dart';
import '../../data/app_database.dart';
import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import '../shared/page_frame.dart';
import '../shared/sheet_shell.dart';
import 'daily_reminder_card.dart';
import 'data_export.dart';
import 'profile_photo_store.dart';
import 'reminder_card.dart';

/// Backstage: who the performer is and how the app behaves.
///
/// Profile fields save as you leave them rather than behind an Edit mode, since
/// there is nothing here that needs validating against anything else.
class BackstageScreen extends ConsumerStatefulWidget {
  const BackstageScreen({super.key});

  @override
  ConsumerState<BackstageScreen> createState() => _BackstageScreenState();
}

class _BackstageScreenState extends ConsumerState<BackstageScreen> {
  final TextEditingController _stageName = TextEditingController();
  final TextEditingController _homeVenue = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  bool _seeded = false;

  @override
  void dispose() {
    _stageName.dispose();
    _homeVenue.dispose();
    _bio.dispose();
    super.dispose();
  }

  /// Fills the fields once, from the first row that arrives. Later database
  /// updates must not overwrite what is being typed.
  void _seed(PerformerProfileRow profile) {
    if (_seeded) return;
    _seeded = true;
    _stageName.text = profile.stageName;
    _homeVenue.text = profile.homeVenue ?? '';
    _bio.text = profile.bio ?? '';
  }

  Future<void> _save() {
    return ref.read(profileRepositoryProvider).update(
      stageName: _stageName.text,
      homeVenue: _homeVenue.text,
      bio: _bio.text,
    );
  }

  Future<void> _changePhoto() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => const _PhotoSourceSheet(),
    );
    if (source == null) return;

    final String? fileName = await ProfilePhotoStore.pickAndStore(source);
    if (fileName == null) return;

    await ref.read(profileRepositoryProvider).setPhotoFileName(fileName);
  }

  Future<void> _removePhoto() async {
    await ref.read(profileRepositoryProvider).setPhotoFileName(null);
    await ProfilePhotoStore.deleteAll();
  }

  Future<void> _export() async {
    try {
      await DataExport.share(ref.read(databaseProvider));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not write the export: $error')),
      );
    }
  }

  Future<void> _confirmErase() async {
    final bool? yes = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Erase everything?'),
        content: Text(
          'Every act, run order, checklist, stage plot, note, rehearsal and your '
          'photo will be deleted from this device. The bundled trick catalogue is '
          'restored fresh. This cannot be undone.',
          style: AppText.body,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('KEEP MY WORK'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Palette.danger),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('ERASE'),
          ),
        ],
      ),
    );
    if (!(yes ?? false)) return;

    await ref.read(reminderProvider).cancelAll();
    await ProfilePhotoStore.deleteAll();
    await ref.read(databaseProvider).eraseAllData();

    if (!mounted) return;
    _seeded = false;
    _stageName.clear();
    _homeVenue.clear();
    _bio.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Everything erased')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PerformerProfileRow? profile = ref.watch(profileProvider).value;
    final AppPreferenceRow? prefs = ref.watch(preferencesProvider).value;

    if (profile != null) _seed(profile);

    return PopScope(
      // Leaving the screen is the commit point for the text fields.
      onPopInvokedWithResult: (bool didPop, Object? _) {
        if (didPop) _save();
      },
      child: PageFrame(
        scene: StageScene.curtains,
        artworkOpacity: 0.3,
        header: MarqueeHeader(
          title: 'Backstage',
          subtitle: 'Your details and how the app behaves.',
          crest: Ornaments.crestMask,
          onBack: () => context.pop(),
        ),
        slivers: <Widget>[
          PageSliver(
            child: PanelCard(
              padding: const EdgeInsets.all(Gap.xl),
              child: Column(
                children: <Widget>[
                  _Avatar(
                    fileName: profile?.photoFileName,
                    onTap: _changePhoto,
                  ),
                  Gap.vMd,
                  Wrap(
                    spacing: Gap.sm,
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      TextButton.icon(
                        onPressed: _changePhoto,
                        icon: const Icon(Icons.photo_camera_outlined, size: 18),
                        label: Text(
                          profile?.photoFileName == null
                              ? 'ADD A PHOTO'
                              : 'CHANGE PHOTO',
                        ),
                      ),
                      if (profile?.photoFileName != null)
                        TextButton(
                          onPressed: _removePhoto,
                          child: const Text('REMOVE'),
                        ),
                    ],
                  ),
                  Gap.vLg,
                  TextField(
                    controller: _stageName,
                    textCapitalization: TextCapitalization.words,
                    textAlign: TextAlign.center,
                    style: AppText.cardTitle,
                    maxLength: 60,
                    decoration: const InputDecoration(
                      labelText: 'Stage name',
                      counterText: '',
                    ),
                    onEditingComplete: _save,
                  ),
                ],
              ),
            ),
          ),
          PageSliver(
            top: Gap.xl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SectionHeading(label: 'Your discipline'),
                Gap.vMd,
                Wrap(
                  spacing: Gap.sm,
                  runSpacing: Gap.sm,
                  children: <Widget>[
                    for (final Discipline discipline in Discipline.values)
                      ChoiceChip(
                        label: Text(discipline.label),
                        avatar: Image.asset(discipline.icon, height: 16),
                        selected: profile?.discipline == discipline,
                        onSelected: (bool on) =>
                            ref.read(profileRepositoryProvider).update(
                          discipline: on ? discipline : null,
                          clearDiscipline: !on,
                        ),
                      ),
                  ],
                ),
                Gap.vXl,
                TextField(
                  controller: _homeVenue,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Home venue'),
                  onEditingComplete: _save,
                ),
                Gap.vLg,
                TextField(
                  controller: _bio,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'About your work',
                    alignLabelWithHint: true,
                  ),
                  onEditingComplete: _save,
                ),
              ],
            ),
          ),
          PageSliver(
            top: Gap.xl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SectionHeading(label: 'Behaviour'),
                Gap.vMd,
                PanelCard(
                  padding: const EdgeInsets.symmetric(horizontal: Gap.sm),
                  child: Column(
                    children: <Widget>[
                      SwitchListTile(
                        value: prefs?.soundEnabled ?? true,
                        title: const Text('Stage cue sounds'),
                        subtitle: const Text('Short brass and paper sounds on actions.'),
                        onChanged: (bool value) => ref
                            .read(preferencesRepositoryProvider)
                            .setSoundEnabled(enabled: value),
                      ),
                      SwitchListTile(
                        value: prefs?.hapticsEnabled ?? true,
                        title: const Text('Haptics'),
                        subtitle: const Text('A tap when something is confirmed.'),
                        onChanged: (bool value) => ref
                            .read(preferencesRepositoryProvider)
                            .setHapticsEnabled(enabled: value),
                      ),
                      SwitchListTile(
                        value: prefs?.decayEnabled ?? true,
                        title: const Text('Skill decay'),
                        subtitle: const Text(
                          'Show-ready tricks drop to reliable after three '
                          'weeks unrehearsed, reliable to drilling after a '
                          'month. Turn off to keep ratings fixed.',
                        ),
                        onChanged: (bool value) => ref
                            .read(preferencesRepositoryProvider)
                            .setDecayEnabled(enabled: value),
                      ),
                    ],
                  ),
                ),
                Gap.vMd,
                const ReminderCard(),
                Gap.vMd,
                const DailyReminderCard(),
              ],
            ),
          ),
          PageSliver(
            top: Gap.xl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SectionHeading(label: 'Your data'),
                Gap.vMd,
                PanelCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.ios_share_rounded,
                            color: Palette.brass),
                        title: const Text('Export a copy'),
                        subtitle: const Text(
                          'A readable JSON file of every act, trick and rehearsal',
                        ),
                        onTap: _export,
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline_rounded,
                            color: Palette.danger),
                        title: const Text('Erase everything'),
                        subtitle: const Text('Cannot be undone'),
                        onTap: _confirmErase,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          PageSliver(
            top: Gap.xl,
            bottom: Gap.xl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SectionHeading(label: 'About'),
                Gap.vMd,
                PanelCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.lock_outline_rounded,
                            color: Palette.brass),
                        title: const Text('Privacy policy'),
                        subtitle: const Text('Bundled — opens without a connection'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.push('/backstage/privacy'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.help_outline_rounded,
                            color: Palette.brass),
                        title: const Text('Support & FAQ'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.push('/backstage/support'),
                      ),
                    ],
                  ),
                ),
                Gap.vLg,
                Center(
                  child: Column(
                    children: <Widget>[
                      Image.asset(Brand.logotype, height: 40),
                      Gap.vSm,
                      Text(
                        'Everything you enter stays on this device.',
                        style: AppText.micro,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.fileName, required this.onTap});

  final String? fileName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 116,
        height: 116,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: Palette.panelSheen,
          border: Border.all(color: Palette.brass, width: 1.6),
        ),
        child: ClipOval(
          child: FutureBuilder<File?>(
            // Rebuilt whenever the stored name changes, which is what makes a
            // newly picked photo appear without any manual refresh.
            key: ValueKey<String?>(fileName),
            future: ProfilePhotoStore.resolve(fileName),
            builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
              final File? file = snapshot.data;
              if (file == null) {
                return Center(
                  child: Image.asset(Emblems.mask, height: 56),
                );
              }
              return Image.file(file, fit: BoxFit.cover);
            },
          ),
        ),
      ),
    );
  }
}

class _PhotoSourceSheet extends StatelessWidget {
  const _PhotoSourceSheet();

  @override
  Widget build(BuildContext context) {
    return SheetShell(
      heightFraction: 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Performer photo', style: AppText.cardTitle),
          Gap.vXs,
          Text(
            'The photo is copied into the app, reduced in size and never uploaded.',
            style: AppText.caption,
          ),
          Gap.vLg,
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.photo_camera_outlined, color: Palette.brass),
            title: const Text('Take a photo'),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.photo_library_outlined, color: Palette.brass),
            title: const Text('Choose from library'),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}
