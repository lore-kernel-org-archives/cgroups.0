From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Thu,  2 Feb 2017 15:06:27 -0500
Message-ID: <20170202200632.13992-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=DlUDrqa5JMZeMNXgcCI1mM2ge1Go+JmfBT+OBQOlrK0=;
        b=kgaTJwvAepEMo0Vy4HK3g/IVyd6NisClQW4MqY8FP8QckdlEPK1Kjwe2VyjamKdX3Z
         LTDZHkv3rGaHoX+eR1alnUKeFgrQxSFdiO3AWGJEuz+gMDSUGQYKYlxurv1Bd6ySU1EN
         NeKFUirycO+gauR6/2qPIeOb8GNVs3fyHKNBbBKcCatvVmkvWfInGb+HkpRYCoruzKWQ
         Gb0SnQtckRNuU/L+qBAtSKSaDmX5FHdNggQH1qZnM/JEk+z4g6131ZhKOfy98945IN/E
         XGeaLFIh1/+gH28S2Aa+uyO5ZfQn8oKnNpWgAokvgaynrn3f9fjxbuok/5vbGqxVVSb/
         HvWQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hello,

This patchset implements cgroup v2 thread mode.  It is largely based
on the discussions that we had at the plumbers last year.  Here's the
rough outline.

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

This allows threaded controllers to implement thread granular resource
control without getting in the way of system level resource
partitioning.

This patchset contains the following five patches.  For more details
on the interface and behavior, please refer to the last patch.

 0001-cgroup-reorganize-cgroup.procs-task-write-path.patch
 0002-cgroup-add-flags-to-css_task_iter_start-and-implemen.patch
 0003-cgroup-introduce-cgroup-proc_cgrp-and-threaded-css_s.patch
 0004-cgroup-implement-CSS_TASK_ITER_THREADED.patch
 0005-cgroup-implement-cgroup-v2-thread-support.patch

This patchset is on top of cgroup/for-4.11 63f1ca59453a ("Merge branch
'cgroup/for-4.11-rdmacg' into cgroup/for-4.11") and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-threads

diffstat follows.  Thanks.

 Documentation/cgroup-v2.txt     |   75 ++++-
 include/linux/cgroup-defs.h     |   38 ++
 include/linux/cgroup.h          |   12 
 kernel/cgroup/cgroup-internal.h |    8 
 kernel/cgroup/cgroup-v1.c       |   64 +++-
 kernel/cgroup/cgroup.c          |  589 ++++++++++++++++++++++++++++++++--------
 kernel/cgroup/cpuset.c          |    6 
 kernel/cgroup/freezer.c         |    6 
 kernel/cgroup/pids.c            |    1 
 kernel/events/core.c            |    1 
 mm/memcontrol.c                 |    2 
 net/core/netclassid_cgroup.c    |    2 
 12 files changed, 671 insertions(+), 133 deletions(-)

-- 
tejun
