[https://www.reshma-zachariah.com/](https://www.reshma-zachariah.com/)

This is the source code for an art portfolio website for my
girlfriend.

The website is written in AngularDart. Locally, I store artwork under
`website/web/assets/`, but I don't see a reason to upload it to
GitHub.

The server looks like it's in Ruby, but don't be fooled---it just
serves static files and that's mostly handled by Google's AppEngine
(see `app.yaml`). I picked Ruby because it has "Flexible Environment"
support in AppEngine; I originally tried Haskell but

* I would have only been able to use the "Standard Environment" in
  Google's AppEngine, which has no free quota
* it was way harder to set up:
  * the `fpco/stack-build` Docker image is huge
  * utilizing Stack's caching with Docker was tough (probably the
    right solution is to run a "build server" in a container)
  * I'm on a 2014 MacBook Air that has about 20GB of space left and
    constantly has orange memory pressure in the Activity Monitor even
    when I'm not running anything. It goes red when GHC tries to build
    aeson...

After spending so much time waiting for Haskell builds, Ruby is a
breath of fresh air.

Anyway, it's all overkill for serving static files. I didn't see an
nginx option for AppEngine, so I went with Ruby and copied the example
files.

---

I use `make` for the build system. I don't use recursive `make`;
instead I have a single top-level `Makefile` that includes modules
from subdirectories, and I run all `make` commands from the project
root. Mostly, I run `gmake appengine/<service>/runlocally` and `gmake
appengine/<service>/deploy`. Two great resources helped me a lot with
this:

* This book chapter on using `make` for large projects:
  https://www.oreilly.com/library/view/managing-projects-with/0596006101/ch06.html
  
  It starts off describing the "recursive make" strategy, but that has
  some downsides that I don't like.
  
* This amazing blog series on metaprogramming `make`:
  http://make.mad-scientist.net/category/metaprogramming/

* The manual:
  https://www.gnu.org/software/make/manual/html_node/index.html#SEC_Contents
  
I wanted to use Google's Bazel because I'm familiar with it, but the
Dart support is lacking, and hermeticity made it difficult to use with
the `webdev` command. I spent a lot of time trying. Eventually, I
decided to learn `make` and figure out how to use it like `bazel`.
