From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 18/19] mm/mmap: Charge locked memory to pins cgroup
Date: Tue, 24 Jan 2023 16:42:47 +1100
Message-ID: <3883f8fefba4fa039c8bb5ea1882aaf4585dbc07.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cwo0tfKFqlSjGojYIjz88S7pf4ONV6bklIA6oByAF4=;
 b=WoL9BiR2yLNy912yNr/5ywnnEnSpU2Z8QQ09z74/o96XY8GFpmvaleX/P6bu79Lz7wVe/onJp9mjlz/S51BLQhrttZ1wSTdMoUU6m6H8QsDbEEmCNKbbCdLoi6a6LGNgOX66QCRaZhXBDHv5oVPZZy2sp1b29um1b2kLvETMNLiYZf8GxEi8kfMFsbJCa4d18m0NTrEije59aOH3TSLCQtL1RnrOFau0EYJ2QlqS8gxnCLmlW0Mwlm1v9Zupyi1+0lmNi/4Q/eBjWZs3hhuBZfG5caU6vYTDTIS4e8pAY3yn3k3U6ij+9hT7K3ggAp2Pnr5L33ahHmBgdA2sFQqmVQ==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

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
index 78b060d..d6159e3 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -551,15 +551,21 @@ int __account_locked_vm(struct mm_struct *mm, unsigned long pages,
 			struct task_struct *task, bool bypass_rlim)
 {
 	unsigned long locked_vm, limit;
+	struct pins_cgroup *pins_cg = get_pins_cg(task);
 	int ret = 0;
 
 	mmap_assert_write_locked(mm);
 
+	if (pins_cg && pins_try_charge(pins_cg, pages))
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
@@ -569,6 +575,12 @@ int __account_locked_vm(struct mm_struct *mm, unsigned long pages,
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
@@ -584,8 +596,18 @@ void __unaccount_locked_vm(struct mm_struct *mm, unsigned long pages)
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
