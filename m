From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 06/31] cgroup-v2.txt: standardize document format
Date: Sat, 17 Jun 2017 12:18:30 -0300
Message-ID: <20170617121831.541ebb18@vento.lan>
References: <cover.1495156488.git.mchehab@s-opensource.com>
        <1f0804f2263073287d2a106c12f88f295a30cec5.1495156488.git.mchehab@s-opensource.com>
        <20170519145921.GB7174@wtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170519145921.GB7174@wtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Marek Vasut <marek.vasut@gmail.com>, Richard Weinberger <richard@nod.at>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, linux-mtd@lists.infradead.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Em Fri, 19 May 2017 10:59:21 -0400
Tejun Heo <tj@kernel.org> escreveu:

> Hello, Mauro.
> 
> On Thu, May 18, 2017 at 10:22:11PM -0300, Mauro Carvalho Chehab wrote:
> > Each text file under Documentation follows a different
> > format. Some doesn't even have titles!
> > 
> > Change its representation to follow the adopted standard,
> > using ReST markups for it to be parseable by Sphinx:
> > 
> > - Comment the internal index;
> > - Use :Date: and :Author: for authorship;
> > - Mark titles;
> > - Mark literal blocks;
> > - Adjust witespaces;
> > - Mark notes;
> > - Use table notation for the existing tables.  
> 
> If this is the direction we're taking for all docs, looks good to me.
> Do you want me to take the patch through the cgroup tree?

Sorry to take so long to answer... I traveled to a place without access to
my emails, and then got sidetracked by other things after returning from
it.

Yeah, feel free to apply it via your tree. I'm enclosing a
version rebased from linux-next. I solved a few conflicts on it.

Thanks,
Mauro

-

[PATCH v2] cgroup-v2.txt: standardize document format

Each text file under Documentation follows a different
format. Some doesn't even have titles!

Change its representation to follow the adopted standard,
using ReST markups for it to be parseable by Sphinx:

- Comment the internal index;
- Use :Date: and :Author: for authorship;
- Mark titles;
- Mark literal blocks;
- Adjust witespaces;
- Mark notes;
- Use table notation for the existing tables.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index a86f3cb88125..1e198bb07eb5 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1,7 +1,9 @@
-
+================
 Control Group v2
+================
 
-October, 2015		Tejun Heo <tj@kernel.org>
+:Date: October, 2015
+:Author: Tejun Heo <tj@kernel.org>
 
 This is the authoritative documentation on the design, interface and
 conventions of cgroup v2.  It describes all userland-visible aspects
@@ -9,70 +11,72 @@ of cgroup including core and specific controller behaviors.  All
 future changes must be reflected in this document.  Documentation for
 v1 is available under Documentation/cgroup-v1/.
 
-CONTENTS
-
-1. Introduction
-  1-1. Terminology
-  1-2. What is cgroup?
-2. Basic Operations
-  2-1. Mounting
-  2-2. Organizing Processes
-  2-3. [Un]populated Notification
-  2-4. Controlling Controllers
-    2-4-1. Enabling and Disabling
-    2-4-2. Top-down Constraint
-    2-4-3. No Internal Process Constraint
-  2-5. Delegation
-    2-5-1. Model of Delegation
-    2-5-2. Delegation Containment
-  2-6. Guidelines
-    2-6-1. Organize Once and Control
-    2-6-2. Avoid Name Collisions
-3. Resource Distribution Models
-  3-1. Weights
-  3-2. Limits
-  3-3. Protections
-  3-4. Allocations
-4. Interface Files
-  4-1. Format
-  4-2. Conventions
-  4-3. Core Interface Files
-5. Controllers
-  5-1. CPU
-    5-1-1. CPU Interface Files
-  5-2. Memory
-    5-2-1. Memory Interface Files
-    5-2-2. Usage Guidelines
-    5-2-3. Memory Ownership
-  5-3. IO
-    5-3-1. IO Interface Files
-    5-3-2. Writeback
-  5-4. PID
-    5-4-1. PID Interface Files
-  5-5. RDMA
-    5-5-1. RDMA Interface Files
-  5-6. Misc
-    5-6-1. perf_event
-6. Namespace
-  6-1. Basics
-  6-2. The Root and Views
-  6-3. Migration and setns(2)
-  6-4. Interaction with Other Namespaces
-P. Information on Kernel Programming
-  P-1. Filesystem Support for Writeback
-D. Deprecated v1 Core Features
-R. Issues with v1 and Rationales for v2
-  R-1. Multiple Hierarchies
-  R-2. Thread Granularity
-  R-3. Competition Between Inner Nodes and Threads
-  R-4. Other Interface Issues
-  R-5. Controller Issues and Remedies
-    R-5-1. Memory
-
-
-1. Introduction
-
-1-1. Terminology
+.. CONTENTS
+
+   1. Introduction
+     1-1. Terminology
+     1-2. What is cgroup?
+   2. Basic Operations
+     2-1. Mounting
+     2-2. Organizing Processes
+     2-3. [Un]populated Notification
+     2-4. Controlling Controllers
+       2-4-1. Enabling and Disabling
+       2-4-2. Top-down Constraint
+       2-4-3. No Internal Process Constraint
+     2-5. Delegation
+       2-5-1. Model of Delegation
+       2-5-2. Delegation Containment
+     2-6. Guidelines
+       2-6-1. Organize Once and Control
+       2-6-2. Avoid Name Collisions
+   3. Resource Distribution Models
+     3-1. Weights
+     3-2. Limits
+     3-3. Protections
+     3-4. Allocations
+   4. Interface Files
+     4-1. Format
+     4-2. Conventions
+     4-3. Core Interface Files
+   5. Controllers
+     5-1. CPU
+       5-1-1. CPU Interface Files
+     5-2. Memory
+       5-2-1. Memory Interface Files
+       5-2-2. Usage Guidelines
+       5-2-3. Memory Ownership
+     5-3. IO
+       5-3-1. IO Interface Files
+       5-3-2. Writeback
+     5-4. PID
+       5-4-1. PID Interface Files
+     5-5. RDMA
+       5-5-1. RDMA Interface Files
+     5-6. Misc
+       5-6-1. perf_event
+   6. Namespace
+     6-1. Basics
+     6-2. The Root and Views
+     6-3. Migration and setns(2)
+     6-4. Interaction with Other Namespaces
+   P. Information on Kernel Programming
+     P-1. Filesystem Support for Writeback
+   D. Deprecated v1 Core Features
+   R. Issues with v1 and Rationales for v2
+     R-1. Multiple Hierarchies
+     R-2. Thread Granularity
+     R-3. Competition Between Inner Nodes and Threads
+     R-4. Other Interface Issues
+     R-5. Controller Issues and Remedies
+       R-5-1. Memory
+
+
+Introduction
+============
+
+Terminology
+-----------
 
 "cgroup" stands for "control group" and is never capitalized.  The
 singular form is used to designate the whole feature and also as a
