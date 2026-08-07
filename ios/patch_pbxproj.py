#!/usr/bin/env python3
"""One-shot patch: adds NSE target, GoogleService-Info, PrivacyInfo, entitlements
to Runner.xcodeproj/project.pbxproj. Idempotent — refuses to double-add.

Run once: `python3 ios/patch_pbxproj.py`.
"""
import io
import os
import re
import shutil
import sys

PROJ = 'ios/Runner.xcodeproj/project.pbxproj'

UUIDS = {
    'GOOGLE_BF':       'AA10FB0100000000000000A1',
    'PRIVACY_BF':      'AA10FB0200000000000000A2',
    'TRICKCHIME_BF':   'AA10FB0300000000000000A3',
    'APPEX_EMBED_BF':  'AA10FB0400000000000000A4',
    'GOOGLE_FR':       'AA20FA0100000000000000B1',
    'PRIVACY_FR':      'AA20FA0200000000000000B2',
    'ENTITLEMENTS_FR': 'AA20FA0300000000000000B3',
    'TRICKCHIME_FR':   'AA20FA0400000000000000B4',
    'NSEINFO_FR':      'AA20FA0500000000000000B5',
    'APPEX_FR':        'AA20FA0600000000000000B6',
    'NSE_GROUP':       'AA30F90100000000000000C1',
    'NSE_TARGET':      'AA40F80100000000000000D1',
    'NSE_SOURCES':     'AA40F80200000000000000D2',
    'NSE_FRAMEWORKS':  'AA40F80300000000000000D3',
    'NSE_RESOURCES':   'AA40F80400000000000000D4',
    'RUNNER_EMBEDEXT': 'AA50F70100000000000000E1',
    'NSE_PROXY':       'AA60F60100000000000000F1',
    'NSE_DEP':         'AA60F60200000000000000F2',
    'NSE_DEBUG_CFG':   'AA70F50100000000000A0001',
    'NSE_RELEASE_CFG': 'AA70F50200000000000A0002',
    'NSE_PROFILE_CFG': 'AA70F50300000000000A0003',
    'NSE_CFG_LIST':    'AA70F50400000000000A0004',
}

RUNNER_TARGET_UUID = '97C146ED1CF9000F007C117D'
RUNNER_GROUP_UUID  = '97C146F01CF9000F007C117D'
RUNNER_SOURCES_UUID = '97C146EA1CF9000F007C117D'
RUNNER_RESOURCES_UUID = '97C146EC1CF9000F007C117D'
PROJECT_OBJECT_UUID = '97C146E61CF9000F007C117D'
PRODUCTS_GROUP_UUID = '97C146EF1CF9000F007C117D'
RUNNER_DEBUG_CFG   = '97C147061CF9000F007C117D'
RUNNER_RELEASE_CFG = '97C147071CF9000F007C117D'
RUNNER_PROFILE_CFG = '249021D4217E4FDB00AE95B9'
RUNNER_CFG_UIDS = [RUNNER_DEBUG_CFG, RUNNER_RELEASE_CFG, RUNNER_PROFILE_CFG]


