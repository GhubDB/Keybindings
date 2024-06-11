import { KarabinerRules } from "./types";
import { createHyperSubLayers, app, open, addCodingApps, createHyperKeys } from "./utils";
import fs from "fs";

const rules: KarabinerRules[] = [
  // Define the Hyper key itself
  {
    description: "Hyper Key (⌃⌥⇧⌘)",
    manipulators: [
      {
        description: "Caps Lock -> Hyper Key",
        from: { key_code: "caps_lock" },
        to: [
          {
            key_code: "left_shift",
            modifiers: ["left_command", "left_control", "left_option"],
          },
        ],
        to_if_alone: [{ key_code: "escape" }],
        type: "basic",
      },
    ],
  },

  // Non hpyer coding hotkeys
  {
    description: "ö to {",
    manipulators: [
      {
        type: "basic",
        conditions: [
          {
            bundle_identifiers: addCodingApps(),
            type: "frontmost_application_if",
          },
        ],
        from: { key_code: "semicolon" },
        to: [
          {
            repeat: true,
            key_code: "8",
            modifiers: ["left_alt"],
          },
        ],
      },
    ],
  },
  {
    description: "shift ö to }",
    manipulators: [
      {
        type: "basic",
        conditions: [
          {
            bundle_identifiers: addCodingApps(),
            type: "frontmost_application_if",
          },
        ],
        from: {
          modifiers: {
            mandatory: ["left_shift"],
          },
          key_code: "semicolon",
        },
        to: [
          {
            repeat: true,
            key_code: "9",
            modifiers: ["left_alt"],
          },
        ],
      },
    ],
  },
  {
    description: "ä to `",
    manipulators: [
      {
        type: "basic",
        conditions: [
          {
            bundle_identifiers: addCodingApps(),
            type: "frontmost_application_if",
          },
        ],
        from: {
          key_code: "quote",
        },
        to: [
          {
            repeat: true,
            key_code: "equal_sign",
            modifiers: ["left_shift"],
          },
          {
            key_code: "spacebar",
          },
        ],
      },
    ],
  },
  {
    description: "shift + ä to ^",
    manipulators: [
      {
        type: "basic",
        conditions: [
          {
            bundle_identifiers: addCodingApps(),
            type: "frontmost_application_if",
          },
        ],
        from: {
          modifiers: {
            mandatory: ["left_shift"],
          },
          key_code: "quote",
        },
        to: [
          {
            repeat: true,
            key_code: "equal_sign",
          },
          {
            key_code: "spacebar",
          },
        ],
      },
    ],
  },
  {
    description: "ü to [",
    manipulators: [
      {
        type: "basic",
        conditions: [
          {
            bundle_identifiers: addCodingApps(),
            type: "frontmost_application_if",
          },
        ],
        from: {
          key_code: "open_bracket",
        },
        to: [
          {
            repeat: true,
            key_code: "5",
            modifiers: ["left_alt"],
          },
        ],
      },
    ],
  },
  {
    description: "shift + ü to ]",
    manipulators: [
      {
        type: "basic",
        conditions: [
          {
            bundle_identifiers: addCodingApps(),
            type: "frontmost_application_if",
          },
        ],
        from: {
          modifiers: {
            mandatory: ["left_shift"],
          },
          key_code: "open_bracket",
        },
        to: [
          {
            repeat: true,
            key_code: "6",
            modifiers: ["left_alt"],
          },
        ],
      },
    ],
  },
  {
    description: "cmd+c to ctrl+c",
    manipulators: [
      {
        type: "basic",
        from: {
          modifiers: {
            mandatory: ["left_control"],
          },
          key_code: "c",
        },
        to: [
          {
            key_code: "c",
            modifiers: ["left_command"],
          },
        ],
      },
    ],
  },
  {
    description: "ctrl+shift+c to ctrl+c",
    manipulators: [
      {
        type: "basic",
        from: {
          modifiers: {
            mandatory: ["left_control", "left_shift"],
          },
          key_code: "c",
        },
        to: [
          {
            key_code: "c",
            modifiers: ["left_control"],
          },
        ],
      },
    ],
  },
  {
    description: "cmd+v to ctrl+v",
    manipulators: [
      {
        type: "basic",
        from: {
          modifiers: {
            mandatory: ["left_control"],
          },
          key_code: "v",
        },
        to: [
          {
            key_code: "v",
            modifiers: ["left_command"],
          },
        ],
      },
    ],
  },
  {
    description: "cmd+x to ctrl+x",
    manipulators: [
      {
        type: "basic",
        from: {
          modifiers: {
            mandatory: ["left_control"],
          },
          key_code: "x",
        },
        to: [
          {
            key_code: "x",
            modifiers: ["left_command"],
          },
        ],
      },
    ],
  },
  {
    description: "cmd+a to ctrl+a",
    manipulators: [
      {
        type: "basic",
        from: {
          modifiers: {
            mandatory: ["left_control"],
          },
          key_code: "a",
        },
        conditions: [
          {
            type: "frontmost_application_unless",
            bundle_identifiers: addCodingApps(),
          },
        ],
        to: [
          {
            key_code: "a",
            modifiers: ["left_command"],
          },
        ],
      },
    ],
  },
  {
    description: "cmd+s to ctrl+s",
    manipulators: [
      {
        type: "basic",
        from: {
          modifiers: {
            mandatory: ["left_control"],
          },
          key_code: "s",
        },
        to: [
          {
            key_code: "s",
            modifiers: ["left_command"],
          },
        ],
      },
    ],
  },
  {
    description: "cmd+n to ctrl+n",
    manipulators: [
      {
        type: "basic",
        from: {
          modifiers: {
            mandatory: ["left_control"],
          },
          key_code: "n",
        },
        to: [
          {
            key_code: "n",
            modifiers: ["left_command"],
          },
        ],
      },
    ],
  },
  {
    description: "cmd+z to ctrl+z",
    manipulators: [
      {
        type: "basic",
        from: {
          modifiers: {
            mandatory: ["left_control"],
          },
          key_code: "y",
        },
        to: [
          {
            key_code: "y",
            modifiers: ["left_command"],
          },
        ],
      },
    ],
  },
  {
    description: "Open files in finder with enter",
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: "return_or_enter",
        },
        conditions: [
          {
            bundle_identifiers: ["^com\\.apple\\.finder$"],
            type: "frontmost_application_if",
          },
        ],
        to: [
          {
            key_code: "down_arrow",
            modifiers: ["left_command"],
          },
        ],
      },
    ],
  },
  {
    description: "Edit title with ctrl+enter in finder",
    manipulators: [
      {
        type: "basic",
        from: {
          modifiers: {
            mandatory: ["left_control"],
          },
          key_code: "return_or_enter",
        },
        conditions: [
          {
            bundle_identifiers: ["^com\\.apple\\.finder$"],
            type: "frontmost_application_if",
          },
        ],
        to: [
          {
            key_code: "return_or_enter",
          },
        ],
      },
    ],
  },

  ...createHyperKeys({
    // Hyper special characters
    l: { to: [{ key_code: "2", modifiers: ["left_shift"] }] },
    j: { to: [{ key_code: "8", modifiers: ["left_shift"] }] },
    k: { to: [{ key_code: "9", modifiers: ["left_shift"] }] },
    u: { to: [{ key_code: "7", modifiers: ["left_shift"] }] },
    i: { to: [{ key_code: "7", modifiers: ["left_option"] }] },
    p: { to: [{ key_code: "7", modifiers: ["left_option", "left_shift"] }] },

    // Apps
    g: app("Google Chrome"),
    q: app("Preview"),
    v: app("Visual Studio Code"),
    f: app("Firefox"),
    y: app("Hyper"),
    r: app("Rider"),
    t: app("Microsoft Teams"),
    o: app("Microsoft Outlook"),
    n: app("Microsoft OneNote"),
    e: app("Microsoft Edge"),
    h: app("Finder"),
    d: app("Docker Desktop"),
    c: app("Karabiner-Elements"),
    a: app("Azure Data Studio"),
    w: app("/Users/taadimo2/projects/gibb/122-gruppenarbeit/dist/workulator"),
  }),

  ...createHyperSubLayers({
    // x = "System"
    x: {
      u: {
        to: [
          {
            key_code: "volume_increment",
          },
        ],
      },
      j: {
        to: [
          {
            key_code: "volume_decrement",
          },
        ],
      },
      i: {
        to: [
          {
            key_code: "display_brightness_increment",
          },
        ],
      },
      k: {
        to: [
          {
            key_code: "display_brightness_decrement",
          },
        ],
      },
      l: {
        to: [
          {
            key_code: "q",
            modifiers: ["right_control", "right_command"],
          },
        ],
      },
      p: {
        to: [
          {
            key_code: "play_or_pause",
          },
        ],
      },
      semicolon: {
        to: [
          {
            key_code: "fastforward",
          },
        ],
      },
      e: {
        to: [
          {
            // Emoji picker
            key_code: "spacebar",
            modifiers: ["right_control", "right_command"],
          },
        ],
      },
    },

    // s = Move
    s: {
      h: {
        to: [{ key_code: "left_arrow" }],
      },
      j: {
        to: [{ key_code: "down_arrow" }],
      },
      k: {
        to: [{ key_code: "up_arrow" }],
      },
      l: {
        to: [{ key_code: "right_arrow" }],
      },
    },
  }),
];

fs.writeFileSync(
  "karabiner.json",
  JSON.stringify(
    {
      // global: {
      //   show_in_menu_bar: false,
      // },
      profiles: [
        {
          name: "Default",
          complex_modifications: {
            rules,
          },
        },
      ],
    },
    null,
    2
  )
);
