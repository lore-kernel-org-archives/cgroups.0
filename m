From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v4.9-rc1
Date: Thu, 13 Oct 2016 22:05:09 -0400
Message-ID: <20161014020509.GM32534@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=CYgXtozaZDNo2v28j20QGgq6OOqWzn7Pw75FMDgBS6M=;
        b=sRch0rB1lNbNzHTLhB95jBXu90dZs8kTlocunuT+lTuWV/yV18U/w95laNqL/cwjLN
         cjzwAygF2cqMm2SWBKD7HHzDT+9DLCKzKmhoUSLqSqQuHiW7JWoXS2TrW2OUjYmD9dUu
         Xy/L6d8+yE6EEZ0XCFLqYv0VEm97NiG9+CNDiNplW389sAUbFGhl9kYP2jVyyPlxhmLB
         OgWP/hj0Aztd1N+bQ3apq0oo7DP1kWX18rxcLf0IkkmeSAoopjE90kzRnYpHmv4ISO2d
         uXhhdHxJYcF4xrU35sFmxfxLjQZuVWVJSZjWrF0LQit19zSF+fULC5egcWUW7Ae8ElmB
         zm4A==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

cgroup changes for v4.9-rc1.

* Tracepoints for basic cgroup management operations added.

* kernfs and cgroup path formatting functions updated to behave in the
  style of strlcpy().

* Non-critical bug fixes.

Thanks.

The following changes since commit 29b4817d4018df78086157ea3a55c1d9424a7cfc:

  Linux 4.8-rc1 (2016-08-07 18:18:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.9

for you to fetch changes up to bbb427e342495df1cda10051d0566388697499c0:

  blkcg: Unlock blkcg_pol_mutex only once when cpd == NULL (2016-09-30 10:31:20 +0200)

----------------------------------------------------------------
Bart Van Assche (1):
      blkcg: Unlock blkcg_pol_mutex only once when cpd == NULL

Tejun Heo (7):
      kernfs: add dummy implementation of kernfs_path_from_node()
      kernfs: make kernfs_path*() behave in the style of strlcpy()
      kernfs: remove kernfs_path_len()
      cgroup: make cgroup_path() and friends behave in the style of strlcpy()
      cgroup: add tracepoints for basic operations
      cpuset: fix error handling regression in proc_cpuset_show()
      cgroup: fix error handling regressions in proc_cgroup_show() and cgroup_release_agent()

 block/blk-cgroup.c            |   4 +-
 fs/kernfs/dir.c               |  84 +++++-----------------
 fs/sysfs/dir.c                |   6 +-
 include/linux/blk-cgroup.h    |  11 +--
 include/linux/cgroup.h        |   9 ++-
 include/linux/kernfs.h        |  28 +++++---
 include/trace/events/cgroup.h | 163 ++++++++++++++++++++++++++++++++++++++++++
 kernel/cgroup.c               |  75 ++++++++++++-------
 kernel/cpuset.c               |  13 ++--
 kernel/sched/debug.c          |   3 +-
 10 files changed, 266 insertions(+), 130 deletions(-)
 create mode 100644 include/trace/events/cgroup.h

-- 
tejun
