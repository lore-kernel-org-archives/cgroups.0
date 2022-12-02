From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 03/18] x86/sgx: Add 'struct sgx_epc_lru_lists' to encapsulate lru list(s)
Date: Fri,  2 Dec 2022 10:36:39 -0800
Message-ID: <20221202183655.3767674-4-kristen@linux.intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670006231; x=1701542231;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r+7CHYhh5wuKLW8x7IX2pGjuO6Ml3uaP1xZZqkdxdwU=;
  b=i2/LeCXIwJoB1Fl4myXlwolIrjDhHegFAxrqOKZeo+3wrDT0lHRGAW7w
   vjBwUwFIoMnArnKD3mgNwS6jE1R+RV3AhlkT6SYS87KM+HtoMP9e27mxY
   V2TTduKeXgdhkTIQzsweBed/hc9Wt7fWIn12rFX4KZtTEzqhCS+KkdIjf
   12xbC8khSNC6V3RY64tZy6CZgTRkvDe1uXQi3L28g9xaRSULB2ivVjVK/
   icZgyRlph1c0Waiz4yuRgaIHymvxupyGvqT7vdXLttWZhBoF7p1/I0Mqd
   bKj4UL9VENCmPI/5JZXRojAbnph5YQL2zbimwoErVdU0ELNTHI8D8VgQK
   A==;
In-Reply-To: <20221202183655.3767674-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Introduce a data structure to wrap the existing reclaimable list
and its spinlock in a struct to minimize the code changes needed
to handle multiple LRUs as well as reclaimable and non-reclaimable
lists, both of which will be introduced and used by SGX EPC cgroups.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/sgx.h | 65 +++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 39cb15a8abcb..5e6d88438fae 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -90,6 +90,71 @@ static inline void *sgx_get_epc_virt_addr(struct sgx_epc_page *page)
 	return section->virt_addr + index * PAGE_SIZE;
 }
 
+/*
+ * This data structure wraps a list of reclaimable EPC pages, and a list of
+ * non-reclaimable EPC pages and is used to implement a LRU policy during
+ * reclamation.
+ */
+struct sgx_epc_lru_lists {
+	spinlock_t lock;
+	struct list_head reclaimable;
+	struct list_head unreclaimable;
+};
+
+static inline void sgx_lru_init(struct sgx_epc_lru_lists *lrus)
+{
+	spin_lock_init(&lrus->lock);
+	INIT_LIST_HEAD(&lrus->reclaimable);
+	INIT_LIST_HEAD(&lrus->unreclaimable);
+}
+
+/*
+ * Must be called with queue lock acquired
+ */
+static inline void __sgx_epc_page_list_push(struct list_head *list, struct sgx_epc_page *page)
+{
+	list_add_tail(&page->list, list);
+}
+
+/*
+ * Must be called with queue lock acquired
+ */
+static inline struct sgx_epc_page * __sgx_epc_page_list_pop(struct list_head *list)
+{
+	struct sgx_epc_page *epc_page;
+
+	if (list_empty(list))
+		return NULL;
+
+	epc_page = list_first_entry(list, struct sgx_epc_page, list);
+	list_del_init(&epc_page->list);
+	return epc_page;
+}
+
+static inline struct sgx_epc_page *
+sgx_epc_pop_reclaimable(struct sgx_epc_lru_lists *lrus)
+{
+	return __sgx_epc_page_list_pop(&(lrus)->reclaimable);
+}
+
+static inline void sgx_epc_push_reclaimable(struct sgx_epc_lru_lists *lrus,
+					    struct sgx_epc_page *page)
+{
+	__sgx_epc_page_list_push(&(lrus)->reclaimable, page);
+}
+
+static inline struct sgx_epc_page *
+sgx_epc_pop_unreclaimable(struct sgx_epc_lru_lists *lrus)
+{
+	return __sgx_epc_page_list_pop(&(lrus)->unreclaimable);
+}
+
+static inline void sgx_epc_push_unreclaimable(struct sgx_epc_lru_lists *lrus,
+					      struct sgx_epc_page *page)
+{
+	__sgx_epc_page_list_push(&(lrus)->unreclaimable, page);
+}
+
 struct sgx_epc_page *__sgx_alloc_epc_page(void);
 void sgx_free_epc_page(struct sgx_epc_page *page);
 
-- 
2.38.1

