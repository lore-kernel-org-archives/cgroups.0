From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET REPOST for-4.15] cgroup, sched: cgroup2 interface for CPU controller (on basic acct)
Date: Mon, 25 Sep 2017 09:00:17 -0700
Message-ID: <20170925160019.683562-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=shf69iI4iNB3AMyhVgGFlFKJozw0lx+rOFb0W/ECCG0=;
        b=uz4CJLWpRaWFSPRJoWT1hZJZ9resplUaN9tiqJ/usQPS0VAqfc39B5VRPWDP5Sj09s
         JeOoFjB9WwYx5m7fbpSFAbligwPQKjdr7L8vFAnS4wCv05gPsqffq6JEHWJym4SBPV6d
         8NQ3pclyRAd4fHJ29RVFL9e1dEShbM8HN+T68m8o+B/eqEnJuRUkxEFbNlujNdth3Cbd
         Z9Js0Sdmrf568EQDjPtyUVhzRqXz6n/iwBBp5CQGGDnvOBttP1HNVYWaA9FD9mjn2ubB
         gpizuk0AX2tCdbBTtZc7WBkZLT4d1skTi1jWnIPa4OzqKNHdcYNay9pnWlBXbZf9u2yh
         hXEw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello,

(Rebased on cgroup/for-4.15, no real changes.  Once acked, I think
 it'd be easiest to route these through the cgroup branch;
 alternatively, we can pull cgroup/for-4.15 to a sched branch and
 apply these there.)

These are two patches to implement the cgroup2 CPU controller
interface.  Changes from the last revision[L].

* Updated on top of the cgroup2 basic resource accounting patchset[B]
  and now uses cgroup2's CPU accounting instead of cpuacct as stat
  source.

* cpuacct is no longer necessary and not converted.

This patchset contains the following two patches.

 0001-sched-Misc-preps-for-cgroup-unified-hierarchy-interf.patch
 0002-sched-Implement-interface-for-cgroup-unified-hierarc.patch

It's on top of the cgroup2 basic resource accounting patchset, which
has been merged to cgroup/for-4.15, and available in the following git
branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-cpu-on-basic-acct

diffstat follows.  Thanks.

 Documentation/cgroup-v2.txt |   36 ++------
 kernel/sched/core.c         |  179 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 187 insertions(+), 28 deletions(-)

--
tejun

[L] http://lkml.kernel.org/r/20170720184808.1433868-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[B] http://lkml.kernel.org/r/20170811163754.3939102-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
