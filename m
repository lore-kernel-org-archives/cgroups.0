From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v6.0-rc2
Date: Tue, 23 Aug 2022 13:45:24 -1000
Message-ID: <YwVmlMzNMS5ym9JI@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc;
        bh=8UO1wGihVQ8kGhkOFqHrGxvl0WX3n5u+/PNd+s9miG4=;
        b=Kf/bPhzyGLBmL3jMqyoAS1wVdm0HbkKsBxknTWHyipKk1/Nwbsnkjx331Ne0JBRB1Z
         MyFkyd7yAasunIGco2idYhnfjVqDntfJCO3BbptWb7lwr73JnW0JWysCDFTWWhyY5S8F
         i1GNQXvdL7Bnu4N2EdVgAcqIZ5dxdWjFgZjcxhjKXfNV8e8DNekkhBetd0pujeqUpQb5
         vvoILcm3q0qQ2YURqwseBEYFMEae8tjkz5lz5mBi9Y8uW40GIyXMnaUA8Wmbi8FS4lol
         +oJnVgLBWqO4vHynvSIY/0ACCmssGZHa5Z7aZ6W7b7r3n7Nus07w9e/jYvwIsxPdHCkw
         d8Iw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The following changes since commit 568035b01cfb107af8d2e4bd2fb9aea22cf5b868:

  Linux 6.0-rc1 (2022-08-14 15:50:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-6.0-rc2-fixes

for you to fetch changes up to 763f4fb76e24959c370cdaa889b2492ba6175580:

  cgroup: Fix race condition at rebind_subsystems() (2022-08-23 08:11:06 -1000)

----------------------------------------------------------------
cgroup fixes for v6.0-rc2

Contains fixes for the following issues:

* psi data structure was changed to be allocated dynamically but it wasn't
  being cleared leading to reporting garbage values and triggering spurious
  oom kills.

* A deadlock involving cpuset and cpu hotplug.

* When a controller is moved across cgroup hierarchies, css->rstat_css_node
  didn't get RCU drained properly from the previous list.

----------------------------------------------------------------
Hao Jia (3):
      sched/psi: Zero the memory of struct psi_group
      sched/psi: Remove unused parameter nbytes of psi_trigger_create()
      sched/psi: Remove redundant cgroup_psi() when !CONFIG_CGROUPS

Jing-Ting Wu (1):
      cgroup: Fix race condition at rebind_subsystems()

Tejun Heo (1):
      cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock

 include/linux/cgroup.h |  5 ----
 include/linux/psi.h    |  2 +-
 kernel/cgroup/cgroup.c | 80 +++++++++++++++++++++++++++++++++++---------------
 kernel/cgroup/cpuset.c |  3 +-
 kernel/sched/psi.c     | 10 ++-----
 5 files changed, 61 insertions(+), 39 deletions(-)
