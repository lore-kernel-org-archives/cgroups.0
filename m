From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v3
Date: Sun, 16 Jul 2017 22:07:15 -0400
Message-ID: <20170717020721.3612468-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=0b3nSacWxouGCP4iD4HjkhhfkuXadO0bBBFxvbVtgCk=;
        b=bnU1F8TKdWnqo75JukDghksO/MTI3W3TR2HAeJ5gjgIdcnCteAo9VdsiLUDG1v+Z88
         O3zwUcbcOcAmZhPcCv5rL0g35GHZDDn9st3xQdFAAT9j/LFXgvzzLSkFFL5JAi/bqBH8
         02fEHAI2F1LXQZvN+OUK8NM6jn3ODqMRnklYs79maneWqWc+4K2vO8870+RxP/xZ1U/l
         KnI1xDMcn+ohw7BEr0ckQL1DXp+KpLt99TMZO6+kdpumKqsCPjQ3J54PyY99/gaR70SQ
         Dbx3aZVd5V+0M0DxoiTdgvDo39pGLS9NMOZtuU91RCoDjTuaH0VDHlh8Hn8mNDJi2wHD
         GT3Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello,

This is v3 of cgroup2 thread mode patchset.  The changes from v2[L]
are

* Switched to marking each cgroup threaded instead of doing it
  per-subtree as suggested by PeterZ.  This allows more flexibility
  and removes certain interface quirks.

* Dropped RFC tag and excluded cpu controller patches from this
  patchset as threaded mode behaviors can easily be verified with the
  pid controller.  Will follow up with cpu controller patchset later.

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

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-threads-v3

diffstat follows.

 Documentation/cgroup-v2.txt     |  181 +++++++++-
 include/linux/cgroup-defs.h     |   45 ++
 include/linux/cgroup.h          |   15 
 kernel/cgroup/cgroup-internal.h |   12 
 kernel/cgroup/cgroup-v1.c       |   69 +++
 kernel/cgroup/cgroup.c          |  712 +++++++++++++++++++++++++++++++---------
 kernel/cgroup/cpuset.c          |    6 
 kernel/cgroup/debug.c           |   58 ++-
 kernel/cgroup/freezer.c         |    6 
 kernel/cgroup/pids.c            |    1 
 kernel/events/core.c            |    1 
 mm/memcontrol.c                 |    2 
 net/core/netclassid_cgroup.c    |    2 
 13 files changed, 906 insertions(+), 204 deletions(-)

Thanks.

--
tejun

[L] http://lkml.kernel.org/r/20170610140351.10703-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
