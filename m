From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH 03/20] x86/sgx: Track owning enclave in VA EPC pages
Date: Thu, 22 Sep 2022 10:10:40 -0700
Message-ID: <20220922171057.1236139-4-kristen@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663866674; x=1695402674;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DjiUzJ8L4GVZjCfQCnWcxNqSYGYXwpjlzhw0010ck3A=;
  b=PbjQlYpsf+qDXLzF2/dd4XfKEeoiHYi9V5msC0vyxwFEC401SsFyAAFD
   GjYkkYcqW9TOWASeSad3sMZSko8Ay71r7zPQqN+PQQUK+R+wAeiXqAxPp
   BeFTijve4laZfTdcNpYnAtP3UE+DD0nGDFDQYzpgSyzvHSPE1LGyLi0Tr
   pFKggs52Nx5KX7Av8VjP41wnhKiMYEXB1BRaCq4BMu7/IM7Ry33gWhyDV
   /F4gGGPqCHQ3Z5GAODOpwP4FRYL7ens2AgIzBrERc5252aedC/tiJFHSA
   mEsx0AFzVjELePWjtENLozal1Rtj0lBuZCIyfjBGTthMNF325f6UD1Sgv
   Q==;
In-Reply-To: <20220922171057.1236139-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In order to fully account for an enclave's EPC page usage, store
the owning enclave of a VA EPC page.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/encl.c  | 5 ++++-
 arch/x86/kernel/cpu/sgx/encl.h  | 2 +-
 arch/x86/kernel/cpu/sgx/ioctl.c | 2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index f40d64206ded..a18f1311b57d 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -1193,6 +1193,7 @@ void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr)
 
 /**
  * sgx_alloc_va_page() - Allocate a Version Array (VA) page
+ * @encl:    The enclave that this page is allocated to.
  * @reclaim: Reclaim EPC pages directly if none available. Enclave
  *           mutex should not be held if this is set.
  *
@@ -1202,7 +1203,7 @@ void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr)
  *   a VA page,
  *   -errno otherwise
  */
-struct sgx_epc_page *sgx_alloc_va_page(bool reclaim)
+struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim)
 {
 	struct sgx_epc_page *epc_page;
 	int ret;
@@ -1218,6 +1219,8 @@ struct sgx_epc_page *sgx_alloc_va_page(bool reclaim)
 		return ERR_PTR(-EFAULT);
 	}
 
+	epc_page->owner = encl;
+
 	return epc_page;
 }
 
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
index ebe79d60619f..9a1bb3c3211a 100644
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
-- 
2.37.3

