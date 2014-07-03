From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH RFC 5/5] vm_cgroup: do not charge tasks in root cgroup
Date: Thu, 3 Jul 2014 16:48:21 +0400
Message-ID: <e97d260eecc1a5f01a900996ae12cc265b6023c7.1404383187.git.vdavydov@parallels.com>
References: <cover.1404383187.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1404383187.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

For the root cgroup (the whole system), we already have overcommit
accounting and control, so we can skip charging tasks in the root cgroup
to avoid overhead.

Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 mm/vm_cgroup.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/vm_cgroup.c b/mm/vm_cgroup.c
index 6642f934540a..c871fecaab4c 100644
--- a/mm/vm_cgroup.c
+++ b/mm/vm_cgroup.c
@@ -1,6 +1,7 @@
 #include <linux/cgroup.h>
 #include <linux/res_counter.h>
 #include <linux/mm.h>
+#include <linux/mman.h>
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
 #include <linux/shmem_fs.h>
@@ -65,6 +66,9 @@ static int vm_cgroup_do_charge(struct vm_cgroup *vmcg,
 	unsigned long val = nr_pages << PAGE_SHIFT;
 	struct res_counter *fail_res;
 
+	if (vm_cgroup_is_root(vmcg))
+		return 0;
+
 	return res_counter_charge(&vmcg->res, val, &fail_res);
 }
 
@@ -73,6 +77,9 @@ static void vm_cgroup_do_uncharge(struct vm_cgroup *vmcg,
 {
 	unsigned long val = nr_pages << PAGE_SHIFT;
 
+	if (vm_cgroup_is_root(vmcg))
+		return;
+
 	res_counter_uncharge(&vmcg->res, val);
 }
 
@@ -159,6 +166,9 @@ static u64 vm_cgroup_read_u64(struct cgroup_subsys_state *css,
 	struct vm_cgroup *vmcg = vm_cgroup_from_css(css);
 	int memb = cft->private;
 
+	if (vm_cgroup_is_root(vmcg))
+		return vm_memory_committed() << PAGE_SHIFT;
+
 	return res_counter_read_u64(&vmcg->res, memb);
 }
 
-- 
1.7.10.4
