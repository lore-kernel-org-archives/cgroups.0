From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v5 10/18] x86/sgx: Add EPC page flags to identify owner types
Date: Fri, 22 Sep 2023 20:06:49 -0700
Message-ID: <20230923030657.16148-11-haitao.huang@linux.intel.com>
References: <20230923030657.16148-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695438426; x=1726974426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6rGwrEe4Ukw7FcCDvhuspXyNUODXLObGeH1s03Sjd5k=;
  b=NQAKpaPCKs6WV2O14ecofFZZ9esdSnu0asaZdOVT+XQageN1ztqicilL
   rzAY1Oc6Dj3M1jWLYOwxjOf003wyh9gJpnluU4FkJiYW5BPqxk9+TVxpI
   Uyukf/dregEBk1zKYgAO1z//YfiwxErw/Si3OBB/C9mBM64Ht/Yernpur
   HDErU2BNxrok2XAhulmiKK7Y8dL+xGUCwVSG9gEJOn2GMNzgdjvswrEU1
   avvk1vtjlIOzvXABdLE2yrt07Jhu8RPC0f8CwtJyO4cZ7swcDqY33gc2m
   3ohVt24lWqYDZrkNv/JFTWdTwaoeU47on21VzB/EkYFlGnQpnRv1CQCLX
   A==;
In-Reply-To: <20230923030657.16148-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Two types of owners of struct sgx_epc_page, 'sgx_encl' for VA pages and
'sgx_encl_page' can be stored in the previously introduced union field.

OOM support for cgroups requires that the owner needs to be identified
when selecting pages from the unreclaimable list. Address this by adding
flags for the owner type.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Co-developed-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Co-developed-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
V4:
- Updates for patch reordering.
- Rename SGX_EPC_OWNER_ENCL_PAGE to SGX_EPC_OWNER_PAGE. (Jarkko)
- Commit message changes. (Jarkko)
---
 arch/x86/kernel/cpu/sgx/encl.c  | 9 +++++----
 arch/x86/kernel/cpu/sgx/ioctl.c | 6 ++++--
 arch/x86/kernel/cpu/sgx/sgx.h   | 6 ++++++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index ec3402d41b63..da1657813fce 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -248,6 +248,7 @@ static struct sgx_epc_page *sgx_encl_load_secs(struct sgx_encl *encl)
 		epc_page = sgx_encl_eldu(&encl->secs, NULL);
 		if (!IS_ERR(epc_page))
 			sgx_record_epc_page(epc_page,
+					    SGX_EPC_OWNER_PAGE |
 					    SGX_EPC_PAGE_UNRECLAIMABLE);
 	}
 
@@ -276,7 +277,7 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 		return ERR_CAST(epc_page);
 
 	encl->secs_child_cnt++;
-	sgx_record_epc_page(epc_page, SGX_EPC_PAGE_RECLAIMABLE);
+	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_PAGE | SGX_EPC_PAGE_RECLAIMABLE);
 
 	return entry;
 }
@@ -402,7 +403,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	encl_page->type = SGX_PAGE_TYPE_REG;
 	encl->secs_child_cnt++;
 
-	sgx_record_epc_page(epc_page, SGX_EPC_PAGE_RECLAIMABLE);
+	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_PAGE | SGX_EPC_PAGE_RECLAIMABLE);
 
 	phys_addr = sgx_get_epc_phys_addr(epc_page);
 	/*
@@ -1261,8 +1262,8 @@ struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim)
 		sgx_encl_free_epc_page(epc_page);
 		return ERR_PTR(-EFAULT);
 	}
-	sgx_record_epc_page(epc_page,
-			    SGX_EPC_PAGE_UNRECLAIMABLE);
+	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_ENCL |
+				      SGX_EPC_PAGE_UNRECLAIMABLE);
 
 	return epc_page;
 }
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 164256ea18d0..cd338e93acc1 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -114,6 +114,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->attributes_mask = SGX_ATTR_UNPRIV_MASK;
 
 	sgx_record_epc_page(encl->secs.epc_page,
+			    SGX_EPC_OWNER_PAGE |
 			    SGX_EPC_PAGE_UNRECLAIMABLE);
 
 	/* Set only after completion, as encl->lock has not been taken. */
@@ -325,7 +326,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 			goto err_out;
 	}
 
-	sgx_record_epc_page(epc_page, SGX_EPC_PAGE_RECLAIMABLE);
+	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_PAGE | SGX_EPC_PAGE_RECLAIMABLE);
 	mutex_unlock(&encl->lock);
 	mmap_read_unlock(current->mm);
 	return ret;
@@ -979,7 +980,8 @@ static long sgx_enclave_modify_types(struct sgx_encl *encl,
 
 			mutex_lock(&encl->lock);
 
-			sgx_record_epc_page(entry->epc_page, SGX_EPC_PAGE_RECLAIMABLE);
+			sgx_record_epc_page(entry->epc_page,
+					    SGX_EPC_OWNER_PAGE | SGX_EPC_PAGE_RECLAIMABLE);
 		}
 
 		/* Change EPC type */
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 5110dd433b80..51aba1cd1937 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -64,6 +64,12 @@ enum sgx_epc_page_state {
 
 #define SGX_EPC_PAGE_STATE_MASK GENMASK(2, 0)
 
+/* flag for pages owned by a sgx_encl_page */
+#define SGX_EPC_OWNER_PAGE		BIT(3)
+
+/* flag for pages owned by a sgx_encl struct */
+#define SGX_EPC_OWNER_ENCL		BIT(4)
+
 struct sgx_epc_page {
 	unsigned int section;
 	u16 flags;
-- 
2.25.1