@@ -80,7 +84,8 @@ qualifier as in "cgroup controllers".  When explicitly referring to
 multiple individual control groups, the plural form "cgroups" is used.
 
 
-1-2. What is cgroup?
+What is cgroup?
+---------------
 
 cgroup is a mechanism to organize processes hierarchically and
 distribute system resources along the hierarchy in a controlled and
@@ -110,12 +115,14 @@ restrictions set closer to the root in the hierarchy can not be
 overridden from further away.
 
 
-2. Basic Operations
+Basic Operations
+================
 
-2-1. Mounting
+Mounting
+--------
 
 Unlike v1, cgroup v2 has only single hierarchy.  The cgroup v2
-hierarchy can be mounted with the following mount command.
+hierarchy can be mounted with the following mount command::
 
   # mount -t cgroup2 none $MOUNT_POINT
 
@@ -150,10 +157,11 @@ and experimenting easier, the kernel parameter cgroup_no_v1= allows
 disabling controllers in v1 and make them always available in v2.
 
 
-2-2. Organizing Processes
+Organizing Processes
+--------------------
 
 Initially, only the root cgroup exists to which all processes belong.
-A child cgroup can be created by creating a sub-directory.
+A child cgroup can be created by creating a sub-directory::
 
   # mkdir $CGROUP_NAME
 
@@ -180,28 +188,29 @@ moved to another cgroup.
 A cgroup which doesn't have any children or live processes can be
 destroyed by removing the directory.  Note that a cgroup which doesn't
 have any children and is associated only with zombie processes is
-considered empty and can be removed.
+considered empty and can be removed::
 
   # rmdir $CGROUP_NAME
 
 "/proc/$PID/cgroup" lists a process's cgroup membership.  If legacy
 cgroup is in use in the system, this file may contain multiple lines,
 one for each hierarchy.  The entry for cgroup v2 is always in the
-format "0::$PATH".
+format "0::$PATH"::
 
   # cat /proc/842/cgroup
   ...
   0::/test-cgroup/test-cgroup-nested
 
 If the process becomes a zombie and the cgroup it was associated with
-is removed subsequently, " (deleted)" is appended to the path.
+is removed subsequently, " (deleted)" is appended to the path::
 
   # cat /proc/842/cgroup
   ...
   0::/test-cgroup/test-cgroup-nested (deleted)
 
 
-2-3. [Un]populated Notification
+[Un]populated Notification
+--------------------------
 
 Each non-root cgroup has a "cgroup.events" file which contains
 "populated" field indicating whether the cgroup's sub-hierarchy has
@@ -212,7 +221,7 @@ example, to start a clean-up operation after all processes of a given
 sub-hierarchy have exited.  The populated state updates and
 notifications are recursive.  Consider the following sub-hierarchy
 where the numbers in the parentheses represent the numbers of processes
-in each cgroup.
+in each cgroup::
 
   A(4) - B(0) - C(1)
               \ D(0)
@@ -223,18 +232,20 @@ file modified events will be generated on the "cgroup.events" files of
 both cgroups.
 
 
-2-4. Controlling Controllers
+Controlling Controllers
+-----------------------
 
-2-4-1. Enabling and Disabling
+Enabling and Disabling
+~~~~~~~~~~~~~~~~~~~~~~
 
 Each cgroup has a "cgroup.controllers" file which lists all
