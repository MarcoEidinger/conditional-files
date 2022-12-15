# ConditionalFiles

A command-line tool intended to insert a conditional compilation statement in multiple Swift files at once.

And generic enough being able to process multiple files and **insert *any* text at the top and the bottom of a file** :)

Example:

```bash
swift run conditional-files --ios test.swift
```

Before

```swift
import CarKey
// code
```

After

```swift
#if os(iOS)
import CarKey
// code
#endif
```

You can also remove the compiler directive.

```bash
swift run conditional-files --ios --undo test.swift
```

Before

```swift
#if os(iOS)
import CarKey
// code
#endif
```

After

```swift
import CarKey
// code
```

You can add multiple statements.

```bash
swift run conditional-files --ios --watchos test.swift
```

```swift
import CarKey
// code
```

After

```swift
#if os(iOS) || os(watchOS)
import CarKey
// code
#endif
```

You can negate the #if(os) directive.

```bash
swift run conditional-files not-os --ios --watchos test.swift
```

```swift
import CarKey
// code
```

After

```swift
#if !os(iOS) && !os(watchOS)
import CarKey
// code
#endif
```

You can also add any top/bottom lines.

```bash
swift run conditional-files generic --first-line '#if DEBUG' --last-line \#endif test.swift
```

```swift
import CarKey
// code
```

After

```swift
#if DEBUG
import CarKey
// code
#endif
```
