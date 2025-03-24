Since you're getting the error **"mvn is not recognized as an internal or external command"**, it means that Maven's path is not set correctly. Follow these steps to fix it:

---

## **Step 1: Verify Maven Installation**
1. Open **File Explorer** and navigate to:
   ```
   C:\Program Files\Apache\Maven
   ```
   or  
   ```
   C:\apache-maven-<version>
   ```
2. Inside the Maven folder, you should see a `bin` folder. The full path should look like:
   ```
   C:\Program Files\Apache\Maven\bin
   ```
   If you **can't find Maven**, you need to download and install it first.

---

## **Step 2: Set `MAVEN_HOME` and `PATH` Variables**
### **1. Open Environment Variables**
- Press **`Win + R`**, type **`sysdm.cpl`**, and press **Enter**.
- Go to the **Advanced** tab.
- Click **Environment Variables**.

### **2. Add `MAVEN_HOME`**
- Under **System Variables**, click **New**.
- In **Variable name**, type:
  ```
  MAVEN_HOME
  ```
- In **Variable value**, enter your **Maven installation path**:
  ```
  C:\Program Files\Apache\Maven
  ```
- Click **OK**.

### **3. Update the `PATH` Variable**
- In **System Variables**, find **Path** and click **Edit**.
- Click **New** and add:
  ```
  %MAVEN_HOME%\bin
  ```
- Click **OK** → **OK** → **OK** to save.

---

## **Step 3: Verify the Configuration**
1. **Restart Command Prompt** (close and reopen it).
2. Run:
   ```sh
   mvn -version
   ```
   If everything is set up correctly, you should see Maven's version.

---

## **Step 4: If `mvn` is Still Not Recognized**
- **Restart your computer** and try `mvn -version` again.
- If the issue persists, **run `echo %PATH%`** and **`echo %MAVEN_HOME%`** to check if they are set correctly.
- Let me know the output if the issue is still there! 🚀
