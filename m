From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v5 12/18] x86/sgx: Add EPC OOM path to forcefully reclaim EPC
Date: Fri, 22 Sep 2023 20:06:51 -0700
Message-ID: <20230923030657.16148-13-haitao.huang@linux.intel.com>
References: <20230923030657.16148-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695438428; x=1726974428;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UA/9J/zQf4eOo4qQvjhwmYZhqKa4R4W6o4TLEyujPbk=;
  b=UJ2WzrC9LgSZ2iMJTLGaI1esoNazhmkK/wxndmfkM84dSxgD6JV3hXLE
   Mkf41/Ks7+5vKcL6+6aXDcaYWpNCvoXrtUEVxA3bni+CJKZouR15+jpJk
   FpH97v2kHMx5aIFcq0ovdAs+CNU534dSf+oA9DnkSU5nJwAzc7xXJy30i
   cZuEf6Tafp0WoNI1Kr0OFTEYFXGXTISHX70HGaN+tqnEdC/UnMEkRvbs4
   2qdSYahzC3JWwHha6Lxh9zineiGbL/q2KiXzU2DhviacDDnHibGBr2j/d
   +b6QYG/H979dNgR9XDPnKCi0u70nG0z+z6jILh7eO6ylcFwrW5mC94IwI
   w==;
In-Reply-To: <20230923030657.16148-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Introduce the OOM path for killing an enclave with a reclaimer that is no
longer able to reclaim enough EPC pages. Find a victim enclave, which
will be an enclave with only "unreclaimable" EPC pages left in the
cgroup LRU lists. Once a victim is identified, mark the enclave as OOM
and zap the enclave's entire page range, and drain all mm references in
encl->mm_list. Block allocating any EPC pages in #PF handler, or
reloading any pages in all paths, or creating any new mappings.

The OOM killing path may race with the reclaimers: in some cases, the
victim enclave is in the process of reclaiming the last EPC pages when
OOM happens, that is, all pages other than SECS and VA pages are in
RECLAIMING_IN_PROGRESS state. The reclaiming process requires access to
the enclave backing, VA pages as well as SECS. So the OOM killer does
not directly release those enclave resources, instead, it lets all
reclaiming in progress to finish, and relies (as currently done) on
kref_put on encl->refcount to trigger sgx_encl_release() to do the
final cleanup.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Co-developed-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Co-developed-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
V5:
- Rename SGX_ENCL_OOM to SGX_ENCL_NO_MEMORY

V4:
- Updates for patch reordering and typo fixes.