def main():
    with open(PROJ, 'rb') as fh:
        raw = fh.read()
    if raw[:3] == b'\xef\xbb\xbf':
        sys.exit('FAIL: BOM in pbxproj')
    txt = raw.decode('utf-8').replace('\r\n', '\n')

    # Sanity — no double patch
    if UUIDS['NSE_TARGET'] in txt:
        print('pbxproj already patched — nothing to do')
        return

    shutil.copyfile(PROJ, PROJ + '.bak')

    # ---- 1. PBXBuildFile section ----
    build_file_lines = (
        f"\t\t{UUIDS['GOOGLE_BF']} /* GoogleService-Info.plist in Resources */ = "
        f"{{isa = PBXBuildFile; fileRef = {UUIDS['GOOGLE_FR']} /* GoogleService-Info.plist */; }};\n"
        f"\t\t{UUIDS['PRIVACY_BF']} /* PrivacyInfo.xcprivacy in Resources */ = "
        f"{{isa = PBXBuildFile; fileRef = {UUIDS['PRIVACY_FR']} /* PrivacyInfo.xcprivacy */; }};\n"
        f"\t\t{UUIDS['TRICKCHIME_BF']} /* TrickChimeService.swift in Sources */ = "
        f"{{isa = PBXBuildFile; fileRef = {UUIDS['TRICKCHIME_FR']} /* TrickChimeService.swift */; }};\n"
        f"\t\t{UUIDS['APPEX_EMBED_BF']} /* NotificationService.appex in Embed App Extensions */ = "
        f"{{isa = PBXBuildFile; fileRef = {UUIDS['APPEX_FR']} /* NotificationService.appex */; "
        f"settings = {{ATTRIBUTES = (RemoveHeadersOnCopy, ); }}; }};\n"
    )
    txt = txt.replace(
        '/* End PBXBuildFile section */',
        build_file_lines + '/* End PBXBuildFile section */',
    )

    # ---- 2. PBXContainerItemProxy for NSE dependency ----
    proxy_block = (
        f"\t\t{UUIDS['NSE_PROXY']} /* PBXContainerItemProxy */ = {{\n"
        f"\t\t\tisa = PBXContainerItemProxy;\n"
        f"\t\t\tcontainerPortal = {PROJECT_OBJECT_UUID} /* Project object */;\n"
        f"\t\t\tproxyType = 1;\n"
        f"\t\t\tremoteGlobalIDString = {UUIDS['NSE_TARGET']};\n"
        f"\t\t\tremoteInfo = NotificationService;\n"
        f"\t\t}};\n"
    )
    txt = txt.replace(
        '/* End PBXContainerItemProxy section */',
        proxy_block + '/* End PBXContainerItemProxy section */',
    )

    # ---- 3. PBXCopyFilesBuildPhase — Runner "Embed App Extensions" ----
    embed_ext_block = (
        f"\t\t{UUIDS['RUNNER_EMBEDEXT']} /* Embed App Extensions */ = {{\n"
        f"\t\t\tisa = PBXCopyFilesBuildPhase;\n"
        f"\t\t\tbuildActionMask = 2147483647;\n"
        f"\t\t\tdstPath = \"\";\n"
        f"\t\t\tdstSubfolderSpec = 13;\n"
        f"\t\t\tfiles = (\n"
        f"\t\t\t\t{UUIDS['APPEX_EMBED_BF']} /* NotificationService.appex in Embed App Extensions */,\n"
        f"\t\t\t);\n"
        f"\t\t\tname = \"Embed App Extensions\";\n"
        f"\t\t\trunOnlyForDeploymentPostprocessing = 0;\n"
        f"\t\t}};\n"
    )
    txt = txt.replace(
        '/* End PBXCopyFilesBuildPhase section */',
        embed_ext_block + '/* End PBXCopyFilesBuildPhase section */',
    )

    # ---- 4. PBXFileReference section ----
    file_refs = (
        f"\t\t{UUIDS['GOOGLE_FR']} /* GoogleService-Info.plist */ = "
        f"{{isa = PBXFileReference; lastKnownFileType = text.plist.xml; "
        f"path = \"GoogleService-Info.plist\"; sourceTree = \"<group>\"; }};\n"
        f"\t\t{UUIDS['PRIVACY_FR']} /* PrivacyInfo.xcprivacy */ = "
        f"{{isa = PBXFileReference; lastKnownFileType = text.xml; "
        f"path = PrivacyInfo.xcprivacy; sourceTree = \"<group>\"; }};\n"
        f"\t\t{UUIDS['ENTITLEMENTS_FR']} /* Runner.entitlements */ = "
        f"{{isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; "
        f"path = Runner.entitlements; sourceTree = \"<group>\"; }};\n"
        f"\t\t{UUIDS['TRICKCHIME_FR']} /* TrickChimeService.swift */ = "
        f"{{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; "
        f"path = TrickChimeService.swift; sourceTree = \"<group>\"; }};\n"
        f"\t\t{UUIDS['NSEINFO_FR']} /* Info.plist */ = "
        f"{{isa = PBXFileReference; lastKnownFileType = text.plist.xml; "
        f"path = Info.plist; sourceTree = \"<group>\"; }};\n"
        f"\t\t{UUIDS['APPEX_FR']} /* NotificationService.appex */ = "
        f"{{isa = PBXFileReference; explicitFileType = \"wrapper.app-extension\"; "
        f"includeInIndex = 0; path = NotificationService.appex; "
        f"sourceTree = BUILT_PRODUCTS_DIR; }};\n"
    )
    txt = txt.replace(
        '/* End PBXFileReference section */',
        file_refs + '/* End PBXFileReference section */',
    )

    # ---- 5. PBXFrameworksBuildPhase for NSE (empty) ----
    nse_frameworks_block = (
        f"\t\t{UUIDS['NSE_FRAMEWORKS']} /* Frameworks */ = {{\n"
        f"\t\t\tisa = PBXFrameworksBuildPhase;\n"
        f"\t\t\tbuildActionMask = 2147483647;\n"
        f"\t\t\tfiles = (\n"
        f"\t\t\t);\n"
        f"\t\t\trunOnlyForDeploymentPostprocessing = 0;\n"
        f"\t\t}};\n"
    )
    txt = txt.replace(
        '/* End PBXFrameworksBuildPhase section */',
        nse_frameworks_block + '/* End PBXFrameworksBuildPhase section */',
    )

    # ---- 6. PBXGroup — NotificationService group + Runner children + Products ----
    nse_group_block = (
        f"\t\t{UUIDS['NSE_GROUP']} /* NotificationService */ = {{\n"
        f"\t\t\tisa = PBXGroup;\n"
        f"\t\t\tchildren = (\n"
        f"\t\t\t\t{UUIDS['TRICKCHIME_FR']} /* TrickChimeService.swift */,\n"
        f"\t\t\t\t{UUIDS['NSEINFO_FR']} /* Info.plist */,\n"
        f"\t\t\t);\n"
        f"\t\t\tpath = NotificationService;\n"
        f"\t\t\tsourceTree = \"<group>\";\n"
        f"\t\t}};\n"
    )
    txt = txt.replace(
        '/* End PBXGroup section */',
        nse_group_block + '/* End PBXGroup section */',
    )

    # Add NotificationService group into main group's children (after Runner)
    main_group_pattern = (
        '97C146F01CF9000F007C117D /* Runner */,\n'
        '\t\t\t\t97C146EF1CF9000F007C117D /* Products */,\n'
    )
    main_group_replacement = (
        '97C146F01CF9000F007C117D /* Runner */,\n'
        f'\t\t\t\t{UUIDS["NSE_GROUP"]} /* NotificationService */,\n'
        '\t\t\t\t97C146EF1CF9000F007C117D /* Products */,\n'
    )
    if main_group_pattern not in txt:
        sys.exit('FAIL: could not find main group children pattern')
    txt = txt.replace(main_group_pattern, main_group_replacement)

    # Add Runner.entitlements + GoogleService-Info + PrivacyInfo to Runner group children
    runner_group_pattern = (
        '\t\t\t\t74858FAE1ED2DC5600515810 /* AppDelegate.swift */,\n'
        '\t\t\t\t7884E8672EC3CC0400C636F2 /* SceneDelegate.swift */,\n'
        '\t\t\t\t74858FAD1ED2DC5600515810 /* Runner-Bridging-Header.h */,\n'
    )
    runner_group_replacement = (
        '\t\t\t\t74858FAE1ED2DC5600515810 /* AppDelegate.swift */,\n'
        '\t\t\t\t7884E8672EC3CC0400C636F2 /* SceneDelegate.swift */,\n'
        '\t\t\t\t74858FAD1ED2DC5600515810 /* Runner-Bridging-Header.h */,\n'
        f'\t\t\t\t{UUIDS["ENTITLEMENTS_FR"]} /* Runner.entitlements */,\n'
        f'\t\t\t\t{UUIDS["GOOGLE_FR"]} /* GoogleService-Info.plist */,\n'
        f'\t\t\t\t{UUIDS["PRIVACY_FR"]} /* PrivacyInfo.xcprivacy */,\n'
    )
    if runner_group_pattern not in txt:
        sys.exit('FAIL: could not find Runner group children pattern')
    txt = txt.replace(runner_group_pattern, runner_group_replacement)

    # Add NSE.appex to Products group
    products_pattern = (
        '97C146EE1CF9000F007C117D /* Runner.app */,\n'
        '\t\t\t\t331C8081294A63A400263BE5 /* RunnerTests.xctest */,\n'
    )
    products_replacement = (
        '97C146EE1CF9000F007C117D /* Runner.app */,\n'
        '\t\t\t\t331C8081294A63A400263BE5 /* RunnerTests.xctest */,\n'
        f'\t\t\t\t{UUIDS["APPEX_FR"]} /* NotificationService.appex */,\n'
    )
    if products_pattern not in txt:
        sys.exit('FAIL: could not find Products group pattern')
    txt = txt.replace(products_pattern, products_replacement)

    # ---- 7. PBXNativeTarget — NotificationService ----
    nse_target_block = (
        f"\t\t{UUIDS['NSE_TARGET']} /* NotificationService */ = {{\n"
        f"\t\t\tisa = PBXNativeTarget;\n"
        f"\t\t\tbuildConfigurationList = {UUIDS['NSE_CFG_LIST']} /* Build configuration list for PBXNativeTarget \"NotificationService\" */;\n"
        f"\t\t\tbuildPhases = (\n"
        f"\t\t\t\t{UUIDS['NSE_SOURCES']} /* Sources */,\n"
        f"\t\t\t\t{UUIDS['NSE_FRAMEWORKS']} /* Frameworks */,\n"
        f"\t\t\t\t{UUIDS['NSE_RESOURCES']} /* Resources */,\n"
        f"\t\t\t);\n"
        f"\t\t\tbuildRules = (\n"
        f"\t\t\t);\n"
        f"\t\t\tdependencies = (\n"
        f"\t\t\t);\n"
        f"\t\t\tname = NotificationService;\n"
        f"\t\t\tproductName = NotificationService;\n"
        f"\t\t\tproductReference = {UUIDS['APPEX_FR']} /* NotificationService.appex */;\n"
        f"\t\t\tproductType = \"com.apple.product-type.app-extension\";\n"
        f"\t\t}};\n"
    )
    txt = txt.replace(
        '/* End PBXNativeTarget section */',
        nse_target_block + '/* End PBXNativeTarget section */',
    )

    # ---- 8. Runner buildPhases: add "Embed App Extensions" after Embed Frameworks ----
    runner_phase_pattern = '5FDD80117DF216767555CBBE /* [CP] Embed Pods Frameworks */,\n'
    runner_phase_replacement = (
        '5FDD80117DF216767555CBBE /* [CP] Embed Pods Frameworks */,\n'
        f"\t\t\t\t{UUIDS['RUNNER_EMBEDEXT']} /* Embed App Extensions */,\n"
    )
    if runner_phase_pattern not in txt:
        sys.exit('FAIL: could not find Runner Embed Pods phase to append Embed App Extensions')
    txt = txt.replace(runner_phase_pattern, runner_phase_replacement)

    # Add NSE dependency to Runner target
    runner_dep_pattern = (
        f'name = Runner;\n'
        f'\t\t\tproductName = Runner;\n'
    )
    # The dependencies = () line for Runner is right before name = Runner;
    # We rewrite it precisely.
    runner_deps_original = (
        '\t\t\tdependencies = (\n'
        '\t\t\t);\n'
        '\t\t\tname = Runner;\n'
    )
    runner_deps_new = (
        '\t\t\tdependencies = (\n'
        f'\t\t\t\t{UUIDS["NSE_DEP"]} /* PBXTargetDependency */,\n'
        '\t\t\t);\n'
        '\t\t\tname = Runner;\n'
    )
    if runner_deps_original not in txt:
        sys.exit('FAIL: could not find Runner dependencies block')
    txt = txt.replace(runner_deps_original, runner_deps_new)

    # ---- 9. Add NotificationService to project.targets ----
    project_targets_pattern = (
        '\t\t\ttargets = (\n'
        '\t\t\t\t97C146ED1CF9000F007C117D /* Runner */,\n'
        '\t\t\t\t331C8080294A63A400263BE5 /* RunnerTests */,\n'
        '\t\t\t);\n'
    )
    project_targets_replacement = (
        '\t\t\ttargets = (\n'
        '\t\t\t\t97C146ED1CF9000F007C117D /* Runner */,\n'
        '\t\t\t\t331C8080294A63A400263BE5 /* RunnerTests */,\n'
        f'\t\t\t\t{UUIDS["NSE_TARGET"]} /* NotificationService */,\n'
        '\t\t\t);\n'
    )
    if project_targets_pattern not in txt:
        sys.exit('FAIL: could not find project.targets block')
    txt = txt.replace(project_targets_pattern, project_targets_replacement)

    # Add TargetAttributes for NSE (LastSwiftMigration etc.)
    target_attrs_pattern = (
        '\t\t\t\t\t97C146ED1CF9000F007C117D = {\n'
        '\t\t\t\t\t\tCreatedOnToolsVersion = 7.3.1;\n'
        '\t\t\t\t\t\tLastSwiftMigration = 1100;\n'
        '\t\t\t\t\t};\n'
    )
    target_attrs_replacement = (
        target_attrs_pattern
        + f"\t\t\t\t\t{UUIDS['NSE_TARGET']} = {{\n"
          f"\t\t\t\t\t\tCreatedOnToolsVersion = 15.0;\n"
          f"\t\t\t\t\t\tProvisioningStyle = Automatic;\n"
          f"\t\t\t\t\t}};\n"
    )
    if target_attrs_pattern not in txt:
        sys.exit('FAIL: could not find TargetAttributes block')
    txt = txt.replace(target_attrs_pattern, target_attrs_replacement)

    # ---- 10. PBXResourcesBuildPhase — add GoogleService-Info + PrivacyInfo to Runner, empty for NSE ----
    runner_resources_pattern = (
        '\t\t\t\t97C147011CF9000F007C117D /* LaunchScreen.storyboard in Resources */,\n'
        '\t\t\t\t3B3967161E833CAA004F5970 /* AppFrameworkInfo.plist in Resources */,\n'
        '\t\t\t\t97C146FE1CF9000F007C117D /* Assets.xcassets in Resources */,\n'
        '\t\t\t\t97C146FC1CF9000F007C117D /* Main.storyboard in Resources */,\n'
    )
    runner_resources_replacement = (
        runner_resources_pattern
        + f"\t\t\t\t{UUIDS['GOOGLE_BF']} /* GoogleService-Info.plist in Resources */,\n"
          f"\t\t\t\t{UUIDS['PRIVACY_BF']} /* PrivacyInfo.xcprivacy in Resources */,\n"
    )
    if runner_resources_pattern not in txt:
        sys.exit('FAIL: could not find Runner Resources build phase files')
    txt = txt.replace(runner_resources_pattern, runner_resources_replacement)

    # NSE Resources phase (empty)
    nse_resources_block = (
        f"\t\t{UUIDS['NSE_RESOURCES']} /* Resources */ = {{\n"
        f"\t\t\tisa = PBXResourcesBuildPhase;\n"
        f"\t\t\tbuildActionMask = 2147483647;\n"
        f"\t\t\tfiles = (\n"
        f"\t\t\t);\n"
        f"\t\t\trunOnlyForDeploymentPostprocessing = 0;\n"
        f"\t\t}};\n"
    )
    txt = txt.replace(
        '/* End PBXResourcesBuildPhase section */',
        nse_resources_block + '/* End PBXResourcesBuildPhase section */',
    )

    # ---- 11. PBXSourcesBuildPhase — NSE ----
    nse_sources_block = (
        f"\t\t{UUIDS['NSE_SOURCES']} /* Sources */ = {{\n"
        f"\t\t\tisa = PBXSourcesBuildPhase;\n"
        f"\t\t\tbuildActionMask = 2147483647;\n"
        f"\t\t\tfiles = (\n"
        f"\t\t\t\t{UUIDS['TRICKCHIME_BF']} /* TrickChimeService.swift in Sources */,\n"
        f"\t\t\t);\n"
        f"\t\t\trunOnlyForDeploymentPostprocessing = 0;\n"
        f"\t\t}};\n"
    )
    txt = txt.replace(
        '/* End PBXSourcesBuildPhase section */',
        nse_sources_block + '/* End PBXSourcesBuildPhase section */',
    )

    # ---- 12. PBXTargetDependency ----
    dep_block = (
        f"\t\t{UUIDS['NSE_DEP']} /* PBXTargetDependency */ = {{\n"
        f"\t\t\tisa = PBXTargetDependency;\n"
        f"\t\t\ttarget = {UUIDS['NSE_TARGET']} /* NotificationService */;\n"
        f"\t\t\ttargetProxy = {UUIDS['NSE_PROXY']} /* PBXContainerItemProxy */;\n"
        f"\t\t}};\n"
    )
    txt = txt.replace(
        '/* End PBXTargetDependency section */',
        dep_block + '/* End PBXTargetDependency section */',
    )

    # ---- 13. XCBuildConfiguration for NSE (Debug/Release/Profile) ----
    def nse_cfg(uid, name):
        return (
            f"\t\t{uid} /* {name} */ = {{\n"
            f"\t\t\tisa = XCBuildConfiguration;\n"
            f"\t\t\tbuildSettings = {{\n"
            f"\t\t\t\tCODE_SIGN_STYLE = Automatic;\n"
            f"\t\t\t\tCURRENT_PROJECT_VERSION = \"$(FLUTTER_BUILD_NUMBER)\";\n"
            f"\t\t\t\tDEVELOPMENT_TEAM = Y5PUSTX22G;\n"
            f"\t\t\t\tGENERATE_INFOPLIST_FILE = NO;\n"
            f"\t\t\t\tINFOPLIST_FILE = NotificationService/Info.plist;\n"
            f"\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 15.0;\n"
            f"\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (\n"
            f"\t\t\t\t\t\"$(inherited)\",\n"
            f"\t\t\t\t\t\"@executable_path/Frameworks\",\n"
            f"\t\t\t\t\t\"@executable_path/../../Frameworks\",\n"
            f"\t\t\t\t);\n"
            f"\t\t\t\tMARKETING_VERSION = \"$(FLUTTER_BUILD_NAME)\";\n"
            f"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.tumblingtricks.tricksgame.NotificationService;\n"
            f"\t\t\t\tPRODUCT_NAME = \"$(TARGET_NAME)\";\n"
            f"\t\t\t\tSKIP_INSTALL = YES;\n"
            f"\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;\n"
            f"\t\t\t\tSWIFT_VERSION = 5.0;\n"
            f"\t\t\t\tTARGETED_DEVICE_FAMILY = \"1,2\";\n"
            f"\t\t\t}};\n"
            f"\t\t\tname = {name};\n"
            f"\t\t}};\n"
        )
    nse_cfg_blocks = (
        nse_cfg(UUIDS['NSE_DEBUG_CFG'], 'Debug')
        + nse_cfg(UUIDS['NSE_RELEASE_CFG'], 'Release')
        + nse_cfg(UUIDS['NSE_PROFILE_CFG'], 'Profile')
    )
    txt = txt.replace(
        '/* End XCBuildConfiguration section */',
        nse_cfg_blocks + '/* End XCBuildConfiguration section */',
    )

    # Add CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements to each Runner config
    for uid in RUNNER_CFG_UIDS:
        marker = f'{uid} /*'
        idx = txt.find(marker)
        if idx < 0:
            sys.exit(f'FAIL: could not find Runner config {uid}')
        end_idx = txt.find('};', idx)
        block = txt[idx:end_idx]
        if 'CODE_SIGN_ENTITLEMENTS' in block:
            continue
        insert_marker = 'buildSettings = {\n'
        insert_at = txt.find(insert_marker, idx) + len(insert_marker)
        txt = (
            txt[:insert_at]
            + '\t\t\t\tCODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements;\n'
            + txt[insert_at:]
        )

    # ---- 14. XCConfigurationList for NSE ----
    cfg_list_block = (
        f"\t\t{UUIDS['NSE_CFG_LIST']} /* Build configuration list for PBXNativeTarget \"NotificationService\" */ = {{\n"
        f"\t\t\tisa = XCConfigurationList;\n"
        f"\t\t\tbuildConfigurations = (\n"
        f"\t\t\t\t{UUIDS['NSE_DEBUG_CFG']} /* Debug */,\n"
        f"\t\t\t\t{UUIDS['NSE_RELEASE_CFG']} /* Release */,\n"
        f"\t\t\t\t{UUIDS['NSE_PROFILE_CFG']} /* Profile */,\n"
        f"\t\t\t);\n"
        f"\t\t\tdefaultConfigurationIsVisible = 0;\n"
        f"\t\t\tdefaultConfigurationName = Release;\n"
        f"\t\t}};\n"
    )
    txt = txt.replace(
        '/* End XCConfigurationList section */',
        cfg_list_block + '/* End XCConfigurationList section */',
    )

    # ---- Sanity checks ----
    g0 = txt.find('/* Begin PBXGroup section */')
    g1 = txt.find('/* End PBXGroup section */')
    assert UUIDS['NSE_GROUP'] in txt[g0:g1], 'NSE group outside PBXGroup section!'
    assert txt.count('CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements') == 3, \
        f"unexpected entitlements count: {txt.count('CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements')}"
    for uid in [UUIDS['NSE_DEBUG_CFG'], UUIDS['NSE_RELEASE_CFG'], UUIDS['NSE_PROFILE_CFG']]:
        idx = txt.find(uid)
        block = txt[idx:idx + 1400]
        assert 'CODE_SIGN_ENTITLEMENTS' not in block, f'entitlements on NSE cfg {uid}'
    assert UUIDS['NSE_TARGET'] in txt
    assert txt.count(UUIDS['NSE_TARGET']) >= 4  # target itself, proxy, dependencies, project.targets, TargetAttributes

    # Write CRLF for parity with Xcode-produced files? Flutter macOS uses LF.
    # Keep LF; final byte check ensures no BOM.
    with open(PROJ, 'wb') as fh:
        fh.write(txt.encode('utf-8'))

    with open(PROJ, 'rb') as fh:
        if fh.read(3) == b'\xef\xbb\xbf':
            sys.exit('FAIL: BOM produced')
    print('pbxproj patched OK')


if __name__ == '__main__':
    main()
