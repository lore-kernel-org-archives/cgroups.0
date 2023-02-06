From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/19] mm: Introduce vm_account
Date: Mon,  6 Feb 2023 18:47:38 +1100
Message-ID: <e80b61561f97296a6c08faeebe281cb949333d1d.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xC0ascId9hC0FQ0mqA9gGlsD4Tec21nIaiiKW1ANuos=;
 b=A+FFKqJYzlIAVESoxZN19dbMh3tOUmAXg71BZGbiuV4HgT2WwNhXvo9H+EqVd1hYY7W1iy9x2eJ4H3XwaGr2jO5d9GIETU1TZlbpbaiAHeuE5em9pnJ4MNG1/6OKDbNRjYa1RYLSWzUTRajUam0hS8av8ruJv6K2TuFY+X4QQbLJGSDzZBmJnFND8gFdvARudQbQbxKxMrYh7Rhm7JbL033fzE2OtsmZD+IYJ1sO5/fcSIk019OYzNFb21GL+KvbDlEwCq+4mkJl2w71KvdFVvoO4dgzK/vrr1yASUdmbDEzRitZTTs59gTXhfNc79Z05lPOjSUH1lVBxsi65AXCxA==
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Kernel drivers that pin pages should account these pages against
either user->locked_vm and/or mm->pinned_vm and fail the pinning if
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

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
Cc: linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 include/linux/vm_account.h |  56 +++++++++++++++++-
 mm/util.c                  | 127 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 183 insertions(+)
 create mode 100644 include/linux/vm_account.h

diff --git a/include/linux/vm_account.h b/include/linux/vm_account.h
new file mode 100644
index 0000000..b4b2e90
--- /dev/null
+++ b/include/linux/vm_account.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_VM_ACCOUNT_H
+#define _LINUX_VM_ACCOUNT_H
+
+/**
+ * enum vm_account_flags - Determine how pinned/locked memory is accounted.
+ * @VM_ACCOUNT_TASK: Account pinned memory to mm->pinned_vm.
+ * @VM_ACCOUNT_BYPASS: Don't enforce rlimit on any charges.
+ * @VM_ACCOUNT_USER: Account locked memory to user->locked_vm.
+ *
+ * Determines which statistic pinned/locked memory is accounted
+ * against. All limits will be enforced against RLIMIT_MEMLOCK and the
+ * pins cgroup if CONFIG_CGROUP_PINS is enabled.
+ *
+ * New drivers should use VM_ACCOUNT_USER. VM_ACCOUNT_TASK is used by
+ * pre-existing drivers to maintain existing accounting against
+ * mm->pinned_mm rather than user->locked_mm.
+ *
+ * VM_ACCOUNT_BYPASS may also be specified to bypass rlimit
+ * checks. Typically this is used to cache CAP_IPC_LOCK from when a
+ * driver is first initialised. Note that this does not bypass cgroup
+ * limit checks.
+ */
+enum vm_account_flags {
+	VM_ACCOUNT_USER = 0,
+	VM_ACCOUNT_BYPASS = 1,
+	VM_ACCOUNT_TASK = 1,
+};
+
+struct vm_account {
+	struct task_struct *task;
+	struct mm_struct *mm;
+	struct user_struct *user;
+	enum vm_account_flags flags;
+};
+
+void vm_account_init(struct vm_account *vm_account, struct task_struct *task,
+		struct user_struct *user, enum vm_account_flags flags);
+
+/**
+ * vm_account_init_current - Initialise a new struct vm_account.
+ * @vm_account: pointer to uninitialised vm_account.
+ *
+ * Helper to initialise a vm_account for the common case of charging
+ * with VM_ACCOUNT_TASK against current.
+ */
+static inline void vm_account_init_current(struct vm_account *vm_account)
+{
+	vm_account_init(vm_account, current, NULL, VM_ACCOUNT_TASK);
+}
+
+void vm_account_release(struct vm_account *vm_account);
+int vm_account_pinned(struct vm_account *vm_account, unsigned long npages);
+void vm_unaccount_pinned(struct vm_account *vm_account, unsigned long npages);
+
+#endif /* _LINUX_VM_ACCOUNT_H */
diff --git a/mm/util.c b/mm/util.c
index b56c92f..d8c19f8 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -23,6 +23,7 @@
 #include <linux/processor.h>
 #include <linux/sizes.h>
 #include <linux/compat.h>
