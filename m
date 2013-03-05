From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v2 0/5] bypass root memcg charges if no memcgs are possible
Date: Tue,  5 Mar 2013 17:10:53 +0400
Message-ID: <1362489058-3455-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org

Hi,

Here is my recent changes in my patchset to bypass charges from the root cgroup
if no other memcgs are present in the system. At the time, the main complaint
came from Michal Hocko, correctly pointing out that if hierarchy == 0, we can't
bypass the root memcg forever and at some point, we need to transfer charges.
This is now done in this patch.

DISCLAIMER:

I haven't yet got access to a big box again. I am sending this with outdated
numbers in the interest of having this in the open earlier. However, the main
idea stands, and I believe the numbers are still generally valid (albeit of
course, it would be better to have them updated. Independent evaluations always
welcome)

* v2
- Fixed some LRU bugs
- Only keep bypassing if we have root-level hierarchy.

Glauber Costa (5):
  memcg: make nocpu_base available for non hotplug
  memcg: provide root figures from system totals
  memcg: make it suck faster
  memcg: do not call page_cgroup_init at system_boot
  memcg: do not walk all the way to the root for memcg

 include/linux/memcontrol.h  |  72 ++++++++++---
 include/linux/page_cgroup.h |  28 ++---
 init/main.c                 |   2 -
 mm/memcontrol.c             | 243 ++++++++++++++++++++++++++++++++++++++++----
 mm/page_cgroup.c            | 150 ++++++++++++++-------------
 5 files changed, 382 insertions(+), 113 deletions(-)

-- 
1.8.1.2
