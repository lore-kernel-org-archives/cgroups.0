From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 06/28] x86/sgx: store unreclaimable EPC pages in sgx_epc_lru_lists
Date: Wed, 12 Jul 2023 16:01:40 -0700
Message-ID: <20230712230202.47929-7-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202930; x=1720738930;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LP9W4hlkm5ekzqLCSSJ7Z7Ak8eW+S808RjkB/UQVNtg=;
  b=hLJvN1em6sEGSJtNcSpguutP/9RqhfcVp+SrgSJn83s5If6i3PnIHcjt
   NJ47J4gaLLmTvbYh+NwiV4beYftSCfQdGgi36HgfVxT3sBmywqFKmDcQt
   CHr9OAPfNkRukIh3mx/oh/Cr7smbP/GKN/J32AR5aV54aJpYcCimgfANs
   QRMSn20KBPVRlGVYx4Isf7MtHPjL1Vxulq20kvDR64Tqibj9dgnDkWORj
   K44uyAmkHXs+WWmJ93WojLjm3bK/kzSY5ijm2DUpiYmqtg+WD6RBj4iJi
   AFtQocVfsLTcUarBaQFfkrLjbRN8v6YW90y9S1uGZmoTV+KD7rOJOM3R3
   w==;
In-Reply-To: <20230712230202.47929-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

When an OOM event occurs, all pages associated with an enclave will
need to be freed, including pages that are not currently tracked by
the reclaimer.

A previous patch converted the SGX code to use a pair of generic
"sgx_record/drop_epc_pages()" for storing the EPC pages that are
tracked by the reclaimer. This patch utilizes those functions to
store the remaining untracked pages to a new "unreclaimable" list
stored with the struct sgx_epc_lru_lists struct.

Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

V3:
- Removed tracking virtual EPC pages in unreclaimable list as host
kernel does not reclaim them. The EPC cgroups implemented later only
blocks allocating for a guest if the limit is reached by returning
-ENOMEM from sgx_alloc_epc_page() called by virt_epc, and does nothing
else. Therefore, no need to track those in LRU lists.
---
 arch/x86/kernel/cpu/sgx/encl.c  | 8 ++++++--
 arch/x86/kernel/cpu/sgx/ioctl.c | 4 +++-
 arch/x86/kernel/cpu/sgx/main.c  | 3 +++
 arch/x86/kernel/cpu/sgx/sgx.h   | 5 +++++
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index f68af9e37daa..edb8d8c1c229 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -252,7 +252,8 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 		epc_page = sgx_encl_eldu(&encl->secs, NULL);
 		if (IS_ERR(epc_page))
 			return ERR_CAST(epc_page);
-		epc_page->flags |= SGX_EPC_OWNER_ENCL_PAGE;
+		sgx_record_epc_page(epc_page, SGX_EPC_OWNER_ENCL_PAGE |
+				    SGX_EPC_PAGE_RECLAIMER_UNTRACKED);
 	}
 
 	epc_page = sgx_encl_eldu(entry, encl->secs.epc_page);
@@ -724,6 +725,7 @@ void sgx_encl_release(struct kref *ref)
 	xa_destroy(&encl->page_array);
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
+		sgx_drop_epc_page(encl->secs.epc_page);
 		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 	}
@@ -732,6 +734,7 @@ void sgx_encl_release(struct kref *ref)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
+		sgx_drop_epc_page(va_page->epc_page);
 		sgx_encl_free_epc_page(va_page->epc_page);
 		kfree(va_page);
 	}
@@ -1238,7 +1241,8 @@ struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim)
 		sgx_encl_free_epc_page(epc_page);
 		return ERR_PTR(-EFAULT);
 	}
-	epc_page->flags |= SGX_EPC_OWNER_ENCL;
+	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_ENCL |
+			    SGX_EPC_PAGE_RECLAIMER_UNTRACKED);
 
 	return epc_page;
 }
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index dd7ab1c80db6..4e6d0c9d043a 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -48,6 +48,7 @@ void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
 	encl->page_cnt--;
 
 	if (va_page) {
+		sgx_drop_epc_page(va_page->epc_page);
 		sgx_encl_free_epc_page(va_page->epc_page);
 		list_del(&va_page->list);
 		kfree(va_page);
@@ -113,7 +114,8 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->attributes = secs->attributes;
 	encl->attributes_mask = SGX_ATTR_UNPRIV_MASK;
 
-	encl->secs.epc_page->flags |= SGX_EPC_OWNER_ENCL_PAGE;
+	sgx_record_epc_page(encl->secs.epc_page, SGX_EPC_OWNER_ENCL_PAGE |
+			    SGX_EPC_PAGE_RECLAIMER_UNTRACKED);
 
 	/* Set only after completion, as encl->lock has not been taken. */
 	set_bit(SGX_ENCL_CREATED, &encl->flags);
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 371135665ff7..9252728865fa 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -268,6 +268,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 			goto out;
 
 		sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
+		sgx_drop_epc_page(encl->secs.epc_page);
 		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 
@@ -511,6 +512,8 @@ void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
 	page->flags |= flags;
 	if (flags & SGX_EPC_PAGE_RECLAIMER_TRACKED)
 		list_add_tail(&page->list, &sgx_global_lru.reclaimable);
+	else
+		list_add_tail(&page->list, &sgx_global_lru.unreclaimable);
 	spin_unlock(&sgx_global_lru.lock);
 }
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index c60bbd995942..9f780b2c4cfe 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -23,6 +23,9 @@
 #define SGX_NR_LOW_PAGES		32
 #define SGX_NR_HIGH_PAGES		64
 
+/* Pages, which are not tracked by the page reclaimer. */
+#define SGX_EPC_PAGE_RECLAIMER_UNTRACKED 0
+
 /* Pages, which are being tracked by the page reclaimer. */
 #define SGX_EPC_PAGE_RECLAIMER_TRACKED	BIT(0)
 
@@ -101,12 +104,14 @@ struct sgx_epc_lru_lists {
 	/* Must acquire this lock to access */
 	spinlock_t lock;
 	struct list_head reclaimable;
+	struct list_head unreclaimable;
 };
 
 static inline void sgx_lru_init(struct sgx_epc_lru_lists *lrus)
 {
 	spin_lock_init(&lrus->lock);
 	INIT_LIST_HEAD(&lrus->reclaimable);
+	INIT_LIST_HEAD(&lrus->unreclaimable);
 }
 
 struct sgx_epc_page *__sgx_alloc_epc_page(void);
-- 
2.25.1

