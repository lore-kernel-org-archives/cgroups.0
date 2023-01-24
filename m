From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 16/19] mm/util: Refactor account_locked_vm
Date: Tue, 24 Jan 2023 16:42:45 +1100
Message-ID: <e72f46bd6be4f3e3c85ba6a560201cf23bdb39a9.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKauSACOmjp+bD2erTq7Z7sPoUZPfQj7diDqarD8XaI=;
 b=rrFIO2dS0S07TXuOCHnBa/xKtMzAh0p9Y/97yh58OAMl8kppEmSbpi+ehr6vt68Cru4vpnrl9UDqpLT/l/B7n/cMWZoLiEQlINqKV1v36BmetIPoK1TMi2aixQAKBeZlfAHbluielXfN/1hAIMbs9dcV7ME7Ixx10FKgk0x1ldVsYj18RJOtvtj+Uk1xQLUfRQawG6X0GV/+dM1FDRgG8yQoedt2IpadnqrskuIbWK0xrM//4ihzcBmrDQwCJD2BZ4cMkeDoP9VTrE+Z73WXW34ComVk+y9GcmOKp87FHhcTOGKQbl/XO+NuSqAJoiu7OVjKIsAONGbrX5BnuU7uXQ==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

account_locked_vm() takes a flag to indicate if pages are being
accounted or unaccounted for. A flag is also provided to bypass
rlimits. However unaccounting of pages always succeeds and the flag to
ignore the limits is ignored. The flags make calling code harder to
understand so refactor the accounting and unaccounting paths into
separate functions.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 include/linux/mm.h |  5 +--
 mm/util.c          | 73 +++++++++++++++++++++++++++++++++--------------
 2 files changed, 55 insertions(+), 23 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8f85716..126b756 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2090,9 +2090,10 @@ int get_user_pages_fast(unsigned long start, int nr_pages,
 int pin_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages);
 
-int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
-int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
+int account_locked_vm(struct mm_struct *mm, unsigned long pages);
+int __account_locked_vm(struct mm_struct *mm, unsigned long pages,
 			struct task_struct *task, bool bypass_rlim);
+void __unaccount_locked_vm(struct mm_struct *mm, unsigned long pages);
 
 struct kvec;
 int get_kernel_pages(const struct kvec *iov, int nr_pages, int write,
diff --git a/mm/util.c b/mm/util.c
index e5fb01a..78b060d 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -537,7 +537,6 @@ EXPORT_SYMBOL_GPL(vm_unaccount_pinned);
  * __account_locked_vm - account locked pages to an mm's locked_vm
  * @mm:          mm to account against
  * @pages:       number of pages to account
- * @inc:         %true if @pages should be considered positive, %false if not
  * @task:        task used to check RLIMIT_MEMLOCK
  * @bypass_rlim: %true if checking RLIMIT_MEMLOCK should be skipped
  *
@@ -548,7 +547,7 @@ EXPORT_SYMBOL_GPL(vm_unaccount_pinned);
  * * 0       on success
  * * -ENOMEM if RLIMIT_MEMLOCK would be exceeded.
  */
-int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
+int __account_locked_vm(struct mm_struct *mm, unsigned long pages,
 			struct task_struct *task, bool bypass_rlim)
 {
 	unsigned long locked_vm, limit;
@@ -557,33 +556,44 @@ int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
 	mmap_assert_write_locked(mm);
 
 	locked_vm = mm->locked_vm;
-	if (inc) {
-		if (!bypass_rlim) {
-			limit = task_rlimit(task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-			if (locked_vm + pages > limit)
-				ret = -ENOMEM;
-		}
-		if (!ret)
-			mm->locked_vm = locked_vm + pages;
-	} else {
-		WARN_ON_ONCE(pages > locked_vm);
-		mm->locked_vm = locked_vm - pages;
+	if (!bypass_rlim) {
+		limit = task_rlimit(task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+		if (locked_vm + pages > limit)
+			ret = -ENOMEM;
 	}
 
-	pr_debug("%s: [%d] caller %ps %c%lu %lu/%lu%s\n", __func__, task->pid,
-		 (void *)_RET_IP_, (inc) ? '+' : '-', pages << PAGE_SHIFT,
-		 locked_vm << PAGE_SHIFT, task_rlimit(task, RLIMIT_MEMLOCK),
-		 ret ? " - exceeded" : "");
+	if (!ret)
+		mm->locked_vm = locked_vm + pages;
+
+	pr_debug("%s: [%d] caller %ps %lu %lu/%lu%s\n", __func__, task->pid,
+		 (void *)_RET_IP_, pages << PAGE_SHIFT, locked_vm << PAGE_SHIFT,
+		task_rlimit(task, RLIMIT_MEMLOCK), ret ? " - exceeded" : "");
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__account_locked_vm);
 
 /**
+ * __unaccount_locked_vm - unaccount locked pages to an mm's locked_vm
+ * @mm:          mm to account against
+ * @pages:       number of pages to account
+ *
+ * Assumes @mm are valid and that mmap_lock is held as writer.
+ */
+void __unaccount_locked_vm(struct mm_struct *mm, unsigned long pages)
+{
+	unsigned long locked_vm = mm->locked_vm;
+
+	mmap_assert_write_locked(mm);
+	WARN_ON_ONCE(pages > locked_vm);
+	mm->locked_vm = locked_vm - pages;
+}
+EXPORT_SYMBOL_GPL(__unaccount_locked_vm);
+
+/**
  * account_locked_vm - account locked pages to an mm's locked_vm
  * @mm:          mm to account against, may be NULL
  * @pages:       number of pages to account
- * @inc:         %true if @pages should be considered positive, %false if not
  *
  * Assumes a non-NULL @mm is valid (i.e. at least one reference on it).
  *
@@ -591,7 +601,7 @@ EXPORT_SYMBOL_GPL(__account_locked_vm);
  * * 0       on success, or if mm is NULL
  * * -ENOMEM if RLIMIT_MEMLOCK would be exceeded.
  */
-int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc)
+int account_locked_vm(struct mm_struct *mm, unsigned long pages)
 {
 	int ret;
 
@@ -599,14 +609,35 @@ int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc)
 		return 0;
 
 	mmap_write_lock(mm);
-	ret = __account_locked_vm(mm, pages, inc, current,
-				  capable(CAP_IPC_LOCK));
+	ret = __account_locked_vm(mm, pages, current, capable(CAP_IPC_LOCK));
 	mmap_write_unlock(mm);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(account_locked_vm);
 
+/**
+ * unaccount_locked_vm - account locked pages to an mm's locked_vm
+ * @mm:          mm to account against, may be NULL
+ * @pages:       number of pages to account
+ *
+ * Assumes a non-NULL @mm is valid (i.e. at least one reference on it).
+ *
+ * Return:
+ * * 0       on success, or if mm is NULL
+ * * -ENOMEM if RLIMIT_MEMLOCK would be exceeded.
+ */
+void unaccount_locked_vm(struct mm_struct *mm, unsigned long pages)
+{
+	if (pages == 0 || !mm)
+		return;
+
+	mmap_write_lock(mm);
+	__unaccount_locked_vm(mm, pages);
+	mmap_write_unlock(mm);
+}
+EXPORT_SYMBOL_GPL(unaccount_locked_vm);
+
 unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
 	unsigned long flag, unsigned long pgoff)
-- 
git-series 0.9.1