-controllers available for the cgroup to enable.
+controllers available for the cgroup to enable::
 
   # cat cgroup.controllers
   cpu io memory
 
 No controller is enabled by default.  Controllers can be enabled and
-disabled by writing to the "cgroup.subtree_control" file.
+disabled by writing to the "cgroup.subtree_control" file::
 
   # echo "+cpu +memory -io" > cgroup.subtree_control
 
@@ -246,7 +257,7 @@ are specified, the last one is effective.
 Enabling a controller in a cgroup indicates that the distribution of
 the target resource across its immediate children will be controlled.
 Consider the following sub-hierarchy.  The enabled controllers are
-listed in parentheses.
+listed in parentheses::
 
   A(cpu,memory) - B(memory) - C()
                             \ D()
@@ -266,7 +277,8 @@ controller interface files - anything which doesn't start with
 "cgroup." are owned by the parent rather than the cgroup itself.
 
 
-2-4-2. Top-down Constraint
+Top-down Constraint
+~~~~~~~~~~~~~~~~~~~
 
 Resources are distributed top-down and a cgroup can further distribute
 a resource only if the resource has been distributed to it from the
@@ -277,7 +289,8 @@ the parent has the controller enabled and a controller can't be
 disabled if one or more children have it enabled.
 
 
-2-4-3. No Internal Process Constraint
+No Internal Process Constraint
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Non-root cgroups can only distribute resources to their children when
 they don't have any processes of their own.  In other words, only
@@ -304,9 +317,11 @@ children before enabling controllers in its "cgroup.subtree_control"
 file.
 
 
-2-5. Delegation
+Delegation
+----------
 
-2-5-1. Model of Delegation
+Model of Delegation
+~~~~~~~~~~~~~~~~~~~
 
 A cgroup can be delegated to a less privileged user by granting write
 access of the directory and its "cgroup.procs" file to the user.  Note
@@ -326,7 +341,8 @@ cgroups in or nesting depth of a delegated sub-hierarchy; however,
 this may be limited explicitly in the future.
 
 
-2-5-2. Delegation Containment
+Delegation Containment
+~~~~~~~~~~~~~~~~~~~~~~
 
 A delegated sub-hierarchy is contained in the sense that processes
 can't be moved into or out of the sub-hierarchy by the delegatee.  For
@@ -345,7 +361,7 @@ in from or push out to outside the sub-hierarchy.
 
 For an example, let's assume cgroups C0 and C1 have been delegated to
 user U0 who created C00, C01 under C0 and C10 under C1 as follows and
-all processes under C0 and C1 belong to U0.
+all processes under C0 and C1 belong to U0::
 
   ~~~~~~~~~~~~~ - C0 - C00
   ~ cgroup    ~      \ C01
@@ -360,9 +376,11 @@ not have write access to its "cgroup.procs" files and thus the write
 will be denied with -EACCES.
 
 
-2-6. Guidelines
+Guidelines
+----------
 
-2-6-1. Organize Once and Control
+Organize Once and Control
+~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Migrating a process across cgroups is a relatively expensive operation
 and stateful resources such as memory are not moved together with the
@@ -378,7 +396,8 @@ distribution can be made by changing controller configuration through
 the interface files.
 
 
-2-6-2. Avoid Name Collisions
+Avoid Name Collisions
+~~~~~~~~~~~~~~~~~~~~~
 
 Interface files for a cgroup and its children cgroups occupy the same
 directory and it is possible to create children cgroups which collide
@@ -396,14 +415,16 @@ cgroup doesn't do anything to prevent name collisions and it's the
 user's responsibility to avoid them.
 
 
-3. Resource Distribution Models
+Resource Distribution Models
+============================
 
 cgroup controllers implement several resource distribution schemes
 depending on the resource type and expected use cases.  This section
 describes major schemes in use along with their expected behaviors.
 
 
-3-1. Weights
+Weights
+-------
 
 A parent's resource is distributed by adding up the weights of all
 active children and giving each the fraction matching the ratio of its
@@ -424,7 +445,8 @@ process migrations.
 and is an example of this type.
 
 
-3-2. Limits
+Limits
+------
 
 A child can only consume upto the configured amount of the resource.
 Limits can be over-committed - the sum of the limits of children can
@@ -440,7 +462,8 @@ process migrations.
 on an IO device and is an example of this type.
 
 
-3-3. Protections
+Protections
+-----------
 
 A cgroup is protected to be allocated upto the configured amount of
 the resource if the usages of all its ancestors are under their
@@ -460,7 +483,8 @@ process migrations.
 example of this type.
 
 
-3-4. Allocations
+Allocations
+-----------
 
 A cgroup is exclusively allocated a certain amount of a finite
 resource.  Allocations can't be over-committed - the sum of the
@@ -479,12 +503,14 @@ may be rejected.
 type.
 
 
-4. Interface Files
+Interface Files
+===============
 
-4-1. Format
+Format
+------
 
 All interface files should be in one of the following formats whenever
-possible.
+possible::
 
   New-line separated values
   (when only one value can be written at once)
