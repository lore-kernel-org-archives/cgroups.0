From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 15/19] mm/util: Extend vm_account to charge pages against the pin cgroup
Date: Mon,  6 Feb 2023 18:47:52 +1100
Message-ID: <dea526f077ece04e3ff60249bc0d7d9c0cf5e5f7.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/U8SJoSKDmLPXz4EfnAjwHkQK/6X73YSJ1HtmZ4UlyY=;
 b=dAAIMDW5Q0uOtcJk21Jl8UlVFM2xF6/6jf8SZTj7poyAZJEhAz+4IK3Gnjh8Kj7m5zHwcQdem7WNx94PYk768sb4b4ryluMsF9kSJBa1QHx+T99XapGI6gXMN69mZ9UomyDR8tA4WQ3g0l5YnammbpVFW0GI1ZDr3XV2Uo3QniO5T369TPCuPTi/lz+2EN0q9QOwLMvlxb9Wdy6yauSHCDpHAnqtzzT5mU3f7/JeuDXLFZgdyhevQ1y7OMHumnUNyzOF1xM/lj7cbestDuosqy7s4w+emoriYKZFsRnd00XTdrTsAVGkIjpw+w67IgyNslCJM4ohhfqvpJauUvxZ2Q==
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

The vm_account_pinned() functions currently only account pages against
pinned_vm/locked_vm and enforce limits against RLIMIT_MEMLOCK. Extend
these to account pages and enforce limits using the pin count cgroup.

Accounting of pages will fail if either RLIMIT_MEMLOCK or the cgroup
limit is exceeded. Unlike rlimit enforcement which can be bypassed if
the user has CAP_IPC_LOCK cgroup limits can not be bypassed.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
---
 include/linux/vm_account.h |  1 +
 mm/util.c                  | 26 ++++++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/include/linux/vm_account.h b/include/linux/vm_account.h
index b4b2e90..4fd5d3a 100644
--- a/include/linux/vm_account.h
+++ b/include/linux/vm_account.h
@@ -31,6 +31,7 @@ struct vm_account {
 	struct task_struct *task;
 	struct mm_struct *mm;
 	struct user_struct *user;
+	struct pins_cgroup *pins_cg;
 	enum vm_account_flags flags;
 };
 
diff --git a/mm/util.c b/mm/util.c
index d8c19f8..0e93625 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -453,6 +453,7 @@ void vm_account_init(struct vm_account *vm_account, struct task_struct *task,
 
 	mmgrab(task->mm);
 	vm_account->mm = task->mm;
+	vm_account->pins_cg = get_pins_cg(task);
 	vm_account->flags = flags;
 }
 EXPORT_SYMBOL_GPL(vm_account_init);
@@ -472,6 +473,7 @@ void vm_account_release(struct vm_account *vm_account)
 		free_uid(vm_account->user);
 
 	mmdrop(vm_account->mm);
+	put_pins_cg(vm_account->pins_cg);
 }
 EXPORT_SYMBOL_GPL(vm_account_release);
 
@@ -502,6 +504,17 @@ static int vm_account_cmpxchg(struct vm_account *vm_account,
 	}
 }
 
+static void vm_unaccount_legacy(struct vm_account *vm_account,
+				unsigned long npages)
+{
+	if (vm_account->flags & VM_ACCOUNT_USER) {
+		atomic_long_sub(npages, &vm_account->user->locked_vm);
+		atomic64_sub(npages, &vm_account->mm->pinned_vm);
+	} else {
+		atomic64_sub(npages, &vm_account->mm->pinned_vm);
+	}
+}
+
 /**
  * vm_account_pinned - Charge pinned or locked memory to the vm_account.
  * @vm_account: pointer to an initialised vm_account.
@@ -537,6 +550,11 @@ int vm_account_pinned(struct vm_account *vm_account, unsigned long npages)
 	if (vm_account->flags & VM_ACCOUNT_USER)
 		atomic64_add(npages, &vm_account->mm->pinned_vm);
 
+	if (!pins_try_charge(vm_account->pins_cg, npages)) {
+		vm_unaccount_legacy(vm_account, npages);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vm_account_pinned);
@@ -548,12 +566,8 @@ EXPORT_SYMBOL_GPL(vm_account_pinned);
  */
 void vm_unaccount_pinned(struct vm_account *vm_account, unsigned long npages)
 {
-	if (vm_account->flags & VM_ACCOUNT_USER) {
-		atomic_long_sub(npages, &vm_account->user->locked_vm);
-		atomic64_sub(npages, &vm_account->mm->pinned_vm);
-	} else {
-		atomic64_sub(npages, &vm_account->mm->pinned_vm);
-	}
+	vm_unaccount_legacy(vm_account, npages);
+	pins_uncharge(vm_account->pins_cg, npages);
 }
 EXPORT_SYMBOL_GPL(vm_unaccount_pinned);
 
-- 
git-series 0.9.1
