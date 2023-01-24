From: Alistair Popple <apopple@nvidia.com>
Subject: [RFC PATCH 01/19] mm: Introduce vm_account
Date: Tue, 24 Jan 2023 16:42:30 +1100
Message-ID: <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MtXqt5AI6xt4ICbluiJvN2UYWO1rvf+ghlewsHqu9o=;
 b=bQbX4+VEqdrv0T+n3h6V6HKNVTnrJLoLgKshMGWPDjRq+Be3ItoR2iOEfJU8l91nO1ej+Qx7LNgn6gES/pIh9BOzUDP6NL0vmAHEyYxWI9g6rU+TN3EXswdvJL+ZIGEElHreUTXi4GDqPmJXkp/rNTr051kR+aUGHxWFhc1uIw3Oqc81W7WWfX30n5aTOYTvtM2Biu2z7mj1uEVUIn4TnlUlldMEU2ywLWoUl2asaa0LzZg4b2zfIbStdb35n4e9D/vlclBBG8r9NfLa5kYRgze837+mJQO3/Qptnk6Yt8oBp6DBreUwxtxoJS4KcAXc26StmTMiZT3dBMoU8H+/2A==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, Alistair Popple <apopple@nvidia.com>, linuxppc-dev@lists.ozlabs.org, linux-fpga@vger.kernel.org, linux-rdma@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, netdev@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org, rds-devel@oss.oracle.com, linux-kselftest@vger.kernel.org

Kernel drivers that pin pages should account these pages against
either user->locked_vm or mm->pinned_vm and fail the pinning if
RLIMIT_MEMLOCK is exceeded and CAP_IPC_LOCK isn't held.

Currently drivers open-code this accounting and use various methods to
update the atomic variables and check against the limits leading to
various bugs and inconsistencies. To fix this introduce a standard
interface for charging pinned and locked memory. As this involves
taking references on kernel objects such as mm_struct or user_struct
we introduce a new vm_account struct to hold these references. Several
helper functions are then introduced to grab references and check
limits.

As the way these limits are charged and enforced is visible to
userspace we need to be careful not to break existing applications by
charging to different counters. As a result the vm_account functions
support accounting to different counters as required.

A future change will extend this to also account against a cgroup for
pinned pages.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-fpga@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: io-uring@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: bpf@vger.kernel.org
Cc: rds-devel@oss.oracle.com
Cc: linux-kselftest@vger.kernel.org
---
 include/linux/mm_types.h | 87 ++++++++++++++++++++++++++++++++++++++++-
 mm/util.c                | 89 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 176 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 9757067..7de2168 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1085,4 +1085,91 @@ enum fault_flag {
 
 typedef unsigned int __bitwise zap_flags_t;
 
+/**
+ * enum vm_account_flags - Determine how pinned/locked memory is accounted.
+ * @VM_ACCOUNT_TASK: Account pinned memory to mm->pinned_vm.
+ * @VM_ACCOUNT_BYPASS: Don't enforce rlimit on any charges.
+ * @VM_ACCOUNT_USER: Accounnt locked memory to user->locked_vm.
+ *
+ * Determines which statistic pinned/locked memory is accounted
+ * against. All limits will be enforced against RLIMIT_MEMLOCK and the
+ * pins cgroup if CONFIG_CGROUP_PINS is enabled.
+ *
+ * New drivers should use VM_ACCOUNT_TASK. VM_ACCOUNT_USER is used by
+ * pre-existing drivers to maintain existing accounting against
+ * user->locked_mm rather than mm->pinned_mm.
+ *
+ * VM_ACCOUNT_BYPASS may also be specified to bypass rlimit
+ * checks. Typically this is used to cache CAP_IPC_LOCK from when a
+ * driver is first initialised. Note that this does not bypass cgroup
+ * limit checks.
+ */
+enum vm_account_flags {
+	VM_ACCOUNT_TASK = 0,
+	VM_ACCOUNT_BYPASS = 1,
+	VM_ACCOUNT_USER = 2,
+};
+
+struct vm_account {
+	struct task_struct *task;
+	union {
+		struct mm_struct *mm;
+		struct user_struct *user;
+	} a;
+	enum vm_account_flags flags;
+};
+
+/**
+ * vm_account_init - Initialise a new struct vm_account.
+ * @vm_account: pointer to uninitialised vm_account.
+ * @task: task to charge against.
+ * @user: user to charge against. Must be non-NULL for VM_ACCOUNT_USER.
+ * @flags: flags to use when charging to vm_account.
+ *
+ * Initialise a new uninitialiused struct vm_account. Takes references
+ * on the task/mm/user/cgroup as required although callers must ensure
+ * any references passed in remain valid for the duration of this
+ * call.
+ */
+void vm_account_init(struct vm_account *vm_account, struct task_struct *task,
+		struct user_struct *user, enum vm_account_flags flags);
+/**
+ * vm_account_init_current - Initialise a new struct vm_account.
+ * @vm_account: pointer to uninitialised vm_account.
+ *
+ * Helper to initialise a vm_account for the common case of charging
+ * with VM_ACCOUNT_TASK against current.
+ */
+void vm_account_init_current(struct vm_account *vm_account);
+
+/**
+ * vm_account_release - Initialise a new struct vm_account.
+ * @vm_account: pointer to initialised vm_account.
+ *
+ * Drop any object references obtained by vm_account_init(). The
+ * vm_account must not be used after calling this unless reinitialised
+ * with vm_account_init().
+ */
+void vm_account_release(struct vm_account *vm_account);
+
+/**
+ * vm_account_pinned - Charge pinned or locked memory to the vm_account.
+ * @vm_account: pointer to an initialised vm_account.
+ * @npages: number of pages to charge.
+ *
+ * Return: 0 on success, -ENOMEM if a limit would be exceeded.
+ *
+ * Note: All pages must be explicitly uncharged with
+ * vm_unaccount_pinned() prior to releasing the vm_account with
+ * vm_account_release().
+ */
+int vm_account_pinned(struct vm_account *vm_account, unsigned long npages);
+
+/**
+ * vm_unaccount_pinned - Uncharge pinned or locked memory to the vm_account.
+ * @vm_account: pointer to an initialised vm_account.
+ * @npages: number of pages to uncharge.
+ */
+void vm_unaccount_pinned(struct vm_account *vm_account, unsigned long npages);
+
 #endif /* _LINUX_MM_TYPES_H */
diff --git a/mm/util.c b/mm/util.c
index b56c92f..af40b1e 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -430,6 +430,95 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 }
 #endif
 
