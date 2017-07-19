From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v4
Date: Wed, 19 Jul 2017 15:44:33 -0400
Message-ID: <20170719194439.2915602-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=DOebJNkneyG8N2XsHJX+fFbrIa2UW25HsL/OkjmM8zs=;
        b=HSQPTlhDaLOfluwE+9aJzwm+B6pNEqNN1jm/Y3GcYYPHnAvgtcbmPx9xBBSOiF+ItD
         C/Id6H5+/UazNFTTFDEmgpdqFho5omTvdeNutkYFGvroi89hiVc6Pdq/AoShIoF/vYbD
         vLhggbAS5OJ/RZXe5QnULC5SzTGkAWJO9e56Td39PcG9OT985N8++D+nALxm364Q/54+
         d4hTuIKsTJQbeZOeeUVrBMW8gYeRXwoan68e8kcuRgRWAIbgVsBZKQNoTM5lRe5DEMyX
         3dhVcPqjbWtYk5uftUDVLA7QzJ3/bAQ4wwQnR5GQyJDLySTZxoD7p5CWkQzcqex6XnOD
         DWLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Hello,

This is v4 of cgroup2 thread mode patchset.  The changes from v3[L]
are all fairly minor.  Peter and Waiman are okay with the approach and
I'll apply these patches to cgorup/for-4.14 unless there are further
objections.  Please speak up if there are any further concerns.

* Documentation updates as suggested by Waiman.

* () dropped from cgroup.type output.

* Other minor fixes and updates.

* Tried to add "threaded" column to /proc/cgroups but systemd fails to
  parse and boot if the field is added.  I don't think we can ever add
  new field to that file.  I'll probably add
  cgroup.threaded_controllers file.  It's nicer to contain the
  information inside cgroupfs anyway.  Will follow up on this.

It is largely based on the discussions that we had at the plumbers
last year.  Here's the rough outline.

* Thread mode is explicitly enabled on a cgroup by writing "threaded"
  into "cgroup.type" file.  The cgroup shouldn't have any processes or
  child cgroups.  A threaded cgroup joins the the parent's resource
  domain and becomes a part of the threaded subtree anchored at the
  nearest domain ancestor, which is called the threaded domain cgroup
  of the subtree.

* Threads can be put anywhere in a threaded subtree by writing TIDs
  into "cgroup.threads" file.  Process granularity and
  no-internal-process constraint don't apply in a threaded subtree.

* To be used in a threaded subtree, controllers should explicitly
  declare thread mode support and should be able to handle internal
  competition in some way.

* The threaded domain cgroup of a threaded subtree serves as the
  resource domain for the whole subtree.  This is where all the
  controllers are guaranteed to have a common ground and resource
  consumptions in the threaded subtree which aren't tied to a specific
  thread are charged.  Non-threaded controllers never see beyond
  thread root and can assume that all controllers will follow the same
  rules upto that point.

* Unlike other cgroups, the system root cgroup can serve as parent to
  domain child cgroups and threaded domains to threaded subtrees.

This allows threaded controllers to implement thread granular resource
control without getting in the way of system level resource
partitioning.

For more details on the interface and behavior, please refer to 0005.

This patchset contains the following six patches.

 0001-cgroup-reorganize-cgroup.procs-task-write-path.patch
 0002-cgroup-add-flags-to-css_task_iter_start-and-implemen.patch
 0003-cgroup-introduce-cgroup-dom_cgrp-and-threaded-css_se.patch
 0004-cgroup-implement-CSS_TASK_ITER_THREADED.patch
 0005-cgroup-implement-cgroup-v2-thread-support.patch
 0006-cgroup-update-debug-controller-to-print-out-thread-m.patch

0001-0005 implement cgroup2 thread mode.  0006 enables debug
controller on it.

The patchset is based on the current cgroup/for-4.14 27f26753f8c0
("cgroup: replace css_set walking populated test with testing
cgrp->nr_populated_csets") and also available in the following git
branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-threads-v4

diffstat follows.

 Documentation/cgroup-v2.txt     |  185 +++++++++-
 include/linux/cgroup-defs.h     |   45 ++
 include/linux/cgroup.h          |   15 
 kernel/cgroup/cgroup-internal.h |   12 
 kernel/cgroup/cgroup-v1.c       |   69 +++
 kernel/cgroup/cgroup.c          |  711 +++++++++++++++++++++++++++++++---------
 kernel/cgroup/cpuset.c          |    6 
 kernel/cgroup/debug.c           |   53 ++
 kernel/cgroup/freezer.c         |    6 
 kernel/cgroup/pids.c            |    1 
 kernel/events/core.c            |    1 
 mm/memcontrol.c                 |    2 
 net/core/netclassid_cgroup.c    |    2 
 13 files changed, 904 insertions(+), 204 deletions(-)

Thanks.

--
tejun

[L] http://lkml.kernel.org/r/20170717020721.3612468-1-tj@kernel.org
