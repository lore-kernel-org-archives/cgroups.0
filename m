From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH 08/20] x86/sgx: Add EPC page flags to identify type of page
Date: Thu, 22 Sep 2022 10:10:45 -0700
Message-ID: <20220922171057.1236139-9-kristen@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663866937; x=1695402937;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RZlp1H2OsjXwhzzSjzzWVpctKJLOlloT8euGikMJFHM=;
  b=biIPUgJxGAHggXeEp2S8kM0xOA79muhQaNsIWCY3OzDbNQry/R3WdXjj
   VfMK7Lii6ZapTJxHPQ20pTR0CYy8nRd35uNpfEQ5plNmHRqWTJtYG4iEy
   JoTsDm8huwN1poAO1MLnQZekK74DA2vYV+LMdx6RxnWJ+5tYtWHiAFGz9
   B+S6mqUVU+GCQPA12bJaSdQS9V6i+UqJHX4wzsIvjXKFhE7fZLnD8kckV
   VUaRXOQLgrxcOPoR8f1ENUHkHiPgMJJtXQcxwCcu0cHkC7wWxNsneGuzS
   fL/XGt6IhRBWAPfVL815dtbR0SSJGAAlnuNlu/+mQFEmHKIILRPCLHdpn
   w==;
In-Reply-To: <20220922171057.1236139-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Create new flags to help identify whether a page is an enclave page
or a va page and save the page type when the page is recorded.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/encl.c  |  6 +++---
 arch/x86/kernel/cpu/sgx/ioctl.c |  4 ++--
 arch/x86/kernel/cpu/sgx/main.c  | 20 ++++++++++----------
 arch/x86/kernel/cpu/sgx/sgx.h   |  8 +++++++-
 4 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index ad611c06798f..672b302f3688 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -252,7 +252,7 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 		epc_page = sgx_encl_eldu(&encl->secs, NULL);
 		if (IS_ERR(epc_page))
 			return ERR_CAST(epc_page);
-		sgx_record_epc_page(epc_page, 0);
+		sgx_record_epc_page(epc_page, SGX_EPC_PAGE_ENCLAVE);
 	}
 
 	epc_page = sgx_encl_eldu(entry, encl->secs.epc_page);
@@ -260,7 +260,7 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 		return ERR_CAST(epc_page);
 
 	encl->secs_child_cnt++;
-	sgx_record_epc_page(entry->epc_page, SGX_EPC_PAGE_RECLAIMER_TRACKED);
+	sgx_record_epc_page(entry->epc_page, SGX_EPC_PAGE_ENCLAVE_RECLAIMABLE);
 
 	return entry;
 }
@@ -1221,7 +1221,7 @@ struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim)
 		sgx_encl_free_epc_page(epc_page);
 		return ERR_PTR(-EFAULT);
 	}
-	sgx_record_epc_page(epc_page, 0);
+	sgx_record_epc_page(epc_page, SGX_EPC_PAGE_VERSION_ARRAY);
 
 	epc_page->owner = encl;
 
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index aca80a3f38a1..c91cc6a01232 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -114,7 +114,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->attributes = secs->attributes;
 	encl->attributes_mask = SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT | SGX_ATTR_KSS;
 
-	sgx_record_epc_page(encl->secs.epc_page, 0);
+	sgx_record_epc_page(encl->secs.epc_page, SGX_EPC_PAGE_ENCLAVE);
 
 	/* Set only after completion, as encl->lock has not been taken. */
 	set_bit(SGX_ENCL_CREATED, &encl->flags);
@@ -325,7 +325,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 			goto err_out;
 	}
 
-	sgx_record_epc_page(encl_page->epc_page, SGX_EPC_PAGE_RECLAIMER_TRACKED);
+	sgx_record_epc_page(encl_page->epc_page, SGX_EPC_PAGE_ENCLAVE_RECLAIMABLE);
 	mutex_unlock(&encl->lock);
 	mmap_read_unlock(current->mm);
 	return ret;
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 085c06fdc359..3c0d33b72896 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -304,6 +304,8 @@ static void sgx_reclaim_pages(void)
 		epc_page = list_first_entry(&sgx_global_lru.reclaimable,
 					    struct sgx_epc_page, list);
 		encl_page = epc_page->owner;
+		if (WARN_ON_ONCE(!(epc_page->flags & SGX_EPC_PAGE_ENCLAVE)))
+			continue;
 
 		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0) {
 			epc_page->flags |= SGX_EPC_PAGE_RECLAIM_IN_PROGRESS;
@@ -360,8 +362,7 @@ static void sgx_reclaim_pages(void)
 		sgx_reclaimer_write(epc_page, &backing[i++]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
-		epc_page->flags &= ~(SGX_EPC_PAGE_RECLAIMER_TRACKED |
-				     SGX_EPC_PAGE_RECLAIM_IN_PROGRESS);
+		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIM_FLAGS;
 
 		sgx_free_epc_page(epc_page);
 	}
@@ -496,6 +497,7 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
 /**
  * sgx_record_epc_page() - Add a page to the LRU tracking
  * @page:	EPC page
+ * @flags:	Reclaim flags for the page.
  *
  * Mark a page with the specified flags and add it to the appropriate
  * (un)reclaimable list.
@@ -525,18 +527,16 @@ void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
 int sgx_drop_epc_page(struct sgx_epc_page *page)
 {
 	spin_lock(&sgx_global_lru.lock);
-	if (page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED) {
-		/* The page is being reclaimed. */
-		if (page->flags & SGX_EPC_PAGE_RECLAIM_IN_PROGRESS) {
-			spin_unlock(&sgx_global_lru.lock);
-			return -EBUSY;
-		}
-
-		page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
+	if ((page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED) &&
+	    (page->flags & SGX_EPC_PAGE_RECLAIM_IN_PROGRESS)) {
+		spin_unlock(&sgx_global_lru.lock);
+		return -EBUSY;
 	}
 	list_del(&page->list);
 	spin_unlock(&sgx_global_lru.lock);
 
+	page->flags &= ~SGX_EPC_PAGE_RECLAIM_FLAGS;
+
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 284d0cda9e36..76eae4ecbf87 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -31,8 +31,14 @@
 
 /* page flag to indicate reclaim is in progress */
 #define SGX_EPC_PAGE_RECLAIM_IN_PROGRESS BIT(2)
+#define SGX_EPC_PAGE_ENCLAVE		BIT(3)
+#define SGX_EPC_PAGE_VERSION_ARRAY	BIT(4)
+#define SGX_EPC_PAGE_ENCLAVE_RECLAIMABLE (SGX_EPC_PAGE_ENCLAVE | \
+					  SGX_EPC_PAGE_RECLAIMER_TRACKED)
 #define SGX_EPC_PAGE_RECLAIM_FLAGS	(SGX_EPC_PAGE_RECLAIMER_TRACKED | \
-					 SGX_EPC_PAGE_RECLAIM_IN_PROGRESS)
+					 SGX_EPC_PAGE_RECLAIM_IN_PROGRESS | \
+					 SGX_EPC_PAGE_ENCLAVE | \
+					 SGX_EPC_PAGE_VERSION_ARRAY)
 
 struct sgx_epc_page {
 	unsigned int section;
-- 
2.37.3

