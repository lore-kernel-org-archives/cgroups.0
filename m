From: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 0/6] cpuset: Allow to modify isolcpus through cpuset
Date: Wed, 14 Jul 2021 15:54:14 +0200
Message-ID: <20210714135420.69624-1-frederic@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626270868;
        bh=qo7KUgteHWgNW47PtvyntjuZc5d4R6Q5Gt3N6bWyOgg=;
        h=From:To:Cc:Subject:Date:From;
        b=mgmLYjetbD+nFD278pzf58PemKwKBbEln0f5LV64/cJhVlvRpwshWdfc3rZcShJMi
         AJW8XozOc6wG7qUL3ZNiH0wexMsBmIGNdPHPG1iUGwlGvfgZU8D3xurTy+7eIL9X7B
         Ur5dETD9ECBThjXubHgzRC/2OjZFSQeK8jiRufcJt5ZcYF0HDVu7w3CHDAlr7y5V5G
         pjcUia56+zfR28SarXGXbqU7RvoeYJDX5q7DuefA6WF4B/db+TxLE553nC4DmPy2f0
         JMvJNT+qoxHZqwxeQUvPEspKvPVQ5BueQxr0xyB1ItaLThRgmzHeYMRRBnxHIYZIRE
         Jwhq8fisPorXA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Belits <abelits-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>, Nitesh Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Nicolas Saenz <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The fact that "isolcpus=" behaviour can't be modified at runtime is an
eternal source of discussion and debate opposing a useful feature against
a terrible interface.

I've long since tried to figure out a proper way to control this at
runtime using cpusets, which isn't easy as a boot time single cpumask
is difficult to map to a hierarchy of cpusets that can even overlap.

The idea here is to map the boot-set isolation behaviour to any cpuset
directory whose cpumask is a subset of "isolcpus=". I let you browse
for details on the last patch.

Note this is still WIP and half-baked, but I figured it's important to
validate the interface early.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	cpuset/isolation

HEAD: 6d3dba1115b7ea464febf3763244c783e87c7baf

Thanks,
	Frederic
---

Frederic Weisbecker (6):
      pci: Decouple HK_FLAG_WQ and HK_FLAG_DOMAIN cpumask fetch
      workqueue: Decouple HK_FLAG_WQ and HK_FLAG_DOMAIN cpumask fetch
      net: Decouple HK_FLAG_WQ and HK_FLAG_DOMAIN cpumask fetch
      sched/isolation: Split domain housekeeping mask from the rest
      sched/isolation: Make HK_FLAG_DOMAIN mutable
      cpuset: Add cpuset.isolation_mask file


 drivers/pci/pci-driver.c        |  21 ++++++--
 include/linux/sched/isolation.h |   4 ++
 kernel/cgroup/cpuset.c          | 111 ++++++++++++++++++++++++++++++++++++++--
 kernel/sched/isolation.c        |  73 ++++++++++++++++++++++----
 kernel/workqueue.c              |   4 +-
 net/core/net-sysfs.c            |   6 +--
 6 files changed, 196 insertions(+), 23 deletions(-)
