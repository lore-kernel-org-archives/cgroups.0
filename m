From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [patch 00/11] userspace out of memory handling
Date: Tue, 4 Mar 2014 19:58:38 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=hb1KLWmt66QYAWX2X+Bh9NykxYGloZRngR/EjNH/a4Y=;
        b=AdxgWSntyKXfS3zDXPc1JfbN9xJBkQe4LMwBRRLwVvapu18CfHXvdydPq9jQuEsIs2
         KQe1i5Zxq/Um6Cln/IY37DvWKUurn+s/+PtQUylCT8ATUyK9mjM2b7I4wh1XrejRIhZh
         Z7xj/7XR7/NueeikaBBQuhh7xl6d38BbZvI7JGKAX1fFYo4jObut5pjUd0geBzixCSMl
         pK9LcggBLSpxkMyi8NRk50wVLdFxJlaMCRaKW1ltYD00ps1SgfEGHEd6KCuhkScB0nSn
         P8+7JpSkzU9GtNlIq8Oh8rCQkJlJKqFgHuTmdlYy8u1tHqEX+1xn3OPUFe0C0ZGDN2r1
         aoIw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jianguo Wu <wujianguo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This patchset implements userspace out of memory handling.

It is based on v3.14-rc5.  Individual patches will apply cleanly or you
may pull the entire series from

	git://git.kernel.org/pub/scm/linux/kernel/git/rientjes/linux.git mm/oom

When the system or a memcg is oom, processes running on that system or
attached to that memcg cannot allocate memory.  It is impossible for a
process to reliably handle the oom condition from userspace.

First, consider only system oom conditions.  When memory is completely
depleted and nothing may be reclaimed, the kernel is forced to free some
memory; the only way it can do so is to kill a userspace process.  This
will happen instantaneously and userspace can enforce neither its own
policy nor collect information.

On system oom, there may be a hierarchy of memcgs that represent user
jobs, for example.  Each job may have a priority independent of their
current memory usage.  There is no existing kernel interface to kill the
lowest priority job; userspace can now kill the lowest priority job or
allow priorities to change based on whether the job is using more memory
than its pre-defined reservation.

Additionally, users may want to log the condition or debug applications
that are using too much memory.  They may wish to collect heap profiles
or are able to do memory freeing without killing a process by throttling
or ratelimiting.

Interactive users using X window environments may wish to have a dialogue
box appear to determine how to proceed -- it may even allow them shell
access to examine the state of the system while oom.

It's not sufficient to simply restrict all user processes to a subset of
memory and oom handling processes to the remainder via a memcg hierarchy:
kernel memory and other page allocations can easily deplete all memory
that is not charged to a user hierarchy of memory.

This patchset allows userspace to do all of these things by defining a
small memory reserve that is accessible only by processes that are
handling the notification.

Second, consider memcg oom conditions.  Processes need no special
knowledge of whether they are attached to the root memcg, where memcg
charging will always succeed, or a child memcg where charging will fail
when the limit has been reached.  This allows those processes handling
memcg oom conditions to overcharge the memcg by the amount of reserved
memory.  They need not create child memcgs with smaller limits and
attach the userspace oom handler only to the parent; such support would
not allow userspace to handle system oom conditions anyway.

This patchset introduces a standard interface through memcg that allows
both of these conditions to be handled in the same clean way: users
define memory.oom_reserve_in_bytes to define the reserve and this
amount is allowed to be overcharged to the process handling the oom
condition's memcg.  If used with the root memcg, this amount is allowed
to be allocated below the per-zone watermarks for root processes that
are handling such conditions (only root may write to
cgroup.event_control for the root memcg).
---
 Documentation/cgroups/memory.txt           |  46 ++++++++-
 Documentation/cgroups/resource_counter.txt |  12 +--
 Documentation/sysctl/vm.txt                |   5 +
 arch/m32r/mm/discontig.c                   |   1 +
 include/linux/memcontrol.h                 |  24 +++++
 include/linux/mempolicy.h                  |   3 +-
 include/linux/mmzone.h                     |   2 +
 include/linux/res_counter.h                |  16 ++--
 include/linux/sched.h                      |   2 +-
 kernel/fork.c                              |  13 +--
 kernel/res_counter.c                       |  42 ++++++---
 mm/memcontrol.c                            | 144 ++++++++++++++++++++++++++++-
 mm/mempolicy.c                             |  46 ++-------
 mm/oom_kill.c                              |   7 ++
 mm/page_alloc.c                            |  17 +++-
 mm/slab.c                                  |   8 +-
 mm/slub.c                                  |   2 +-
 17 files changed, 292 insertions(+), 98 deletions(-)