V3:
- Rebased to use the new VMA_ITERATOR to zap VMAs.
- Fixed the racing cases by blocking new page allocation/mapping and
reloading when enclave is marked for OOM. And do not release any enclave
resources other than draining mm_list entries, and let pages in
RECLAIMING_IN_PROGRESS to be reaped by reclaimers.
- Due to above changes, also removed the no-longer needed encl->lock in
the OOM path which was causing deadlocks reported by the lock prover.
---
 arch/x86/kernel/cpu/sgx/driver.c |  27 +-----
 arch/x86/kernel/cpu/sgx/encl.c   |  48 ++++++++++-
 arch/x86/kernel/cpu/sgx/encl.h   |   2 +
 arch/x86/kernel/cpu/sgx/ioctl.c  |   9 ++
 arch/x86/kernel/cpu/sgx/main.c   | 140 +++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h    |   1 +
 6 files changed, 200 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 262f5fb18d74..ff42d649c7b6 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -44,7 +44,6 @@ static int sgx_open(struct inode *inode, struct file *file)
 static int sgx_release(struct inode *inode, struct file *file)
 {
 	struct sgx_encl *encl = file->private_data;
-	struct sgx_encl_mm *encl_mm;
 
 	/*
 	 * Drain the remaining mm_list entries. At this point the list contains
@@ -52,31 +51,7 @@ static int sgx_release(struct inode *inode, struct file *file)
 	 * not exited yet. The processes, which have exited, are gone from the
 	 * list by sgx_mmu_notifier_release().
 	 */
-	for ( ; ; )  {
-		spin_lock(&encl->mm_lock);
-
-		if (list_empty(&encl->mm_list)) {
-			encl_mm = NULL;
-		} else {
-			encl_mm = list_first_entry(&encl->mm_list,
-						   struct sgx_encl_mm, list);
-			list_del_rcu(&encl_mm->list);
-		}
-
-		spin_unlock(&encl->mm_lock);
-
-		/* The enclave is no longer mapped by any mm. */
-		if (!encl_mm)
-			break;
-
-		synchronize_srcu(&encl->srcu);
-		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
-		kfree(encl_mm);
-
-		/* 'encl_mm' is gone, put encl_mm->encl reference: */
-		kref_put(&encl->refcount, sgx_encl_release);
-	}
-
+	sgx_encl_mm_drain(encl);
 	kref_put(&encl->refcount, sgx_encl_release);
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index a8617e6a4b4e..3c91a705e720 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -451,6 +451,9 @@ static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
 	if (unlikely(!encl))
 		return VM_FAULT_SIGBUS;
 
+	if (test_bit(SGX_ENCL_NO_MEMORY, &encl->flags))
+		return VM_FAULT_SIGBUS;
+
 	/*
 	 * The page_array keeps track of all enclave pages, whether they
 	 * are swapped out or not. If there is no entry for this page and
@@ -649,7 +652,8 @@ static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
 	if (!encl)
 		return -EFAULT;
 
-	if (!test_bit(SGX_ENCL_DEBUG, &encl->flags))
+	if (!test_bit(SGX_ENCL_DEBUG, &encl->flags) ||
+	    test_bit(SGX_ENCL_NO_MEMORY, &encl->flags))
 		return -EFAULT;
 
 	for (i = 0; i < len; i += cnt) {
@@ -774,6 +778,45 @@ void sgx_encl_release(struct kref *ref)
 	kfree(encl);
 }
 
+/**
+ * sgx_encl_mm_drain - drain all mm_list entries
+ * @encl:	address of the sgx_encl to drain
+ *
+ * Used during oom kill to empty the mm_list entries after they have been
+ * zapped. Or used by sgx_release to drain the remaining mm_list entries when
+ * the enclave fd is closing. After this call, sgx_encl_release will be called
+ * with kref_put.
+ */
+void sgx_encl_mm_drain(struct sgx_encl *encl)
+{
+	struct sgx_encl_mm *encl_mm;
+
+	for ( ; ; )  {
+		spin_lock(&encl->mm_lock);
+
+		if (list_empty(&encl->mm_list)) {
+			encl_mm = NULL;
+		} else {
+			encl_mm = list_first_entry(&encl->mm_list,
+						   struct sgx_encl_mm, list);
+			list_del_rcu(&encl_mm->list);
+		}
+
+		spin_unlock(&encl->mm_lock);
+
+		/* The enclave is no longer mapped by any mm. */
+		if (!encl_mm)
+			break;
+
+		synchronize_srcu(&encl->srcu);
+		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
+		kfree(encl_mm);
+
+		/* 'encl_mm' is gone, put encl_mm->encl reference: */
+		kref_put(&encl->refcount, sgx_encl_release);
+	}
+}
+
 /*
  * 'mm' is exiting and no longer needs mmu notifications.
  */
@@ -845,6 +888,9 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 	struct sgx_encl_mm *encl_mm;
 	int ret;
 
+	if (test_bit(SGX_ENCL_NO_MEMORY, &encl->flags))
+		return -ENOMEM;
+
 	/*
 	 * Even though a single enclave may be mapped into an mm more than once,
 	 * each 'mm' only appears once on encl->mm_list. This is guaranteed by
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 831d63f80f5a..cdb57ecb05c8 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -39,6 +39,7 @@ enum sgx_encl_flags {
 	SGX_ENCL_DEBUG		= BIT(1),
 	SGX_ENCL_CREATED	= BIT(2),
 	SGX_ENCL_INITIALIZED	= BIT(3),
+	SGX_ENCL_NO_MEMORY	= BIT(4),
 };
 
 struct sgx_encl_mm {
@@ -125,5 +126,6 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 					 unsigned long addr);
 struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim);
 void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page);
+void sgx_encl_mm_drain(struct sgx_encl *encl);
 
 #endif /* _X86_ENCL_H */
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 50ddd8988452..e1209e2cf6a3 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -420,6 +420,9 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 	    test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
 		return -EINVAL;
 
+	if (test_bit(SGX_ENCL_NO_MEMORY, &encl->flags))
+		return -ENOMEM;
+
 	if (copy_from_user(&add_arg, arg, sizeof(add_arg)))
 		return -EFAULT;
 
@@ -605,6 +608,9 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 	    test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
 		return -EINVAL;
 
+	if (test_bit(SGX_ENCL_NO_MEMORY, &encl->flags))
+		return -ENOMEM;
+
 	if (copy_from_user(&init_arg, arg, sizeof(init_arg)))
 		return -EFAULT;
 
@@ -681,6 +687,9 @@ static int sgx_ioc_sgx2_ready(struct sgx_encl *encl)
 	if (!test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
 		return -EINVAL;
 
+	if (test_bit(SGX_ENCL_NO_MEMORY, &encl->flags))
+		return -ENOMEM;
+
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index f3a3ed894616..3b875ab4dcd0 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -621,6 +621,146 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	atomic_long_inc(&sgx_nr_free_pages);
 }
 
+static bool sgx_oom_get_ref(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl *encl;
+
+	if (epc_page->flags & SGX_EPC_OWNER_PAGE)
+		encl = epc_page->encl_page->encl;
+	else if (epc_page->flags & SGX_EPC_OWNER_ENCL)
+		encl = epc_page->encl;
+	else
+		return false;
+
+	return kref_get_unless_zero(&encl->refcount);
+}
+
+static struct sgx_epc_page *sgx_oom_get_victim(struct sgx_epc_lru_lists *lru)
+{
+	struct sgx_epc_page *epc_page, *tmp;
+
+	if (list_empty(&lru->unreclaimable))
+		return NULL;
+
+	list_for_each_entry_safe(epc_page, tmp, &lru->unreclaimable, list) {
+		list_del_init(&epc_page->list);
+
+		if (sgx_oom_get_ref(epc_page))
+			return epc_page;
+	}
+	return NULL;
+}
+
+static void sgx_epc_oom_zap(void *owner, struct mm_struct *mm, unsigned long start,
+			    unsigned long end, const struct vm_operations_struct *ops)
+{
+	VMA_ITERATOR(vmi, mm, start);
+	struct vm_area_struct *vma;
+
+	/**
+	 * Use end because start can be zero and not mapped into
+	 * enclave even if encl->base = 0.
+	 */
+	for_each_vma_range(vmi, vma, end) {
+		if (vma->vm_ops == ops && vma->vm_private_data == owner &&
+		    vma->vm_start < end) {
+			zap_vma_pages(vma);
+		}
+	}
+}
+
+static bool sgx_oom_encl(struct sgx_encl *encl)
+{
+	unsigned long mm_list_version;
+	struct sgx_encl_mm *encl_mm;
+	bool ret = false;
+	int idx;
+
+	if (!test_bit(SGX_ENCL_CREATED, &encl->flags))
+		goto out_put;
+
+	/* Done OOM on this enclave previously, do not redo it.
+	 * This may happen when the SECS page is still UNRECLAIMABLE because
+	 * another page is in RECLAIM_IN_PROGRESS. Still return true so OOM
+	 * killer can wait until the reclaimer done with the hold-up page and
+	 * SECS before it move on to find another victim.
+	 */
+	if (test_bit(SGX_ENCL_NO_MEMORY, &encl->flags))
+		goto out;
+
+	set_bit(SGX_ENCL_NO_MEMORY, &encl->flags);
+
+	do {
+		mm_list_version = encl->mm_list_version;
+
+		/* Pairs with smp_rmb() in sgx_encl_mm_add(). */
+		smp_rmb();
+
+		idx = srcu_read_lock(&encl->srcu);
+
+		list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
+			if (!mmget_not_zero(encl_mm->mm))
+				continue;
+
+			mmap_read_lock(encl_mm->mm);
+
+			sgx_epc_oom_zap(encl, encl_mm->mm, encl->base,
+					encl->base + encl->size, &sgx_vm_ops);
+
+			mmap_read_unlock(encl_mm->mm);
+
+			mmput_async(encl_mm->mm);
+		}
+
+		srcu_read_unlock(&encl->srcu, idx);
+	} while (WARN_ON_ONCE(encl->mm_list_version != mm_list_version));
+
+	sgx_encl_mm_drain(encl);
+out:
+	ret = true;
+
+out_put:
+	/*
+	 * This puts the refcount we took when we identified this enclave as
+	 * an OOM victim.
+	 */
+	kref_put(&encl->refcount, sgx_encl_release);
+	return ret;
+}
+
+static inline bool sgx_oom_encl_page(struct sgx_encl_page *encl_page)
+{
+	return sgx_oom_encl(encl_page->encl);
+}
+
+/**
+ * sgx_epc_oom() - invoke EPC out-of-memory handling on target LRU
+ * @lru:	LRU that is low
+ *
+ * Return:	%true if a victim was found and kicked.
+ */
+bool sgx_epc_oom(struct sgx_epc_lru_lists *lru)
+{
+	struct sgx_epc_page *victim;
+
+	spin_lock(&lru->lock);
+	victim = sgx_oom_get_victim(lru);
+	spin_unlock(&lru->lock);
+
+	if (!victim)
+		return false;
+
+	if (victim->flags & SGX_EPC_OWNER_PAGE)
+		return sgx_oom_encl_page(victim->encl_page);
+
+	if (victim->flags & SGX_EPC_OWNER_ENCL)
+		return sgx_oom_encl(victim->encl);
+
+	/*Will never happen unless we add more owner types in future */
+	WARN_ON_ONCE(1);
+	return false;
+}
+
 static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 					 unsigned long index,
 					 struct sgx_epc_section *section)
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 337747bef7c2..6c0bfdc209c0 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -178,6 +178,7 @@ void sgx_reclaim_direct(void);
 void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags);
 int sgx_drop_epc_page(struct sgx_epc_page *page);
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
+bool sgx_epc_oom(struct sgx_epc_lru_lists *lrus);
 
 void sgx_ipi_cb(void *info);
 
-- 
2.25.1