+void vm_account_init(struct vm_account *vm_account, struct task_struct *task,
+		struct user_struct *user, enum vm_account_flags flags)
+{
+	vm_account->task = get_task_struct(task);
+
+	if (flags & VM_ACCOUNT_USER) {
+		vm_account->a.user = get_uid(user);
+	} else {
+		mmgrab(task->mm);
+		vm_account->a.mm = task->mm;
+	}
+
+	vm_account->flags = flags;
+}
+EXPORT_SYMBOL_GPL(vm_account_init);
+
+void vm_account_init_current(struct vm_account *vm_account)
+{
+	vm_account_init(vm_account, current, NULL, VM_ACCOUNT_TASK);
+}
+EXPORT_SYMBOL_GPL(vm_account_init_current);
+
+void vm_account_release(struct vm_account *vm_account)
+{
+	put_task_struct(vm_account->task);
+	if (vm_account->flags & VM_ACCOUNT_USER)
+		free_uid(vm_account->a.user);
+	else
+		mmdrop(vm_account->a.mm);
+}
+EXPORT_SYMBOL_GPL(vm_account_release);
+
+/*
+ * Charge pages with an atomic compare and swap. Returns -ENOMEM on
+ * failure, 1 on success and 0 for retry.
+ */
+static int vm_account_cmpxchg(struct vm_account *vm_account,
+				unsigned long npages, unsigned long lock_limit)
+{
+	u64 cur_pages, new_pages;
+
+	if (vm_account->flags & VM_ACCOUNT_USER)
+		cur_pages = atomic_long_read(&vm_account->a.user->locked_vm);
+	else
+		cur_pages = atomic64_read(&vm_account->a.mm->pinned_vm);
+
+	new_pages = cur_pages + npages;
+	if (lock_limit != RLIM_INFINITY && new_pages > lock_limit)
+		return -ENOMEM;
+
+	if (vm_account->flags & VM_ACCOUNT_USER) {
+		return atomic_long_cmpxchg(&vm_account->a.user->locked_vm,
+					   cur_pages, new_pages) == cur_pages;
+	} else {
+		return atomic64_cmpxchg(&vm_account->a.mm->pinned_vm,
+					   cur_pages, new_pages) == cur_pages;
+	}
+}
+
+int vm_account_pinned(struct vm_account *vm_account, unsigned long npages)
+{
+	unsigned long lock_limit = RLIM_INFINITY;
+	int ret;
+
+	if (!(vm_account->flags & VM_ACCOUNT_BYPASS) && !capable(CAP_IPC_LOCK))
+		lock_limit = task_rlimit(vm_account->task,
+					RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+
+	while (true) {
+		ret = vm_account_cmpxchg(vm_account, npages, lock_limit);
+		if (ret > 0)
+			break;
+		else if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vm_account_pinned);
+
+void vm_unaccount_pinned(struct vm_account *vm_account, unsigned long npages)
+{
+	if (vm_account->flags & VM_ACCOUNT_USER)
+		atomic_long_sub(npages, &vm_account->a.user->locked_vm);
+	else
+		atomic64_sub(npages, &vm_account->a.mm->pinned_vm);
+}
+EXPORT_SYMBOL_GPL(vm_unaccount_pinned);
+
 /**
  * __account_locked_vm - account locked pages to an mm's locked_vm
  * @mm:          mm to account against
-- 
git-series 0.9.1
