From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroups changes for 4.1-rc1
Date: Mon, 13 Apr 2015 11:43:19 -0400
Message-ID: <20150413154319.GG2596@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=t8A3Iepo1dZGpTckOghiH+WV79bkR8MCDbnVfoIPnoo=;
        b=FpgDYhy68ChYV9dyoif5dJ4y6o4nemLI0yLFLC+N9Pkv4Td7xHaVMyEaIM7o6gGTtL
         D4PFw5YqpOIiPc5+sJuBb9Vu6vwScUoYCpw2GfI8XkXE7XNQRZnOTCnXtsw8ryg2Ad+Z
         1fiobMmJCLkEK4ReAPaJ6ARwcrTniPWZDJRwumpY6HKct8Cop+FPQ3mDN5IlVW9KOwsl
         /wkkCSqG97HODARGbHr56P/0iVu9etsHW5zzmQvf89gaKPIjewa5ivBWqUwPMMdp0NiH
         mVrSmZzK1KjPEVsdt9EaLWM3lS8cvl3j1q1gFIq3Z23RBCjJbNKL1D22mFSCHZHbpuY1
         htgg==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

Hello, Linus.

Nothing too interesting.  Rik made cpuset cooperate better with
isolcpus and there are several other cleanup patches.

Thanks.

The following changes since commit 283cb41f426b723a0255702b761b0fc5d1b53a81:

  cpuset: Fix cpuset sched_relax_domain_level (2015-03-02 11:55:04 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.1

for you to fetch changes up to 34ebe933417e16f46bc30ea77a66e7f30d0cf0f8:

  cpuset, isolcpus: document relationship between cpusets & isolcpus (2015-03-19 14:28:20 -0400)

----------------------------------------------------------------
Bandan Das (1):
      cgroup: Use kvfree in pidlist_free()

Rik van Riel (3):
      sched, isolcpu: make cpu_isolated_map visible outside scheduler
      cpusets, isolcpus: exclude isolcpus from load balancing in cpusets
      cpuset, isolcpus: document relationship between cpusets & isolcpus

Vladimir Davydov (1):
      cgroup: call cgroup_subsys->bind on cgroup subsys initialization

Zefan Li (1):
      cpuset: initialize cpuset a bit early

 Documentation/cgroups/cpusets.txt | 10 ++++++++--
 include/linux/sched.h             |  2 ++
 init/main.c                       |  2 +-
 kernel/cgroup.c                   |  8 ++++----
 kernel/cpuset.c                   | 13 +++++++++++--
 kernel/sched/core.c               |  6 +++---
 6 files changed, 29 insertions(+), 12 deletions(-)

-- 
tejun
