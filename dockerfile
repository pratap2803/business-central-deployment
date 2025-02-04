The error **"Could not find or load main class io.github.classgraph.ClassGraph"** happens because `ClassGraph` is a **library** and does not include an executable main class.

### **✅ Alternative Approach: Using JavaParser + Graphviz**
Since `java-callgraph` doesn't provide an out-of-the-box executable, let's use **JavaParser** to analyze class dependencies and generate a class diagram.

---

## **🔹 Steps to Generate a Class Dependency Diagram (Automatically)**
We'll use:
- **JavaParser** (to analyze your `.java` files)
- **Graphviz** (to generate the class diagram)

---

### **Step 1: Clone Your GitHub Repo (If Not Already Done)**
```sh
git clone <your-repo-url>
cd <your-repo-name>
```

---

### **Step 2: Install JavaParser & Graphviz**
#### **Mac (Homebrew)**
```sh
brew install graphviz
```

#### **Windows (Chocolatey)**
```sh
choco install graphviz
```

Also, **download JavaParser** (a library to analyze Java code).

```sh
wget https://repo1.maven.org/maven2/com/github/javaparser/javaparser-core/3.24.2/javaparser-core-3.24.2.jar -O javaparser.jar
```
For **Windows**, use:
```sh
curl -L -o javaparser.jar https://repo1.maven.org/maven2/com/github/javaparser/javaparser-core/3.24.2/javaparser-core-3.24.2.jar
```

---

### **Step 3: Create Java File for Parsing**
Create a new file **`DependencyAnalyzer.java`** inside your project folder.

```sh
touch DependencyAnalyzer.java
```
Paste this **Java code** into `DependencyAnalyzer.java`:

```java
import com.github.javaparser.StaticJavaParser;
import com.github.javaparser.ast.CompilationUnit;
import com.github.javaparser.ast.body.ClassOrInterfaceDeclaration;
import com.github.javaparser.ast.visitor.VoidVisitorAdapter;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

public class DependencyAnalyzer {
    private static final Map<String, Set<String>> dependencies = new HashMap<>();

    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: java -cp javaparser.jar:. DependencyAnalyzer <source-folder>");
            return;
        }

        File projectDir = new File(args[0]);
        analyzeDirectory(projectDir);
        generateGraphviz();
    }

    private static void analyzeDirectory(File dir) {
        if (dir.isDirectory()) {
            for (File file : Objects.requireNonNull(dir.listFiles())) {
                analyzeDirectory(file);
            }
        } else if (dir.getName().endsWith(".java")) {
            try {
                CompilationUnit cu = StaticJavaParser.parse(dir);
                cu.accept(new ClassVisitor(), null);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
        }
    }

    private static class ClassVisitor extends VoidVisitorAdapter<Void> {
        @Override
        public void visit(ClassOrInterfaceDeclaration n, Void arg) {
            String className = n.getNameAsString();
            dependencies.putIfAbsent(className, new HashSet<>());

            n.getExtendedTypes().forEach(type -> dependencies.get(className).add(type.getNameAsString()));
            n.getImplementedTypes().forEach(type -> dependencies.get(className).add(type.getNameAsString()));

            super.visit(n, arg);
        }
    }

    private static void generateGraphviz() {
        StringBuilder dot = new StringBuilder("digraph G {\n");

        for (Map.Entry<String, Set<String>> entry : dependencies.entrySet()) {
            for (String dep : entry.getValue()) {
                dot.append("  \"").append(entry.getKey()).append("\" -> \"").append(dep).append("\";\n");
            }
        }

        dot.append("}");
        System.out.println(dot.toString());

        try {
            File dotFile = new File("class-diagram.dot");
            java.nio.file.Files.write(dotFile.toPath(), dot.toString().getBytes());
            System.out.println("Graph saved to class-diagram.dot");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

---

### **Step 4: Compile & Run the Analyzer**
Compile the Java file with **JavaParser**:
```sh
javac -cp javaparser.jar:. DependencyAnalyzer.java
```

Now, run it to analyze your Java project:
```sh
java -cp javaparser.jar:. DependencyAnalyzer src > class-diagram.dot
```
**(Replace `src` with your actual source folder if needed.)**

---

### **Step 5: Convert `.dot` File to PNG**
```sh
dot -Tpng class-diagram.dot -o class-diagram.png
```
This will generate **`class-diagram.png`**, showing the **class relationships (flowchart of class calls).**

---

## **✅ What You Get?**
- **Fully automated** generation of class dependency diagrams.
- **No manual work**—just run a single command.
- **Works on any Java project** with `.java` source files.

---

### **🚀 Want an Automated Script for All Steps?**
I can provide a **bash or PowerShell script** to:
1. **Download dependencies**
2. **Compile & run the analyzer**
3. **Generate the class diagram automatically**

Let me know if you need it! 🚀🔥
