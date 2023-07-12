From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 01/28] x86/sgx: Store struct sgx_encl when allocating new VA pages
Date: Wed, 12 Jul 2023 16:01:35 -0700
Message-ID: <20230712230202.47929-2-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202925; x=1720738925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UBFxVX9XZ+KYUAX4AWaBycO09tYP5L5/OF+5KXvou4U=;
  b=l0jD8nJ+nYIqUvWdHpx+hJwBYezU5MGnvahQtuAuQVdfy+GpJiahmlzO
   VcoRh7+excSNtJdlJoltn62B541aTbx0Ri/Pw9BZRceYaMoSaeXS57mBM
   kAUgU8qxLa1Fbxm1iSWw33KiKXJlZ/ksPVLjMShp40hbjXyKLa5rPRhDx
   Ztv/HrpFqbPzn9NMXENilxD2rdrh4mT0cvTNi8cLUHN7RbxTX3sVb1jVv
   1sNLsk4M28YmdwKKs3pCL7H8q6a/hqmRCMffVZeI254vHWhIX+qo9wJrE
   EioMkLcQ4a7R/KH35TdzHS1jm1063Xl7Od0ryyE4y/ah8YumcZqowBNUY
   Q==;
In-Reply-To: <20230712230202.47929-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

In a later patch, when a cgroup has exceeded the max capacity for EPC pages
and there are no more Enclave EPC pages associated with the cgroup that can
be reclaimed, the only pages still associated with an enclave will be the
unreclaimable Version Array (VA) pages or SECS pages, and the entire
enclave will need to be killed to free up those pages.

Currently, given an enclave pointer it is easy to find the associated VA
pages and free them, however, OOM killing an enclave based on cgroup limits
will require examining a cgroup's unreclaimable page list, and finding an
enclave given a SECS page or a VA page. This will require a backpointer
from a page to an enclave, including for VA pages.

When allocating new Version Array (VA) pages, pass the struct sgx_encl of
the enclave that is allocating the page. sgx_alloc_epc_page() will store
this value in the owner field of the struct sgx_epc_page.  In a later
patch, VA pages will be placed in an unreclaimable queue, and then when the
cgroup max limit is reached and there are no more reclaimable pages and the
enclave must be OOM killed, all the VA pages associated with that enclave
can be uncharged and freed.

To avoid casting needed to access the two types of owners: sgx_encl for VA
pages, sgx_encl_page for other pages, replace 'owner' field in sgx_epc_page
with a union of the two types.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

V3:
- rename encl_owner to encl_page.
- revise commit messages
---
 arch/x86/kernel/cpu/sgx/encl.c  |  5 +++--
 arch/x86/kernel/cpu/sgx/encl.h  |  2 +-
 arch/x86/kernel/cpu/sgx/ioctl.c |  2 +-
 arch/x86/kernel/cpu/sgx/main.c  | 20 ++++++++++----------
 arch/x86/kernel/cpu/sgx/sgx.h   |  5 ++++-
 5 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 2a0e90fe2abc..98e1086eab07 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -1210,6 +1210,7 @@ void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr)
 
 /**
  * sgx_alloc_va_page() - Allocate a Version Array (VA) page
+ * @encl:    The enclave that this page is allocated to.
  * @reclaim: Reclaim EPC pages directly if none available. Enclave
  *           mutex should not be held if this is set.
  *
@@ -1219,12 +1220,12 @@ void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr)
  *   a VA page,
  *   -errno otherwise
  */
-struct sgx_epc_page *sgx_alloc_va_page(bool reclaim)
+struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim)
 {
 	struct sgx_epc_page *epc_page;
 	int ret;
 
-	epc_page = sgx_alloc_epc_page(NULL, reclaim);
+	epc_page = sgx_alloc_epc_page(encl, reclaim);
 	if (IS_ERR(epc_page))
 		return ERR_CAST(epc_page);
 
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index f94ff14c9486..831d63f80f5a 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -116,7 +116,7 @@ struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 					  unsigned long offset,
 					  u64 secinfo_flags);
 void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr);
