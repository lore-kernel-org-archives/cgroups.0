From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 18/19] mm/mmap: Charge locked memory to pins cgroup
Date: Mon,  6 Feb 2023 18:47:55 +1100
Message-ID: <fa58b745a597a32b434b0d92d55cf0b97317cfec.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJx4d6L32xsb7lM+TLJ9IAT+Zep1O/ydPt8JKIy3HJs=;
 b=ZtlV3xqkVCdEoJMfxTySEMtXYlBcu3RxzlI8GNdhznj8a3/UJ6829hjPsh6TZDRu2tpHt00m6JeVT9mO19xTSFl14OLTKMl2qMVxWKCQ08L7ww//5xTfGaLbzbp2s/s+uLONIvlAYGNugDKhqxzwxxpHpX1Q05Ec8ZZUZEusqbBXkWlLLK1Eb7YUEv1W9yawV01c44sPu3WlKPNxoO1W2hfj+pC9GmCitT/gDCXV23DrMjJW056Q12HoqU6w/6LxfLme95bxIla/oE9b5Tf8DZO97bHQwNjl3phF0Ws5x7pCH4BQc+7zmpLqeADSEpnxfCVrYTxZfdoWv2as/21C2A==
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

account_locked_vm() is used to account memory to mm->locked_vm. This
adds accounting to the pins cgorup as it behaves similarly and should
be accounted against the same global limit if set.

This means memory must now be unaccounted for correctly, as the cgroup
typically outlives both the mm and the task. It is assumed that
callers of account_locked_vm() only do accounting against the current
task. Callers that need to do accounting against remote tasks should
use account_pinned_vm() and associated struct vm_account to hold
references to the cgroup.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/util.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/mm/util.c b/mm/util.c
index 1ca0dfe..755bada 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -589,15 +589,21 @@ int __account_locked_vm(struct mm_struct *mm, unsigned long pages,
 			struct task_struct *task, bool bypass_rlim)
 {
 	unsigned long locked_vm, limit;
+	struct pins_cgroup *pins_cg = get_pins_cg(task);
 	int ret = 0;
 
 	mmap_assert_write_locked(mm);
 
+	if (pins_cg && !pins_try_charge(pins_cg, pages))
+		return -ENOMEM;
+
 	locked_vm = mm->locked_vm;
 	if (!bypass_rlim) {
 		limit = task_rlimit(task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-		if (locked_vm + pages > limit)
+		if (locked_vm + pages > limit) {
+			pins_uncharge(pins_cg, pages);
 			ret = -ENOMEM;
+		}
 	}
 
 	if (!ret)
@@ -607,6 +613,12 @@ int __account_locked_vm(struct mm_struct *mm, unsigned long pages,
 		 (void *)_RET_IP_, pages << PAGE_SHIFT, locked_vm << PAGE_SHIFT,
 		task_rlimit(task, RLIMIT_MEMLOCK), ret ? " - exceeded" : "");
 
+	pr_debug("%s: [%d] caller %ps %lu %lu/%lu%s\n", __func__, task->pid,
+		 (void *)_RET_IP_, pages << PAGE_SHIFT, locked_vm << PAGE_SHIFT,
+		task_rlimit(task, RLIMIT_MEMLOCK), ret ? " - exceeded" : "");
+
+	if (pins_cg)
+		put_pins_cg(pins_cg);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__account_locked_vm);
@@ -622,8 +634,18 @@ void __unaccount_locked_vm(struct mm_struct *mm, unsigned long pages)
 {
 	unsigned long locked_vm = mm->locked_vm;
 
+	/*
+	 * TODO: Convert book3s vio to use pinned vm to ensure
+	 * unaccounting happens to the correct cgroup.
+	 */
+	struct pins_cgroup *pins_cg = get_pins_cg(current);
+
 	mmap_assert_write_locked(mm);
 	WARN_ON_ONCE(pages > locked_vm);
+	if (pins_cg) {
+		pins_uncharge(pins_cg, pages);
+		put_pins_cg(pins_cg);
+	}
 	mm->locked_vm = locked_vm - pages;
 }
 EXPORT_SYMBOL_GPL(__unaccount_locked_vm);
-- 
git-series 0.9.1
