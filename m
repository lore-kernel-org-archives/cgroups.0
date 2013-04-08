From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/8] memcg, cgroup: kill css_id
Date: Mon, 8 Apr 2013 16:19:53 +0800
Message-ID: <51627DA9.7020507@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

(This patchset depends on "memcg: make memcg's life cycle the same as cgroup")

This patchset converts memcg to always use cgroup->id, and then kills
css_id.

As we've removed memcg's own refcnt, converting memcg to use cgroup->id
is very straight-forward.

Li Zefan (8):
      cgroup: implement cgroup_is_ancestor()
      cgroup: implement cgroup_from_id()
      memcg: convert to use cgroup_is_ancestor()
      memcg: convert to use cgroup_from_id()
      memcg: convert to use cgroup->id
      memcg: fail to create cgroup if the cgroup id is too big
      memcg: don't use css_id any more
      cgroup: kill css_id

--
 include/linux/cgroup.h |  44 ++-------
 kernel/cgroup.c        | 302 +++++++++-----------------------------------------------------
 mm/memcontrol.c        |  53 ++++++-----
 3 files changed, 77 insertions(+), 322 deletions(-)
