# FM-Assignments

This is a repository for my assignemnts from the course _Formal Methods in Software Engineering_ (University of Tehran, fall 2021).

These assignments cover an introductory level of knowledge for the following:
* [Alloy][1] specification language and analyzer
* [Spin][2]  verification tool
* [NuSMV][3] model checker

# Dependencies

The languages and tools described above are needed for running the tests.

* Alloy comes as a ``self-contained executable''.
  The usual way of running Alloy would be to run the following in a terminal:

  ```
  java -jar org.alloytools.alloy.dist.jar
  ```

  If you are using Visual Studio (VS) Code, you can use an extension for Alloy.

* A detailed explanation for installing Spin can be found on [this page][4].
  If you are using a Debian-based Linux distribution, you can install Spin with APT:
  
  ```
  sudo apt install spin
  ```
* NuSMV binaries can be downloaded from [this page]. You can place these binaries
  in a directory included in your PATH.


# Running Spin

Spin takes programs written in Promela as input.
There is a helper makefile in `spin-tokenring`;
you can use it to compile the Promela source code and generate an executable
(`pan_<trb|tru>`, depending on which token ring you have compiled).

You can then check the specified LTL properties using the executable from the previous stage.

[1]: http://alloytools.org/
[2]: https://spinroot.com/spin/whatispin.html
[3]: https://nusmv.fbk.eu/
[4]: https://spinroot.com/spin/Man/README.html
