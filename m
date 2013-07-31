From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/8] memcg, cgroup: kill css_id
Date: Wed, 31 Jul 2013 09:50:33 +0800
Message-ID: <51F86D69.2030907@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

This patchset converts memcg to use cgroup->id, and then we can remove
cgroup css_id.

As we've removed memcg's own refcnt, converting memcg to use cgroup->id
is very straight-forward.

The patchset is based on Tejun's cgroup tree.

v4:
- make cgroup_from_id() inline and check if cgroup_mutex is held.
- add a comment for idr_remove() in cgroup_offline)fn().

v2->v3:
- some minor cleanups suggested by Michal.
- fixed the call to idr_alloc() in cgroup_init() in the first patch.

Li Zefan (8):
      cgroup: convert cgroup_ida to cgroup_idr
      cgroup: document how cgroup IDs are assigned
      cgroup: implement cgroup_from_id()
      memcg: convert to use cgroup_is_descendant()
      memcg: convert to use cgroup id
      memcg: fail to create cgroup if the cgroup id is too big
      memcg: stop using css id
      cgroup: kill css_id
--
 include/linux/cgroup.h |  65 ++++++--------
 kernel/cgroup.c        | 285 ++++++-----------------------------------------------------
 mm/memcontrol.c        |  68 ++++++++------
 3 files changed, 96 insertions(+), 322 deletions(-)
