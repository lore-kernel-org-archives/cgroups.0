From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] hugetlb: fix hugetlb cgroup refcounting during vma split
Date: Mon, 30 Aug 2021 14:50:15 -0700
Message-ID: <20210830215015.155224-1-mike.kravetz@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Hrex4PC1LQg4AsLp0HQLoNArCjOpXv4T0B/GwwtKFss=;
 b=lvTy0Te0FthIL+4YyXGjHWXux5r6f63kaT6ni8FoneYegU6UaiLq/zPQ1H1EZ+2GD+HC
 pIcR3XsxIMeIHMpl7/CmU0fN63UM4k2GAsTuRAMI4FCq9gYqwAVt+k0Vxd9IbLVTVc0e
 9JI205iUmce/99pi0qQpuVl/qr5JUFT7fmpntrPwSja/BAJBqLrDPlu7IVu+1nkLSZXd
 AdW6J9UbQCzBHA/mLiPCpwFCxiJvQGJzvBFx3cAXiXh3bsY1WgyxwHHz2TWkIcgA1Uq1
 Ey0ZkFuB7ud6We2xKc/MtUrjJwRZNDXMiWGVcgYSoMg/Qr7YKDzpJ6PgzQjq9yrYsFSO Jg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Hrex4PC1LQg4AsLp0HQLoNArCjOpXv4T0B/GwwtKFss=;
 b=K8AAu9k1Y20A4/aqoeOizy3MqQhMdbLcmnC9f5Ijaj8nS1lfdp+lnp0CDmvA2qYAhasj
 Zba6i8dXZ+wSbKuNN92OIhS4hKEU8X2tE5IxplZsbbVjBhCQ2bvA3zITVaCxS36Cq6ad
 WThBFVCFBa2UI9Wybist577cwTt76Qz/3SZU4Ar4qGjOJQ48W/NbIjvozS/88O3wa6hT
 irosfQd5S9pga4zed3gDaYiiFFj9gy4izmIRveMaH3sHhoNcWkURK9PBAEZMtCM6aCbO
 gniCN5HZeTOA2RWhEgWpZ4CPmOpiU4N6TZ7BWj4fl1DgLl76rk2/yb6u42YCAyIbXN/4 Ew== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hrex4PC1LQg4AsLp0HQLoNArCjOpXv4T0B/GwwtKFss=;
 b=E413ixAyLbDgi6IJveDIU+TGcBkZ+BCCSXVFfUXRcayLr4lnC3RFg9Gps+23Iio/kWTDxFossLILuu7G851HWHAHkhgIDh9tsSnN92bfardAfuyvFX2DkyOT6dc0QCrcTpYae0zopA6MfK/NRNJEoqoSPxxA6hg3aZVjNI092dw=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sandipan Das <sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Guillaume Morin <guillaume-/FyPzM6KSZdAfugRpC6u6w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Guillaume Morin reported hitting the following WARNING followed
by GPF or NULL pointer deference either in cgroups_destroy or in
the kill_css path.:

percpu ref (css_release) <= 0 (-1) after switching to atomic
WARNING: CPU: 23 PID: 130 at lib/percpu-refcount.c:196 percpu_ref_switch_to_atomic_rcu+0x127/0x130
CPU: 23 PID: 130 Comm: ksoftirqd/23 Kdump: loaded Tainted: G           O      5.10.60 #1
RIP: 0010:percpu_ref_switch_to_atomic_rcu+0x127/0x130
Call Trace:
 rcu_core+0x30f/0x530
 rcu_core_si+0xe/0x10
 __do_softirq+0x103/0x2a2
 ? sort_range+0x30/0x30
 run_ksoftirqd+0x2b/0x40
 smpboot_thread_fn+0x11a/0x170
 kthread+0x10a/0x140
 ? kthread_create_worker_on_cpu+0x70/0x70
 ret_from_fork+0x22/0x30

Upon further examination, it was discovered that the css structure
was associated with hugetlb reservations.

For private hugetlb mappings the vma points to a reserve map that
contains a pointer to the css.  At mmap time, reservations are set up
and a reference to the css is taken.  This reference is dropped in the
vma close operation; hugetlb_vm_op_close.  However, if a vma is split
no additional reference to the css is taken yet hugetlb_vm_op_close will
be called twice for the split vma resulting in an underflow.

Fix by taking another reference in hugetlb_vm_op_open.  Note that the
reference is only taken for the owner of the reserve map.  In the more
common fork case, the pointer to the reserve map is cleared for
non-owning vmas.

Fixes: e9fe92ae0cd2 ("hugetlb_cgroup: add reservation accounting for
private mappings")
Reported-by: Guillaume Morin <guillaume-/FyPzM6KSZdAfugRpC6u6w@public.gmane.org>
Suggested-by: Guillaume Morin <guillaume-/FyPzM6KSZdAfugRpC6u6w@public.gmane.org>
Signed-off-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 include/linux/hugetlb_cgroup.h | 12 ++++++++++++
 mm/hugetlb.c                   |  4 +++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index 0b8d1fdda3a1..c137396129db 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -121,6 +121,13 @@ static inline void hugetlb_cgroup_put_rsvd_cgroup(struct hugetlb_cgroup *h_cg)
 	css_put(&h_cg->css);
 }
 
+static inline void resv_map_dup_hugetlb_cgroup_uncharge_info(
+						struct resv_map *resv_map)
+{
+	if (resv_map->css)
+		css_get(resv_map->css);
+}
+
 extern int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					struct hugetlb_cgroup **ptr);
 extern int hugetlb_cgroup_charge_cgroup_rsvd(int idx, unsigned long nr_pages,
@@ -199,6 +206,11 @@ static inline void hugetlb_cgroup_put_rsvd_cgroup(struct hugetlb_cgroup *h_cg)
 {
 }
 
+static inline void resv_map_dup_hugetlb_cgroup_uncharge_info(
+						struct resv_map *resv_map)
+{
+}
+
 static inline int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					       struct hugetlb_cgroup **ptr)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8ea35ba6699f..6c583ef079e3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4033,8 +4033,10 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
 	 * after this open call completes.  It is therefore safe to take a
 	 * new reference here without additional locking.
 	 */
-	if (resv && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+	if (resv && is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
+		resv_map_dup_hugetlb_cgroup_uncharge_info(resv);
 		kref_get(&resv->refs);
+	}
 }
 
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
-- 
2.31.1