+#include <linux/vm_account.h>
 
 #include <linux/uaccess.h>
 
@@ -431,6 +432,132 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 #endif
 
 /**
+ * vm_account_init - Initialise a new struct vm_account.
+ * @vm_account: pointer to uninitialised vm_account.
+ * @task: task to charge against.
+ * @user: user to charge against. Must be non-NULL for VM_ACCOUNT_USER.
+ * @flags: flags to use when charging to vm_account.
+ *
+ * Initialise a new uninitialised struct vm_account. Takes references
+ * on the task/mm/user/cgroup as required although callers must ensure
+ * any references passed in remain valid for the duration of this
+ * call.
+ */
+void vm_account_init(struct vm_account *vm_account, struct task_struct *task,
+		struct user_struct *user, enum vm_account_flags flags)
+{
+	vm_account->task = get_task_struct(task);
+
+	if (flags & VM_ACCOUNT_USER)
+		vm_account->user = get_uid(user);
+
+	mmgrab(task->mm);
+	vm_account->mm = task->mm;
+	vm_account->flags = flags;
+}
+EXPORT_SYMBOL_GPL(vm_account_init);
+
+/**
+ * vm_account_release - Initialise a new struct vm_account.
+ * @vm_account: pointer to initialised vm_account.
+ *
+ * Drop any object references obtained by vm_account_init(). The
+ * vm_account must not be used after calling this unless reinitialised
+ * with vm_account_init().
+ */
+void vm_account_release(struct vm_account *vm_account)
+{
+	put_task_struct(vm_account->task);
+	if (vm_account->flags & VM_ACCOUNT_USER)
+		free_uid(vm_account->user);
+
+	mmdrop(vm_account->mm);
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
+		cur_pages = atomic_long_read(&vm_account->user->locked_vm);
+	else
+		cur_pages = atomic64_read(&vm_account->mm->pinned_vm);
+
+	new_pages = cur_pages + npages;
+	if (lock_limit != RLIM_INFINITY && new_pages > lock_limit)
+		return -ENOMEM;
+
+	if (vm_account->flags & VM_ACCOUNT_USER) {
+		return atomic_long_cmpxchg(&vm_account->user->locked_vm,
+					   cur_pages, new_pages) == cur_pages;
+	} else {
+		return atomic64_cmpxchg(&vm_account->mm->pinned_vm,
+					   cur_pages, new_pages) == cur_pages;
+	}
+}
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
+	/*
+	 * Always add pinned pages to mm->pinned_vm even when we're
+	 * not enforcing the limit against that.
+	 */
+	if (vm_account->flags & VM_ACCOUNT_USER)
+		atomic64_add(npages, &vm_account->mm->pinned_vm);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vm_account_pinned);
+
+/**
+ * vm_unaccount_pinned - Uncharge pinned or locked memory to the vm_account.
+ * @vm_account: pointer to an initialised vm_account.
+ * @npages: number of pages to uncharge.
+ */
+void vm_unaccount_pinned(struct vm_account *vm_account, unsigned long npages)
+{
+	if (vm_account->flags & VM_ACCOUNT_USER) {
+		atomic_long_sub(npages, &vm_account->user->locked_vm);
+		atomic64_sub(npages, &vm_account->mm->pinned_vm);
+	} else {
+		atomic64_sub(npages, &vm_account->mm->pinned_vm);
+	}
+}
+EXPORT_SYMBOL_GPL(vm_unaccount_pinned);
+
+/**
  * __account_locked_vm - account locked pages to an mm's locked_vm
  * @mm:          mm to account against
  * @pages:       number of pages to account
-- 
git-series 0.9.1