@@ -519,7 +545,8 @@ can be written at a time.  For nested keyed files, the sub key pairs
 may be specified in any order and not all pairs have to be specified.
 
 
-4-2. Conventions
+Conventions
+-----------
 
 - Settings for a single feature should be contained in a single file.
 
@@ -555,25 +582,25 @@ may be specified in any order and not all pairs have to be specified.
   with "default" as the value must not appear when read.
 
   For example, a setting which is keyed by major:minor device numbers
-  with integer values may look like the following.
+  with integer values may look like the following::
 
     # cat cgroup-example-interface-file
     default 150
     8:0 300
 
-  The default value can be updated by
+  The default value can be updated by::
 
     # echo 125 > cgroup-example-interface-file
 
-  or
+  or::
 
     # echo "default 125" > cgroup-example-interface-file
 
-  An override can be set by
+  An override can be set by::
 
     # echo "8:16 170" > cgroup-example-interface-file
 
-  and cleared by
+  and cleared by::
 
     # echo "8:0 default" > cgroup-example-interface-file
     # cat cgroup-example-interface-file
@@ -586,12 +613,12 @@ may be specified in any order and not all pairs have to be specified.
   generated on the file.
 
 
-4-3. Core Interface Files
+Core Interface Files
+--------------------
 
 All cgroup core files are prefixed with "cgroup."
 
   cgroup.procs
-
 	A read-write new-line separated values file which exists on
 	all cgroups.
 
@@ -617,7 +644,6 @@ All cgroup core files are prefixed with "cgroup."
 	should be granted along with the containing directory.
 
   cgroup.controllers
-
 	A read-only space separated values file which exists on all
 	cgroups.
 
@@ -625,7 +651,6 @@ All cgroup core files are prefixed with "cgroup."
 	the cgroup.  The controllers are not ordered.
 
   cgroup.subtree_control
-
 	A read-write space separated values file which exists on all
 	cgroups.  Starts out empty.
 
@@ -641,23 +666,25 @@ All cgroup core files are prefixed with "cgroup."
 	operations are specified, either all succeed or all fail.
 
   cgroup.events
-
 	A read-only flat-keyed file which exists on non-root cgroups.
 	The following entries are defined.  Unless specified
 	otherwise, a value change in this file generates a file
 	modified event.
 
 	  populated
-
 		1 if the cgroup or its descendants contains any live
 		processes; otherwise, 0.
 
 
-5. Controllers
+Controllers
+===========
 
-5-1. CPU
+CPU
+---
 
