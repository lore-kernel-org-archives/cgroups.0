From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v3.19-rc1
Date: Wed, 10 Dec 2014 12:08:27 -0500
Message-ID: <20141210170827.GE6294@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=+Hm82IUQEfgrHiEdU+LUXgu7QoregmToFDkkaZQsMlc=;
        b=Aiix0sUtBOwZbF/A69uo1lHv+7HPxDuDT7knKwi/VEZctnaFSnaLwUI2lBUFac6Cg8
         lmlAe4lZqW+c5ZVIo9ZW+mQoLxeZa9SG10GpY4to4LKc8tX1nqy/fvhpelOpGAtnwJhu
         cN+ebN11fRzP3DfK8Bbq6ceovKvSkjomyQVfdKbZT87myQ5fjDew/XPsIOb3MijWhkqH
         eluyjIcQLVUldrj5sU3TDKvVNFlefbvAQBrP+BSmBY+FObaMOGSxo17/RKfUGO4WHzz3
         G/yuG/ZABNAE95s6NBCOpU7iwSkP2yGecUlWZtkjt9pVrwiZtSnuDtfM5r8rsUrMe65P
         BLHw==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, again.

cpuset got simplified a bit.  cgroup core got a fix on unified
hierarchy and grew some effective css related interfaces which will be
used for blkio support for writeback IO traffic which is currently
being worked on.

Thanks.

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.19

for you to fetch changes up to eeecbd1971517103e06f11750dd1a9a1dc37e4e6:

  cgroup: implement cgroup_get_e_css() (2014-11-18 02:49:52 -0500)

----------------------------------------------------------------
Dan Carpenter (1):
      cpuset: lock vs unlock typo

Tejun Heo (6):
      cgroup: separate out cgroup_calc_child_subsys_mask() from cgroup_refresh_child_subsys_mask()
      cgroup: restructure child_subsys_mask handling in cgroup_subtree_control_write()
      cgroup: fix the async css offline wait logic in cgroup_subtree_control_write()
      cgroup: add cgroup_subsys->css_released()
      cgroup: add cgroup_subsys->css_e_css_changed()
      cgroup: implement cgroup_get_e_css()

Vladimir Davydov (2):
      cpuset: convert callback_mutex to a spinlock
      cpuset: simplify cpuset_node_allowed API

 include/linux/cgroup.h |   4 ++
 include/linux/cpuset.h |  37 ++---------
 kernel/cgroup.c        | 175 ++++++++++++++++++++++++++++++++++---------------
 kernel/cpuset.c        | 162 ++++++++++++++++-----------------------------
 mm/hugetlb.c           |   2 +-
 mm/oom_kill.c          |   2 +-
 mm/page_alloc.c        |   6 +-
 mm/slab.c              |   2 +-
 mm/slub.c              |   3 +-
 mm/vmscan.c            |   5 +-
 10 files changed, 200 insertions(+), 198 deletions(-)

-- 
tejun
