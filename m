From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v4.18-rc1
Date: Tue, 5 Jun 2018 12:21:57 -0700
Message-ID: <20180605192157.GG1351649@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=lWtMe1Ib/DMc8qjy/0pR0m4xK6nFgH/eecM42chlAjE=;
        b=ZN5cxP+L/fOFDig6D57qJqEG8PKyHUrQ4rK7BWpnZtwfYUmLf81xhGi2cYh5hXwifW
         JOeeW3xdpmTmKxXPtLNs5UU0GXFXSVHyTLJicYkQ9cPCGdClYkp2KtuLNJnjWqVmtlmD
         L419+9wNxekelwB60CBjCrEVc++36LUhxu3tWGPIDpywcrdDGFsoNoIFaUHMxnC8LGxk
         PjL++dGTGMs7EcfZaIE22Mq2drePE6R57OJmclPyV/IrmCVLKEMqQziwcjd1c8pPrTG5
         yLcYisLFazb6X7vk+Q3TxSXfJVpNUp1kOkbdaRC3NugdQkjx3OE7oHXYTl8qqpD/ZCVi
         rhug==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Hello, Linus.

cgroup changes for v4.18.

* For cpustat, cgroup has a percpu hierarchical stat mechanism which
  propagates up the hierarchy lazily.  This pull request contains
  commits to factor out and generalize the mechanism so that it can be
  used for other cgroup stats too.  The original intention was to
  update memcg stats to use it but memcg went for a different
  approach, so still the only user is cpustat.  The factoring out and
  generalization still make sense and it's likely that this can be
  used for other purposes in the future.

* cgroup uses file modified events to notify certain events.  A rate
  limiting mechanism is added.

* Other misc changes.

Thanks.

The following changes since commit fe03a7594d86e0754f05e604cd803a6a9aae3c1c:

  Merge tag 'acpi-4.17-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2018-04-26 11:06:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.18

for you to fetch changes up to d8742e22902186e30c346b1ba881cb52942ae3e4:

  cgroup: css_set_lock should nest inside tasklist_lock (2018-05-23 11:04:54 -0700)

----------------------------------------------------------------
Andy Shevchenko (1):
      rdmacg: Convert to use match_string() helper

Tejun Heo (12):
      cgroup: Explicitly remove core interface files
      cgroup: Limit event generation frequency
      cgroup: Rename kernel/cgroup/stat.c to kernel/cgroup/rstat.c
      cgroup: Rename stat to rstat
      cgroup: Distinguish base resource stat implementation from rstat
      cgroup: Reorganize kernel/cgroup/rstat.c
      cgroup: Factor out and expose cgroup_rstat_*() interface functions
      cgroup: Replace cgroup_rstat_mutex with a spinlock
      cgroup: Add cgroup_subsys->css_rstat_flush()
      cgroup: Add memory barriers to plug cgroup_rstat_updated() race window
      cgroup: Make cgroup_rstat_updated() ready for root cgroup usage
      cgroup: css_set_lock should nest inside tasklist_lock

 include/linux/cgroup-defs.h     |  52 +++--
 include/linux/cgroup.h          |  12 +-
 kernel/cgroup/Makefile          |   2 +-
 kernel/cgroup/cgroup-internal.h |  11 +-
 kernel/cgroup/cgroup.c          | 105 +++++++---
 kernel/cgroup/rdma.c            |  35 ++--
 kernel/cgroup/rstat.c           | 416 ++++++++++++++++++++++++++++++++++++++++
 kernel/cgroup/stat.c            | 338 --------------------------------
 8 files changed, 554 insertions(+), 417 deletions(-)
 create mode 100644 kernel/cgroup/rstat.c
 delete mode 100644 kernel/cgroup/stat.c

-- 
tejun
