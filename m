From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v5 11/18] x86/sgx: store unreclaimable pages in LRU lists
Date: Fri, 22 Sep 2023 20:06:50 -0700
Message-ID: <20230923030657.16148-12-haitao.huang@linux.intel.com>
References: <20230923030657.16148-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695438427; x=1726974427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C63qJ730rbliOEJWIvRszebH9fI5wJTL885JlaOiRVw=;
  b=Dpj3LOxn5sbyqXNxDgx8ly+nkJEviBSKrGMtBUpvgyuRW1on8C9y1F6H
   BJ9Gn3ddYnvhqnOo2OcmQkAbH1AM4JMO1jR1V+xKOqfH4fUmQuXxI5IyS
   QxXNM7JHutMbfPL1r++5BR1xtCWtgjqLeRRv4RRrUdxdlnF1+GZKDfwU2
   RZ52hluiazsvjy3RmwJfoV7mkKNxs7e8LSSI+RznArLUjkmf3bn5bS6Fg
   I4aEjLL5lCgy3VaGAWF8+o4/NsJaL3FbpMHRL7yDPO2G3qEfni/QtB1Ib
   V3nmaUyX7uk+Az8O0bU9EpsZvFg/5EPLWRhpbg3a9mfjEwVM0d8K3N67n
   w==;
In-Reply-To: <20230923030657.16148-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When an OOM event occurs, all pages associated with an enclave will need
to be freed, including pages that are not currently tracked by the
cgroup LRU lists.

Add a new "unreclaimable" list to the sgx_epc_lru_lists struct and
update the "sgx_record/drop_epc_pages()" functions for adding/removing
VA and SECS pages to/from this "unreclaimable" list.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Co-developed-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Co-developed-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
V4:
- Updates for patch reordering.
- Revised commit messages.
- Revised comments for the list.

V3:
- Removed tracking virtual EPC pages in unreclaimable list as host
kernel does not reclaim them. The EPC cgroups implemented later only
blocks allocating for a guest if the limit is reached by returning
-ENOMEM from sgx_alloc_epc_page() called by virt_epc, and does nothing
else. Therefore, no need to track those in LRU lists.
---
 arch/x86/kernel/cpu/sgx/encl.c  | 2 ++
 arch/x86/kernel/cpu/sgx/ioctl.c | 1 +
 arch/x86/kernel/cpu/sgx/main.c  | 3 +++
 arch/x86/kernel/cpu/sgx/sgx.h   | 8 +++++++-
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index da1657813fce..a8617e6a4b4e 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -746,6 +746,7 @@ void sgx_encl_release(struct kref *ref)
 	xa_destroy(&encl->page_array);
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
+		sgx_drop_epc_page(encl->secs.epc_page);
 		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 	}
@@ -754,6 +755,7 @@ void sgx_encl_release(struct kref *ref)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
+		sgx_drop_epc_page(va_page->epc_page);
 		sgx_encl_free_epc_page(va_page->epc_page);
 		kfree(va_page);
 	}
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index cd338e93acc1..50ddd8988452 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -48,6 +48,7 @@ void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
 	encl->page_cnt--;
 
 	if (va_page) {
+		sgx_drop_epc_page(va_page->epc_page);
 		sgx_encl_free_epc_page(va_page->epc_page);
 		list_del(&va_page->list);
 		kfree(va_page);
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index ed813288af44..f3a3ed894616 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -268,6 +268,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 			goto out;
 
 		sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
+		sgx_drop_epc_page(encl->secs.epc_page);
 		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 
@@ -510,6 +511,8 @@ void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
 	page->flags |= flags;
 	if (sgx_epc_page_reclaimable(flags))
 		list_add_tail(&page->list, &sgx_global_lru.reclaimable);
+	else
+		list_add_tail(&page->list, &sgx_global_lru.unreclaimable);
 	spin_unlock(&sgx_global_lru.lock);
 }
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 51aba1cd1937..337747bef7c2 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -152,17 +152,23 @@ static inline void *sgx_get_epc_virt_addr(struct sgx_epc_page *page)
 }
 
 /*
- * Tracks EPC pages reclaimable by the reclaimer (ksgxd).
+ * Contains EPC pages tracked by the reclaimer (ksgxd).
  */
 struct sgx_epc_lru_lists {
 	spinlock_t lock;
 	struct list_head reclaimable;
+	/*
+	 * Tracks SECS, VA pages,etc., pages only freeable after all its
+	 * dependent reclaimables are freed.
+	 */
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