-[NOTE: The interface for the cpu controller hasn't been merged yet]
+.. note::
+
+	The interface for the cpu controller hasn't been merged yet
 
 The "cpu" controllers regulates distribution of CPU cycles.  This
 controller implements weight and absolute bandwidth limit models for
@@ -665,36 +692,34 @@ normal scheduling policy and absolute bandwidth allocation model for
 realtime scheduling policy.
 
 
-5-1-1. CPU Interface Files
+CPU Interface Files
+~~~~~~~~~~~~~~~~~~~
 
 All time durations are in microseconds.
 
   cpu.stat
-
 	A read-only flat-keyed file which exists on non-root cgroups.
 
-	It reports the following six stats.
+	It reports the following six stats:
 
-	  usage_usec
-	  user_usec
-	  system_usec
-	  nr_periods
-	  nr_throttled
-	  throttled_usec
+	- usage_usec
+	- user_usec
+	- system_usec
+	- nr_periods
+	- nr_throttled
+	- throttled_usec
 
   cpu.weight
-
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "100".
 
 	The weight in the range [1, 10000].
 
   cpu.max
-
 	A read-write two value file which exists on non-root cgroups.
 	The default is "max 100000".
 
-	The maximum bandwidth limit.  It's in the following format.
+	The maximum bandwidth limit.  It's in the following format::
 
 	  $MAX $PERIOD
 
@@ -703,9 +728,10 @@ All time durations are in microseconds.
 	one number is written, $MAX is updated.
 
   cpu.rt.max
+	.. note::
 
-  [NOTE: The semantics of this file is still under discussion and the
-   interface hasn't been merged yet]
+	   The semantics of this file is still under discussion and the
+	   interface hasn't been merged yet
 
 	A read-write two value file which exists on all cgroups.
 	The default is "0 100000".
@@ -713,7 +739,7 @@ All time durations are in microseconds.
 	The maximum realtime runtime allocation.  Over-committing
 	configurations are disallowed and process migrations are
 	rejected if not enough bandwidth is available.  It's in the
-	following format.
+	following format::
 
 	  $MAX $PERIOD
 
@@ -722,7 +748,8 @@ All time durations are in microseconds.
 	updated.
 
 
-5-2. Memory
+Memory
+------
 
 The "memory" controller regulates distribution of memory.  Memory is
 stateful and implements both limit and protection models.  Due to the
@@ -744,14 +771,14 @@ following types of memory usages are tracked.
 The above list may expand in the future for better coverage.
 
 
-5-2-1. Memory Interface Files
+Memory Interface Files
+~~~~~~~~~~~~~~~~~~~~~~
 
 All memory amounts are in bytes.  If a value which is not aligned to
 PAGE_SIZE is written, the value may be rounded up to the closest
 PAGE_SIZE multiple when read back.
 
   memory.current
-
 	A read-only single value file which exists on non-root
 	cgroups.
 
@@ -759,7 +786,6 @@ PAGE_SIZE multiple when read back.
 	and its descendants.
 
   memory.low
-
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "0".
 
@@ -772,7 +798,6 @@ PAGE_SIZE multiple when read back.
 	protection is discouraged.
 
   memory.high
-
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
 
@@ -785,7 +810,6 @@ PAGE_SIZE multiple when read back.
 	under extreme conditions the limit may be breached.
 
   memory.max
-
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
 
@@ -800,21 +824,18 @@ PAGE_SIZE multiple when read back.
 	utility is limited to providing the final safety net.
 
   memory.events
-
 	A read-only flat-keyed file which exists on non-root cgroups.
 	The following entries are defined.  Unless specified
 	otherwise, a value change in this file generates a file
 	modified event.
 
 	  low
-
 		The number of times the cgroup is reclaimed due to
 		high memory pressure even though its usage is under
 		the low boundary.  This usually indicates that the low
 		boundary is over-committed.
 
 	  high
-
 		The number of times processes of the cgroup are
 		throttled and routed to perform direct memory reclaim
 		because the high memory boundary was exceeded.  For a
@@ -823,13 +844,11 @@ PAGE_SIZE multiple when read back.
 		occurrences are expected.
 
 	  max
-
 		The number of times the cgroup's memory usage was
 		about to go over the max boundary.  If direct reclaim
 		fails to bring it down, the cgroup goes to OOM state.
 
 	  oom
-
 		The number of time the cgroup's memory usage was
 		reached the limit and allocation was about to fail.
 
@@ -838,16 +857,14 @@ PAGE_SIZE multiple when read back.
 
 		Failed allocation in its turn could be returned into
 		userspace as -ENOMEM or siletly ignored in cases like
-		disk readahead.	 For now OOM in memory cgroup kills
+		disk readahead.  For now OOM in memory cgroup kills
 		tasks iff shortage has happened inside page fault.
 
 	  oom_kill
-
 		The number of processes belonging to this cgroup
 		killed by any kind of OOM killer.
 
   memory.stat
-
 	A read-only flat-keyed file which exists on non-root cgroups.
 
 	This breaks down the cgroup's memory footprint into different
@@ -861,73 +878,55 @@ PAGE_SIZE multiple when read back.
 	fixed position; use the keys to look up specific values!
 
 	  anon
-
 		Amount of memory used in anonymous mappings such as
 		brk(), sbrk(), and mmap(MAP_ANONYMOUS)
 
 	  file
-
 		Amount of memory used to cache filesystem data,
 		including tmpfs and shared memory.
 
 	  kernel_stack
-
 		Amount of memory allocated to kernel stacks.
 
 	  slab
-
 		Amount of memory used for storing in-kernel data
 		structures.
 
 	  sock
-
 		Amount of memory used in network transmission buffers
 
 	  shmem
-
 		Amount of cached filesystem data that is swap-backed,
 		such as tmpfs, shm segments, shared anonymous mmap()s
 
 	  file_mapped
-
 		Amount of cached filesystem data mapped with mmap()
 
 	  file_dirty
-
 		Amount of cached filesystem data that was modified but
 		not yet written back to disk
 
 	  file_writeback
-
 		Amount of cached filesystem data that was modified and
 		is currently being written back to disk
 
-	  inactive_anon
-	  active_anon
-	  inactive_file
-	  active_file
-	  unevictable
-
+	  inactive_anon, active_anon, inactive_file, active_file, unevictable
 		Amount of memory, swap-backed and filesystem-backed,
 		on the internal memory management lists used by the
 		page reclaim algorithm
 
 	  slab_reclaimable
-
 		Part of "slab" that might be reclaimed, such as
 		dentries and inodes.
 
 	  slab_unreclaimable
-
 		Part of "slab" that cannot be reclaimed on memory
 		pressure.
 
 	  pgfault
-
 		Total number of page faults incurred
 
 	  pgmajfault
-
 		Number of major page faults incurred
 
 	  workingset_refault
@@ -971,7 +970,6 @@ PAGE_SIZE multiple when read back.
 		Amount of reclaimed lazyfree pages
 
   memory.swap.current
-
 	A read-only single value file which exists on non-root
 	cgroups.
 
@@ -979,7 +977,6 @@ PAGE_SIZE multiple when read back.
 	and its descendants.
 
   memory.swap.max
-
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
 
@@ -987,7 +984,8 @@ PAGE_SIZE multiple when read back.
 	limit, anonymous meomry of the cgroup will not be swapped out.
 
 
-5-2-2. Usage Guidelines
+Usage Guidelines
+~~~~~~~~~~~~~~~~
 
 "memory.high" is the main mechanism to control memory usage.
 Over-committing on high limit (sum of high limits > available memory)
@@ -1010,7 +1008,8 @@ memory; unfortunately, memory pressure monitoring mechanism isn't
 implemented yet.
 
 
-5-2-3. Memory Ownership
+Memory Ownership
+~~~~~~~~~~~~~~~~
 
 A memory area is charged to the cgroup which instantiated it and stays
 charged to the cgroup until the area is released.  Migrating a process
@@ -1028,7 +1027,8 @@ POSIX_FADV_DONTNEED to relinquish the ownership of memory areas
 belonging to the affected files to ensure correct memory ownership.
 
 
-5-3. IO
+IO
+--
 
 The "io" controller regulates the distribution of IO resources.  This
 controller implements both weight based and absolute bandwidth or IOPS
@@ -1037,28 +1037,29 @@ only if cfq-iosched is in use and neither scheme is available for
 blk-mq devices.
 
 
-5-3-1. IO Interface Files
+IO Interface Files
+~~~~~~~~~~~~~~~~~~
 
   io.stat
-
 	A read-only nested-keyed file which exists on non-root
 	cgroups.
 
 	Lines are keyed by $MAJ:$MIN device numbers and not ordered.
 	The following nested keys are defined.
 
+	  ======	===================
 	  rbytes	Bytes read
 	  wbytes	Bytes written
 	  rios		Number of read IOs
 	  wios		Number of write IOs
+	  ======	===================
 
-	An example read output follows.
+	An example read output follows:
 
 	  8:16 rbytes=1459200 wbytes=314773504 rios=192 wios=353
 	  8:0 rbytes=90430464 wbytes=299008000 rios=8950 wios=1252
 
   io.weight
-
 	A read-write flat-keyed file which exists on non-root cgroups.
 	The default is "default 100".
 
@@ -1072,14 +1073,13 @@ blk-mq devices.
 	$WEIGHT" or simply "$WEIGHT".  Overrides can be set by writing
 	"$MAJ:$MIN $WEIGHT" and unset by writing "$MAJ:$MIN default".
 
-	An example read output follows.
+	An example read output follows::
 
 	  default 100
 	  8:16 200
 	  8:0 50
 
   io.max
-
 	A read-write nested-keyed file which exists on non-root
 	cgroups.
 
@@ -1087,10 +1087,12 @@ blk-mq devices.
 	device numbers and not ordered.  The following nested keys are
 	defined.
 
+	  =====		==================================
 	  rbps		Max read bytes per second
 	  wbps		Max write bytes per second
 	  riops		Max read IO operations per second
 	  wiops		Max write IO operations per second
+	  =====		==================================
 
 	When writing, any number of nested key-value pairs can be
 	specified in any order.  "max" can be specified as the value
@@ -1100,24 +1102,25 @@ blk-mq devices.
 	BPS and IOPS are measured in each IO direction and IOs are
 	delayed if limit is reached.  Temporary bursts are allowed.
 
-	Setting read limit at 2M BPS and write at 120 IOPS for 8:16.
+	Setting read limit at 2M BPS and write at 120 IOPS for 8:16::
 
 	  echo "8:16 rbps=2097152 wiops=120" > io.max
 
-	Reading returns the following.
+	Reading returns the following::
 
 	  8:16 rbps=2097152 wbps=max riops=max wiops=120
 
-	Write IOPS limit can be removed by writing the following.
+	Write IOPS limit can be removed by writing the following::
 
 	  echo "8:16 wiops=max" > io.max
 
-	Reading now returns the following.
+	Reading now returns the following::
 
 	  8:16 rbps=2097152 wbps=max riops=max wiops=max
 
 
-5-3-2. Writeback
+Writeback
+~~~~~~~~~
 
 Page cache is dirtied through buffered writes and shared mmaps and
 written asynchronously to the backing filesystem by the writeback
@@ -1165,22 +1168,19 @@ patterns.
 The sysctl knobs which affect writeback behavior are applied to cgroup
 writeback as follows.
 
-  vm.dirty_background_ratio
-  vm.dirty_ratio
-
+  vm.dirty_background_ratio, vm.dirty_ratio
 	These ratios apply the same to cgroup writeback with the
 	amount of available memory capped by limits imposed by the
 	memory controller and system-wide clean memory.
 
-  vm.dirty_background_bytes
-  vm.dirty_bytes
-
+  vm.dirty_background_bytes, vm.dirty_bytes
 	For cgroup writeback, this is calculated into ratio against
 	total available memory and applied the same way as
 	vm.dirty[_background]_ratio.
 
 
-5-4. PID
+PID
+---
 
 The process number controller is used to allow a cgroup to stop any
 new tasks from being fork()'d or clone()'d after a specified limit is
@@ -1195,17 +1195,16 @@ Note that PIDs used in this controller refer to TIDs, process IDs as
 used by the kernel.
 
 
-5-4-1. PID Interface Files
+PID Interface Files
+~~~~~~~~~~~~~~~~~~~
 
   pids.max
-
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
 
 	Hard limit of number of processes.
 
   pids.current
-
 	A read-only single value file which exists on all cgroups.
 
 	The number of processes currently in the cgroup and its
@@ -1220,12 +1219,14 @@ through fork() or clone(). These will return -EAGAIN if the creation
 of a new process would cause a cgroup policy to be violated.
 
 
-5-5. RDMA
+RDMA
+----
 
 The "rdma" controller regulates the distribution and accounting of
 of RDMA resources.
 
-5-5-1. RDMA Interface Files
+RDMA Interface Files
+~~~~~~~~~~~~~~~~~~~~
 
   rdma.max
 	A readwrite nested-keyed file that exists for all the cgroups
@@ -1238,10 +1239,12 @@ of RDMA resources.
 
 	The following nested keys are defined.
 
+	  ==========	=============================
 	  hca_handle	Maximum number of HCA Handles
 	  hca_object 	Maximum number of HCA Objects
+	  ==========	=============================
 
-	An example for mlx4 and ocrdma device follows.
+	An example for mlx4 and ocrdma device follows::
 
 	  mlx4_0 hca_handle=2 hca_object=2000
 	  ocrdma1 hca_handle=3 hca_object=max
@@ -1250,15 +1253,17 @@ of RDMA resources.
 	A read-only file that describes current resource usage.
 	It exists for all the cgroup except root.
 
-	An example for mlx4 and ocrdma device follows.
+	An example for mlx4 and ocrdma device follows::
 
 	  mlx4_0 hca_handle=1 hca_object=20
 	  ocrdma1 hca_handle=1 hca_object=23
 
 
-5-6. Misc
+Misc
+----
 
-5-6-1. perf_event
+perf_event
+~~~~~~~~~~
 
 perf_event controller, if not mounted on a legacy hierarchy, is
 automatically enabled on the v2 hierarchy so that perf events can
@@ -1266,9 +1271,11 @@ always be filtered by cgroup v2 path.  The controller can still be
 moved to a legacy hierarchy after v2 hierarchy is populated.
 
 
-6. Namespace
+Namespace
+=========
 
-6-1. Basics
+Basics
+------
 
 cgroup namespace provides a mechanism to virtualize the view of the
 "/proc/$PID/cgroup" file and cgroup mounts.  The CLONE_NEWCGROUP clone
@@ -1282,7 +1289,7 @@ Without cgroup namespace, the "/proc/$PID/cgroup" file shows the
 complete path of the cgroup of a process.  In a container setup where
 a set of cgroups and namespaces are intended to isolate processes the
 "/proc/$PID/cgroup" file may leak potential system level information
-to the isolated processes.  For Example:
+to the isolated processes.  For Example::
 
   # cat /proc/self/cgroup
   0::/batchjobs/container_id1
@@ -1290,14 +1297,14 @@ to the isolated processes.  For Example:
 The path '/batchjobs/container_id1' can be considered as system-data
 and undesirable to expose to the isolated processes.  cgroup namespace
 can be used to restrict visibility of this path.  For example, before
-creating a cgroup namespace, one would see:
+creating a cgroup namespace, one would see::
 
   # ls -l /proc/self/ns/cgroup
   lrwxrwxrwx 1 root root 0 2014-07-15 10:37 /proc/self/ns/cgroup -> cgroup:[4026531835]
   # cat /proc/self/cgroup
   0::/batchjobs/container_id1
 
-After unsharing a new namespace, the view changes.
+After unsharing a new namespace, the view changes::
 
   # ls -l /proc/self/ns/cgroup
   lrwxrwxrwx 1 root root 0 2014-07-15 10:35 /proc/self/ns/cgroup -> cgroup:[4026532183]
@@ -1315,7 +1322,8 @@ namespace is destroyed.  The cgroupns root and the actual cgroups
 remain.
 
 
-6-2. The Root and Views
+The Root and Views
+------------------
 
 The 'cgroupns root' for a cgroup namespace is the cgroup in which the
 process calling unshare(2) is running.  For example, if a process in
@@ -1324,7 +1332,7 @@ process calling unshare(2) is running.  For example, if a process in
 init_cgroup_ns, this is the real root ('/') cgroup.
 
 The cgroupns root cgroup does not change even if the namespace creator
-process later moves to a different cgroup.
+process later moves to a different cgroup::
 
   # ~/unshare -c # unshare cgroupns in some cgroup
   # cat /proc/self/cgroup
@@ -1338,7 +1346,7 @@ Each process gets its namespace-specific view of "/proc/$PID/cgroup"
 
 Processes running inside the cgroup namespace will be able to see
 cgroup paths (in /proc/self/cgroup) only inside their root cgroup.
-From within an unshared cgroupns:
+From within an unshared cgroupns::
 
   # sleep 100000 &
   [1] 7353
@@ -1347,7 +1355,7 @@ From within an unshared cgroupns:
   0::/sub_cgrp_1
 
 From the initial cgroup namespace, the real cgroup path will be
-visible:
+visible::
 
   $ cat /proc/7353/cgroup
   0::/batchjobs/container_id1/sub_cgrp_1
@@ -1355,7 +1363,7 @@ visible:
 From a sibling cgroup namespace (that is, a namespace rooted at a
 different cgroup), the cgroup path relative to its own cgroup
 namespace root will be shown.  For instance, if PID 7353's cgroup
-namespace root is at '/batchjobs/container_id2', then it will see
+namespace root is at '/batchjobs/container_id2', then it will see::
 
   # cat /proc/7353/cgroup
   0::/../container_id2/sub_cgrp_1
@@ -1364,13 +1372,14 @@ Note that the relative path always starts with '/' to indicate that
 its relative to the cgroup namespace root of the caller.
 
 
-6-3. Migration and setns(2)
+Migration and setns(2)
+----------------------
 
 Processes inside a cgroup namespace can move into and out of the
 namespace root if they have proper access to external cgroups.  For
 example, from inside a namespace with cgroupns root at
 /batchjobs/container_id1, and assuming that the global hierarchy is
-still accessible inside cgroupns:
+still accessible inside cgroupns::
 
   # cat /proc/7353/cgroup
   0::/sub_cgrp_1
@@ -1392,10 +1401,11 @@ namespace.  It is expected that the someone moves the attaching
 process under the target cgroup namespace root.
 
 
-6-4. Interaction with Other Namespaces
+Interaction with Other Namespaces
+---------------------------------
 
 Namespace specific cgroup hierarchy can be mounted by a process
-running inside a non-init cgroup namespace.
+running inside a non-init cgroup namespace::
 
   # mount -t cgroup2 none $MOUNT_POINT
 
@@ -1408,27 +1418,27 @@ the view of cgroup hierarchy by namespace-private cgroupfs mount
 provides a properly isolated cgroup view inside the container.
 
 
-P. Information on Kernel Programming
+Information on Kernel Programming
+=================================
 
 This section contains kernel programming information in the areas
 where interacting with cgroup is necessary.  cgroup core and
 controllers are not covered.
 
 
-P-1. Filesystem Support for Writeback
+Filesystem Support for Writeback
+--------------------------------
 
 A filesystem can support cgroup writeback by updating
 address_space_operations->writepage[s]() to annotate bio's using the
 following two functions.
 
   wbc_init_bio(@wbc, @bio)
-
 	Should be called for each bio carrying writeback data and
 	associates the bio with the inode's owner cgroup.  Can be
 	called anytime between bio allocation and submission.
 
   wbc_account_io(@wbc, @page, @bytes)
-
 	Should be called for each data segment being written out.
 	While this function doesn't care exactly when it's called
 	during the writeback session, it's the easiest and most
@@ -1449,7 +1459,8 @@ cases by skipping wbc_init_bio() or using bio_associate_blkcg()
 directly.
 
 
-D. Deprecated v1 Core Features
+Deprecated v1 Core Features
+===========================
 
 - Multiple hierarchies including named ones are not supported.
 
@@ -1463,9 +1474,11 @@ D. Deprecated v1 Core Features
   at the root instead.
 
 
-R. Issues with v1 and Rationales for v2
+Issues with v1 and Rationales for v2
+====================================
 
-R-1. Multiple Hierarchies
+Multiple Hierarchies
+--------------------
 
 cgroup v1 allowed an arbitrary number of hierarchies and each
 hierarchy could host any number of controllers.  While this seemed to
@@ -1517,7 +1530,8 @@ how memory is distributed beyond a certain level while still wanting
 to control how CPU cycles are distributed.
 
 
-R-2. Thread Granularity
+Thread Granularity
+------------------
 
 cgroup v1 allowed threads of a process to belong to different cgroups.
 This didn't make sense for some controllers and those controllers
@@ -1560,7 +1574,8 @@ misbehaving and poorly abstracted interfaces and kernel exposing and
 locked into constructs inadvertently.
 
 
-R-3. Competition Between Inner Nodes and Threads
+Competition Between Inner Nodes and Threads
+-------------------------------------------
 
 cgroup v1 allowed threads to be in any cgroups which created an
 interesting problem where threads belonging to a parent cgroup and its
@@ -1579,7 +1594,7 @@ simply weren't available for threads.
 
 The io controller implicitly created a hidden leaf node for each
 cgroup to host the threads.  The hidden leaf had its own copies of all
-the knobs with "leaf_" prefixed.  While this allowed equivalent
+the knobs with ``leaf_`` prefixed.  While this allowed equivalent
 control over internal threads, it was with serious drawbacks.  It
 always added an extra layer of nesting which wouldn't be necessary
 otherwise, made the interface messy and significantly complicated the
@@ -1600,7 +1615,8 @@ This clearly is a problem which needs to be addressed from cgroup core
 in a uniform way.
 
 
-R-4. Other Interface Issues
+Other Interface Issues
+----------------------
 
 cgroup v1 grew without oversight and developed a large number of
 idiosyncrasies and inconsistencies.  One issue on the cgroup core side
@@ -1628,9 +1644,11 @@ cgroup v2 establishes common conventions where appropriate and updates
 controllers so that they expose minimal and consistent interfaces.
 
 
-R-5. Controller Issues and Remedies
+Controller Issues and Remedies
+------------------------------
 
-R-5-1. Memory
+Memory
+~~~~~~
 
 The original lower boundary, the soft limit, is defined as a limit
 that is per default unset.  As a result, the set of cgroups that

