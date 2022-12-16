[![Swift](https://github.com/MarcoEidinger/conditional-files/actions/workflows/swift.yml/badge.svg)](https://github.com/MarcoEidinger/conditional-files/actions/workflows/swift.yml) [![codecov](https://codecov.io/github/MarcoEidinger/conditional-files/branch/main/graph/badge.svg?token=OW4DFFVD4R)](https://codecov.io/github/MarcoEidinger/conditional-files)

# ConditionalFiles

A command-line tool intended to insert a conditional compilation statement in multiple Swift files at once.

And generic enough being able to process multiple files and **insert *any* text at the top and the bottom of a file** :)

## if os()

Example:

```bash
swift run conditional-files --ios test.swift
```

<table>
<tr>
<td> File (before) </td> <td> File (after) </td>
</tr>
<tr>
<td>

```swift
import CarKey
// code
```

</td>
<td>
    
```swift
#if os(iOS)
import CarKey
// code
#endif
```

</td>
</tr>
</table>

You can process all files in the current directory and its sub-folders by specifying a single dot (`.`) as argument. Example: `swift run conditional-files --ios .`

You can also remove an existing compiler directive.

```bash
swift run conditional-files --ios --undo test.swift
```

<table>
<tr>
<td> File (before) </td> <td> File (after)
</tr>
<tr>
<td>

```swift
#if os(iOS)
import CarKey
// code
#endif
```

</td>
<td>
    
```swift
import CarKey
// code
```

</td>
</tr>
</table>

## if os() || os() ...

You can add multiple statements.

```bash
swift run conditional-files --ios --watchos test.swift
```

<table>
<tr>
<td> File (before) </td> <td> File (after)
</tr>
<tr>
<td>

```swift
import CarKey
// code
```

</td>
<td>
    
```swift
#if os(iOS) || os(watchOS)
import CarKey
// code
#endif
```

</td>
</tr>
</table>

## if !os()

You can negate the #if(os) directive.

```bash
swift run conditional-files not-os --ios --watchos test.swift
```

<table>
<tr>
<td> File (before) </td> <td> File (after)
</tr>
<tr>
<td>

```swift
import CarKey
// code
```

</td>
<td>
    
```swift
#if !os(iOS) && !os(watchOS)
import CarKey
// code
#endif
```

</td>
</tr>
</table>

## any (generic)

You can also add any top/bottom lines.

```text
swift run conditional-files generic --first-line '#if DEBUG' --last-line \#endif test.swift
```

<table>
<tr>
<td> File (before) </td> <td> File (after)
</tr>
<tr>
<td>

```swift
import CarKey
// code
```

</td>
<td>
    
```swift
#if DEBUG
import CarKey
// code
#endif
```

</td>
</tr>
</table>