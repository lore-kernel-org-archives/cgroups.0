From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v5.16-rc1
Date: Tue, 2 Nov 2021 06:48:09 -1000
Message-ID: <YYFryTJQxFok0jo/@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Xhz9r7JZBOQDI5whNrjmgfij89zWmhOWkSDOjjnmQtU=;
        b=LFq5SycnhAKDHq9ZyasKQkc8+vi8lqOCAUuILQ33aZtyJ1e00W9RjrwYzW3sja+mYk
         5+lmaHTcJcMOCerhu4EIwjborGskve15iWDXO0KicLqjRXgrPY6cEH91q64qZMgZGFxy
         83NRV1K6dz659Bzf43hOPPJvGnT3bMb44CiIyxCj0nVp00kXn7e4dV0Uy0d86tWWL7Uc
         wD2AcpQMHRVzaeXEF7oCop5ZzXcbeAphTjQTb44rp0ixPRsWW4S9QobJPWfq3Q3SNO+m
         XOiWQgWJ77XtntkkURIlAkL6y9Li3Yj953/27IS4g8QKBHMaW5fU2BqHXeeXL9ryyFV2
         aEqg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

* The misc controller now reports allocation rejections through misc.events
  instead of printking.

* cgroup_mutex usage is reduced to improve scalability of some operations.

* vhost helper threads are now assigned to the right cgroup on cgroup2.

* Bug fixes.

Thanks.

The following changes since commit c0002d11d79900f8aa5c8375336434940d6afedf:

  cgroupv2, docs: fix misinformation in "device controller" section (2021-09-13 08:08:46 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.16

for you to fetch changes up to 588e5d8766486e52ee332a4bb097b016a355b465:

  cgroup: bpf: Move wrapper for __cgroup_bpf_*() to kernel/bpf/cgroup.c (2021-11-01 06:49:00 -1000)

----------------------------------------------------------------
Chunguang Xu (3):
      misc_cgroup: introduce misc.events to count failures
      misc_cgroup: remove error log to avoid log flood
      docs/cgroup: add entry for misc.events

Dan Schatzberg (1):
      cgroup: Fix rootcg cpu.stat guest double counting

He Fengqing (1):
      cgroup: bpf: Move wrapper for __cgroup_bpf_*() to kernel/bpf/cgroup.c

Shakeel Butt (3):
      cgroup: reduce dependency on cgroup_mutex
      cgroup: remove cgroup_mutex from cgroupstats_build
      cgroup: no need for cgroup_mutex for /proc/cgroups

Vishal Verma (1):
      cgroup: cgroup-v1: do not exclude cgrp_dfl_root

Waiman Long (1):
      cgroup: Make rebind_subsystems() disable v2 controllers all at once

 Documentation/admin-guide/cgroup-v2.rst |  10 +++
 include/linux/bpf-cgroup.h              |  20 ------
 include/linux/misc_cgroup.h             |   6 +-
 kernel/bpf/cgroup.c                     |  54 +++++++++++---
 kernel/cgroup/cgroup-v1.c               |  17 ++---
 kernel/cgroup/cgroup.c                  | 120 +++++++++++++++-----------------
 kernel/cgroup/misc.c                    |  31 +++++++--
 kernel/cgroup/rstat.c                   |   2 -
 8 files changed, 144 insertions(+), 116 deletions(-)

-- 
tejun
