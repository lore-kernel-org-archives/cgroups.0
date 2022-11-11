From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 03/26] x86/sgx: Add 'struct sgx_epc_lru' to encapsulate lru list(s)
Date: Fri, 11 Nov 2022 10:35:08 -0800
Message-ID: <20221111183532.3676646-4-kristen@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191752; x=1699727752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dkrbuSbW29NorxoWdbkKDSqPb7WHSXOFvxv4JgA/XCU=;
  b=JCf16JLAKNkfeR0v/GvSBTQVhZkD7p/5cudaMAWBpllKpoGyZs869bfD
   5M4fudpHjaOT8aITEoo/4ebUcSbd+6XGWVJKP31Z6sc+hoEtjtsIsWgRR
   fPtoQtXliws51NZog+kSMvAzAQ3ZKtBSVb/ekd3O8FuFx2edsHaFn5NT1
   ZTvSs8gstb5NYbjTGa5uShFWmlVVTxG40cF5HX7NA04TMxEcUiS5TUreM
   o9fbVVw3PDJlAq9h0KdBBk7pkPioOW1L7jhzwJjH6Q16d3YnsdNHzGiga
   f9NBpZHpZUhN4+VIIuPBZ5g+7HITmE2Iklg0cBYbFoar94DSi/aAFtfAS
   Q==;
In-Reply-To: <20221111183532.3676646-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Introduce a data structure to wrap the existing reclaimable list
and its spinlock in a struct to minimize the code changes needed
to handle multiple LRUs as well as reclaimable and non-reclaimable
lists, both of which will be introduced and used by SGX EPC cgroups.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/sgx.h | 45 +++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index efb10eacd3aa..aac7d4feb0fa 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -91,6 +91,51 @@ static inline void *sgx_get_epc_virt_addr(struct sgx_epc_page *page)
 	return section->virt_addr + index * PAGE_SIZE;
 }
 
+struct sgx_epc_lru {
+	spinlock_t lock;
+	struct list_head reclaimable;
+	struct list_head unreclaimable;
+};
+
+static inline void sgx_lru_init(struct sgx_epc_lru *lru)
+{
+	spin_lock_init(&lru->lock);
+	INIT_LIST_HEAD(&lru->reclaimable);
+	INIT_LIST_HEAD(&lru->unreclaimable);
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
+#define sgx_epc_pop_reclaimable(lru) \
+	__sgx_epc_page_list_pop(&(lru)->reclaimable)
+#define sgx_epc_push_reclaimable(lru, page) \
+	__sgx_epc_page_list_push(&(lru)->reclaimable, page)
+#define sgx_epc_pop_unreclaimable(lru) \
+	__sgx_epc_page_list_pop(&(lru)->unreclaimable)
+#define sgx_epc_push_unreclaimable(lru, page) \
+	__sgx_epc_page_list_push(&(lru)->unreclaimable, page)
+
 struct sgx_epc_page *__sgx_alloc_epc_page(void);
 void sgx_free_epc_page(struct sgx_epc_page *page);
 
-- 
2.37.3