-struct sgx_epc_page *sgx_alloc_va_page(bool reclaim);
+struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim);
 unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
 void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
 bool sgx_va_page_full(struct sgx_va_page *va_page);
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 21ca0a831b70..fa8c3f32ccf6 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -30,7 +30,7 @@ struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim)
 		if (!va_page)
 			return ERR_PTR(-ENOMEM);
 
-		va_page->epc_page = sgx_alloc_va_page(reclaim);
+		va_page->epc_page = sgx_alloc_va_page(encl, reclaim);
 		if (IS_ERR(va_page->epc_page)) {
 			err = ERR_CAST(va_page->epc_page);
 			kfree(va_page);
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 166692f2d501..39939b7496b0 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -108,7 +108,7 @@ static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
 
 static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
 {
-	struct sgx_encl_page *page = epc_page->owner;
+	struct sgx_encl_page *page = epc_page->encl_page;
 	struct sgx_encl *encl = page->encl;
 	struct sgx_encl_mm *encl_mm;
 	bool ret = true;
@@ -140,7 +140,7 @@ static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
 
 static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
 {
-	struct sgx_encl_page *page = epc_page->owner;
+	struct sgx_encl_page *page = epc_page->encl_page;
 	unsigned long addr = page->desc & PAGE_MASK;
 	struct sgx_encl *encl = page->encl;
 	int ret;
@@ -197,7 +197,7 @@ void sgx_ipi_cb(void *info)
 static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 			 struct sgx_backing *backing)
 {
-	struct sgx_encl_page *encl_page = epc_page->owner;
+	struct sgx_encl_page *encl_page = epc_page->encl_page;
 	struct sgx_encl *encl = encl_page->encl;
 	struct sgx_va_page *va_page;
 	unsigned int va_offset;
@@ -250,7 +250,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 				struct sgx_backing *backing)
 {
-	struct sgx_encl_page *encl_page = epc_page->owner;
+	struct sgx_encl_page *encl_page = epc_page->encl_page;
 	struct sgx_encl *encl = encl_page->encl;
 	struct sgx_backing secs_backing;
 	int ret;
@@ -312,7 +312,7 @@ static void sgx_reclaim_pages(void)
 		epc_page = list_first_entry(&sgx_active_page_list,
 					    struct sgx_epc_page, list);
 		list_del_init(&epc_page->list);
-		encl_page = epc_page->owner;
+		encl_page = epc_page->encl_page;
 
 		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0)
 			chunk[cnt++] = epc_page;
@@ -326,7 +326,7 @@ static void sgx_reclaim_pages(void)
 
 	for (i = 0; i < cnt; i++) {
 		epc_page = chunk[i];
-		encl_page = epc_page->owner;
+		encl_page = epc_page->encl_page;
 
 		if (!sgx_reclaimer_age(epc_page))
 			goto skip;
@@ -365,7 +365,7 @@ static void sgx_reclaim_pages(void)
 		if (!epc_page)
 			continue;
 
-		encl_page = epc_page->owner;
+		encl_page = epc_page->encl_page;
 		sgx_reclaimer_write(epc_page, &backing[i]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
@@ -563,7 +563,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 	for ( ; ; ) {
 		page = __sgx_alloc_epc_page();
 		if (!IS_ERR(page)) {
-			page->owner = owner;
+			page->encl_page = owner;
 			break;
 		}
 
@@ -606,7 +606,7 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 
 	spin_lock(&node->lock);
 
-	page->owner = NULL;
+	page->encl_page = NULL;
 	if (page->poison)
 		list_add(&page->list, &node->sgx_poison_page_list);
 	else
@@ -641,7 +641,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	for (i = 0; i < nr_pages; i++) {
 		section->pages[i].section = index;
 		section->pages[i].flags = 0;
-		section->pages[i].owner = NULL;
+		section->pages[i].encl_page = NULL;
 		section->pages[i].poison = 0;
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index d2dad21259a8..dc1cbcfcf2d4 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -33,7 +33,10 @@ struct sgx_epc_page {
 	unsigned int section;
 	u16 flags;
 	u16 poison;
-	struct sgx_encl_page *owner;
+	union {
+		struct sgx_encl_page *encl_page;
+		struct sgx_encl *encl;
+	};
 	struct list_head list;
 };
 
-- 
2.25.1

