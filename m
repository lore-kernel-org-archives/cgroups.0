From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 15/19] mm/util: Extend vm_account to charge pages against the pin cgroup
Date: Tue, 24 Jan 2023 16:42:44 +1100
Message-ID: <76d61af0219560c03910a189f1ffa340d108858e.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/5i1Fiv3xI56uStZR+8ynxVAuNk9x18QJkcNkaDcTA=;
 b=noUdmKq7L7A1uoz1VAMekURGEuYiqz9E77tY/yHmYnMRvS6Zsgb+95kGUfa2NxDQNSLoF2NVF/64Df7Bjh4nTyZ9z70M5iKT9BHL0XywyGYEFmjorE5/B1FXeNYe5ARSelzarS6TeMbMKc2OuA45pIaVgiXWlOEKMeMA2+bFChR7MswdHhORfFQg6s22j/0h749Ev2Wct+25OoiQwpVu4tE1TYQxwbtsmTa5a4NHKaXBTBd77UgZ8/29HEJqw141QmiAdHyU5pflfRqHELOyBfrrSQ08q/DU3jHed2kS20B3KvZwif0/yOntBrzupPIbRoM5l9oP6Kn8khp7wlkavA==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

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
 include/linux/mm_types.h |  1 +
 mm/util.c                | 22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 7de2168..4adf8dc 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1116,6 +1116,7 @@ struct vm_account {
 		struct mm_struct *mm;
 		struct user_struct *user;
 	} a;
+	struct pins_cgroup *pins_cg;
 	enum vm_account_flags flags;
 };
 
diff --git a/mm/util.c b/mm/util.c
index af40b1e..e5fb01a 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -442,6 +442,7 @@ void vm_account_init(struct vm_account *vm_account, struct task_struct *task,
 		vm_account->a.mm = task->mm;
 	}
 
+	vm_account->pins_cg = get_pins_cg(task);
 	vm_account->flags = flags;
 }
 EXPORT_SYMBOL_GPL(vm_account_init);
@@ -459,6 +460,7 @@ void vm_account_release(struct vm_account *vm_account)
 		free_uid(vm_account->a.user);
 	else
 		mmdrop(vm_account->a.mm);
+	put_pins_cg(vm_account->pins_cg);
 }
 EXPORT_SYMBOL_GPL(vm_account_release);
 
@@ -489,6 +491,15 @@ static int vm_account_cmpxchg(struct vm_account *vm_account,
 	}
 }
 
+static void vm_unaccount_legacy(struct vm_account *vm_account,
+				unsigned long npages)
+{
+	if (vm_account->flags & VM_ACCOUNT_USER)
+		atomic_long_sub(npages, &vm_account->a.user->locked_vm);
+	else
+		atomic64_sub(npages, &vm_account->a.mm->pinned_vm);
+}
+
 int vm_account_pinned(struct vm_account *vm_account, unsigned long npages)
 {
 	unsigned long lock_limit = RLIM_INFINITY;
@@ -506,16 +517,19 @@ int vm_account_pinned(struct vm_account *vm_account, unsigned long npages)
 			return ret;
 	}
 
+	if (pins_try_charge(vm_account->pins_cg, npages)) {
+		vm_unaccount_legacy(vm_account, npages);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vm_account_pinned);
 
 void vm_unaccount_pinned(struct vm_account *vm_account, unsigned long npages)
 {
-	if (vm_account->flags & VM_ACCOUNT_USER)
-		atomic_long_sub(npages, &vm_account->a.user->locked_vm);
-	else
-		atomic64_sub(npages, &vm_account->a.mm->pinned_vm);
+	vm_unaccount_legacy(vm_account, npages);
+	pins_uncharge(vm_account->pins_cg, npages);
 }
 EXPORT_SYMBOL_GPL(vm_unaccount_pinned);
 
-- 
git-series 0.9.1
