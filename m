From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET for-4.14] cgroup, sched: cgroup2 basic resource accounting
Date: Fri, 11 Aug 2017 09:37:51 -0700
Message-ID: <20170811163754.3939102-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=1UxqlEDQoiiGhB39IQnT1llLj7z5GKABnKpenAJN+ts=;
        b=U2AI9ukB6WBm6xyc42x5/Tt1FGzpB3qbR/52UaJB/g2FpcTTGtOEx0BA4slIHIiLRQ
         ZPuzFKk6zHZCC8MPEoxo4Po6YQKoSNMcSxt/U2ccZkXpFRltltT3ln1sy/H5encpmqdc
         X18as6mJahwU8uinWjfa0zeJwHpYSJjujJdERG02l2iw6z28hWezLlTTcCrkjlSVQRzG
         oFvMrFJpMiTjk5Z6VgpdHSUn2FrykE1/IUOYFNrrt/MI68b3EZnFVlDIUGcWb8mlp6wE
         NsHd6AwyYzkdH26W/G8jwQgXUjx4A2JhCgCkX3zVDG54KcIcCjHlZmiLh7iJr7xA3BWS
         wxYw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello,

This patchset implement cgroup2 basic resource accounting and track
CPU usages on all cgroups by default.

In cgroup1, collecting non-trivial statistics by default wasn't viable
because there can be any number of hierarchies.  While cgroup2's
single hierarchy removes that part of the problem, propagating up the
hierarchy on each accounting event is still problematic.

This patchset implements cgroup2 basic resource accounting mechanism
which keeps all the counters per-cpu and propagates lazily to allow
the accounting side to only perform single per-cpu accounting in most
cases and the reader side's complexity to be O(nr updated descendants)
instead of O(nr total descendants).

This will be used by cgroup2 CPU interface later.  The patchset
contains the following three patches.

  0001-sched-cputime-Expose-cputime_adjust.patch
  0002-cpuacct-Introduce-cgroup_account_cputime-_field.patch
  0003-cgroup-Implement-cgroup2-basic-CPU-usage-accounting.patch

The patchset is on top of cgroup/for-4.14 and available in the
following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-basic-acct

diffstat follows.  Thanks.

 Documentation/cgroup-v2.txt     |    9 +
 include/linux/cgroup-defs.h     |   47 +++++
 include/linux/cgroup.h          |   60 +++++++
 include/linux/sched/cputime.h   |    3 
 kernel/cgroup/Makefile          |    2 
 kernel/cgroup/cgroup-internal.h |    8 
 kernel/cgroup/cgroup.c          |   24 ++
 kernel/cgroup/stat.c            |  333 ++++++++++++++++++++++++++++++++++++++++
 kernel/sched/cpuacct.h          |   17 --
 kernel/sched/cputime.c          |    7 
 kernel/sched/deadline.c         |    2 
 kernel/sched/fair.c             |    2 
 kernel/sched/rt.c               |    2 
 kernel/sched/sched.h            |    1 
 kernel/sched/stop_task.c        |    2 
 15 files changed, 489 insertions(+), 30 deletions(-)

--
tejun
