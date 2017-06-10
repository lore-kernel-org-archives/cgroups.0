From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v2
Date: Sat, 10 Jun 2017 10:03:41 -0400
Message-ID: <20170610140351.10703-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=eVt26OwX+nEushmJaB2YKADFRzbGeye/fVTxqmQQ48Q=;
        b=ScbG/dfVaYzblmttVsp0EuMQ1RRgkULP5D63yTnvdGxkdIKnLG2lMakNz3MbUw0dq+
         JhCx8y8pqqAVvtQPMJ2UoCvd46SPPCIA/Y73Bp5hrWNlmJ53lopIKZl8dePL28afCqSy
         EtRNBsMzwXxkRfycAkUYjZoSmJIwtjqTeUYBXyJp52LLCdMIZ9ILrhketwBRph0lopxK
         bhHa6VD2Vd5Zkwm8/F2MWAbAT03A/c2ewVnvKxl+HatcjSyT71zsvDOk1pO83pFsGnex
         mpu6QkCBh5/pDF53y9aMieVc0KDkJIavFtoORm4OobkPbXLWtfERDzr1xPQqEEa+n4C2
         vqug==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello,

This is v2 of cgroup2 thread mode patchset.  The changes from the last
take[L] are

* Support for mixed thread mode for the root cgroup added.  This
  allows the root cgroup to serve as both a thread root and a parent
  to domain cgroups.  This allows users to use thread mode without any
  nesting while not interfering with domain level cgroup operations.
  Note that this simply makes use of the fact that the system root has
  always been exempt from no-internal-process constraint.  The whole
  resource hierarchy still follows the same basic rules
  w.r.t. resource domains.

* Thread mode enable / disable now piggy backs on the existing control
  mask update mechanism rather than implementing manual css_set update
  mechanism of its own.  This makes the mechanism simpler and more
  flexible.

* Fixes and cleanups, including a fix from Waiman.

It is largely based on the discussions that we had at the plumbers
last year.  Here's the rough outline.

* Thread mode is explicitly enabled on a cgroup by writing "enable"
  into "cgroup.threads" file.  The cgroup shouldn't have any child
  cgroups or enabled controllers.

* Once enabled, arbitrary sub-hierarchy can be created and threads can
  be put anywhere in the subtree by writing TIDs into "cgroup.threads"
  file.  Process granularity and no-internal-process constraint don't
  apply in a threaded subtree.

* To be used in a threaded subtree, controllers should explicitly
  declare thread mode support and should be able to handle internal
  competition in some way.

* The root of a threaded subtree serves as the resource domain for the
  whole subtree.  This is where all the controllers are guaranteed to
  have a common ground and resource consumptions in the threaded
  subtree which aren't tied to a specific thread are charged.
  Non-threaded controllers never see beyond thread root and can assume
  that all controllers will follow the same rules upto that point.

* Root cgroup can enable thread mode anytime and a first level child
  can opt-in to that thread subtree anchored at root by writing "join"
  to "cgroup.threads" files, start its own thread subtree or just be a
  normal cgroup.

This allows threaded controllers to implement thread granular resource
control without getting in the way of system level resource
partitioning.

This patchset contains the following ten patches.  For more details on
the interface and behavior, please refer to 0007.

 0001-cgroup-separate-out-cgroup_has_tasks.patch
 0002-cgroup-reorganize-cgroup.procs-task-write-path.patch
 0003-cgroup-Fix-reference-counting-bug-in-cgroup_procs_wr.patch
 0004-cgroup-add-flags-to-css_task_iter_start-and-implemen.patch
 0005-cgroup-introduce-cgroup-proc_cgrp-and-threaded-css_s.patch
 0006-cgroup-implement-CSS_TASK_ITER_THREADED.patch
 0007-cgroup-implement-cgroup-v2-thread-support.patch
 0008-sched-Misc-preps-for-cgroup-unified-hierarchy-interf.patch
 0009-sched-Implement-interface-for-cgroup-unified-hierarc.patch
 0010-sched-Make-cpu-cpuacct-threaded-controllers.patch

0001-0007 implement cgroup2 thread mode.  0008-0010 enable CPU
controller on cgroup2 and mark them as supporting thread mode.
0008-0010 are included for reference.

The patchset is based on the current master 179145e6312b ("Merge tag
'iommu-fixes-v4.12-rc4' of
git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu") and also
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-threads-v2

diffstat follows.

 Documentation/cgroup-v2.txt     |   99 +++++
 include/linux/cgroup-defs.h     |   34 +
 include/linux/cgroup.h          |   12 
 kernel/cgroup/cgroup-internal.h |    8 
 kernel/cgroup/cgroup-v1.c       |   64 +++
 kernel/cgroup/cgroup.c          |  727 ++++++++++++++++++++++++++++++++--------
 kernel/cgroup/cpuset.c          |    6 
 kernel/cgroup/freezer.c         |    6 
 kernel/cgroup/pids.c            |    1 
 kernel/events/core.c            |    1 
 kernel/sched/core.c             |  150 ++++++++
 kernel/sched/cpuacct.c          |   53 ++
 kernel/sched/cpuacct.h          |    5 
 mm/memcontrol.c                 |    2 
 net/core/netclassid_cgroup.c    |    2 
 15 files changed, 992 insertions(+), 178 deletions(-)

Thanks.

--
tejun

[L] http://lkml.kernel.org/r/20170202200632.13992-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
