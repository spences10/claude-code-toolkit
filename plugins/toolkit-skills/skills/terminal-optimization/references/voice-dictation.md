# Voice Dictation Tips

Use voice input for faster prompting. Works in any text field including terminal.

## macOS Dictation

### Enable

System Settings > Keyboard > Dictation > On

### Trigger

**Press fn key twice** to toggle dictation on/off.

### Punctuation Commands

Speak these to insert punctuation:

| Say                              | Inserts |
| -------------------------------- | ------- |
| "period"                         | .       |
| "comma"                          | ,       |
| "question mark"                  | ?       |
| "exclamation point"              | !       |
| "colon"                          | :       |
| "semicolon"                      | ;       |
| "open quote" / "close quote"     | "       |
| "open paren" / "close paren"     | ( )     |
| "open bracket" / "close bracket" | [ ]     |
| "dash"                           | -       |
| "underscore"                     | \_      |

### Formatting Commands

| Say               | Action                 |
| ----------------- | ---------------------- |
| "new line"        | Line break             |
| "new paragraph"   | Double line break      |
| "caps on/off"     | Toggle capitalization  |
| "all caps on/off" | Toggle uppercase       |
| "no space on/off" | Toggle space insertion |

## Best Practices

### For Claude Code Prompts

1. **Pause before starting** - Let dictation fully activate
2. **Speak clearly** - Moderate pace, don't rush
3. **State punctuation** - "Fix the bug in auth dot ts comma then run tests"
4. **Use "new line"** - For multi-step instructions

### Example Dictated Prompt

Speak: "Fix the login function in auth dot ts new line Add error handling for invalid tokens new line Then run the test suite period"

Result:

```
Fix the login function in auth.ts
Add error handling for invalid tokens
Then run the test suite.
```

## Troubleshooting

### Dictation not starting

- Check microphone permissions
- Restart dictation in System Settings
- Try "Enhanced Dictation" for offline mode

### Wrong words transcribed

- Speak more slowly
- Ensure quiet environment
- Add custom words to macOS dictionary

### Stops unexpectedly

- macOS auto-stops after pause
- Say something or press fn twice to restart

## Keyboard Shortcuts

Customize the trigger key in System Settings > Keyboard > Dictation > Shortcut.

Options:

- Press fn Key Twice (default)
- Press Left Command Key Twice
- Press Either Command Key Twice
- Press Right Command Key Twice

## Terminal-Specific Notes

1. **Cursor position matters** - Dictation inserts at cursor
2. **No auto-submit** - Still need to press Enter
3. **Editing** - Use keyboard to correct, then continue dictating
4. **Long prompts** - Dictation is great for detailed instructions

## Linux Alternative

Use `speech-to-text` tools:

- Whisper (OpenAI) with whisper.cpp
- Nerd Dictation
- Google Cloud Speech API

Setup varies by distro. Typically requires hotkey daemon.
