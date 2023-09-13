From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v4 10/18] x86/sgx: Add EPC page flags to identify owner types
Date: Tue, 12 Sep 2023 21:06:27 -0700
Message-ID: <20230913040635.28815-11-haitao.huang@linux.intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694578133; x=1726114133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q09Cq5wcqUCMJWJYkZPqWte0qkGjBtdYwPvO7xTYtG0=;
  b=RADexiLwciZPxKOy81/Q5bCucO8QSmdbdEdiTdtK56Vuuidj6a81Np/g
   e3pQX/PaIM2c/ziSyTrdG3UDLsmI5z2fG/GttIx87bH9+SHywXye4RbQH
   a+6f4HS1J3oLeu2hwZi5hvcr09RVon6bxUlhwLeUi5xkyRM9IRRpIIXlL
   8oaDvFj/TueQbCSxPSg199/G4bxONXb4h4/SXxL+k+o1ctmIOa6V5tYXY
   i1BLLMWGQVYT8bYdkXOcb99x8TwFTBwaZDTQja4dQjNVUMYetd9cgZGy3
   9b0r4z0e7XVDimIKeS69pW60ERCDCBzLFVyEuHhv5ge4oGTCmEigTVLgC
   w==;
In-Reply-To: <20230913040635.28815-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
V4:
- Updates for patch reordering.
- Rename SGX_EPC_OWNER_ENCL_PAGE to SGX_EPC_OWNER_PAGE. (Jarkko)
- Commit message changes. (Jarkko)
---
 arch/x86/kernel/cpu/sgx/encl.c  | 13 +++++++------
 arch/x86/kernel/cpu/sgx/ioctl.c |  6 ++++--
 arch/x86/kernel/cpu/sgx/sgx.h   |  6 ++++++
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 1aee0ad00e66..91f83a5e543d 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -248,6 +248,7 @@ static struct sgx_epc_page *sgx_encl_load_secs(struct sgx_encl *encl)
 		epc_page = sgx_encl_eldu(&encl->secs, NULL);
 		if (!IS_ERR(epc_page))
 			sgx_record_epc_page(epc_page,
+					    SGX_EPC_OWNER_PAGE |
 					    SGX_EPC_PAGE_UNRECLAIMABLE);
 	}
 
@@ -276,8 +277,8 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 		return ERR_CAST(epc_page);
 
 	encl->secs_child_cnt++;
-	sgx_record_epc_page(epc_page,
-			    SGX_EPC_PAGE_RECLAIMABLE);
+	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_PAGE |
+				      SGX_EPC_PAGE_RECLAIMABLE);
 
 	return entry;
 }
@@ -403,8 +404,8 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	encl_page->type = SGX_PAGE_TYPE_REG;
 	encl->secs_child_cnt++;
 
-	sgx_record_epc_page(epc_page,
-			    SGX_EPC_PAGE_RECLAIMABLE);
+	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_PAGE |
+				      SGX_EPC_PAGE_RECLAIMABLE);
 
 	phys_addr = sgx_get_epc_phys_addr(epc_page);
 	/*
@@ -1263,8 +1264,8 @@ struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim)
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
index 3ab8c050e665..95ec20a6992f 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -114,6 +114,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->attributes_mask = SGX_ATTR_UNPRIV_MASK;
 
 	sgx_record_epc_page(encl->secs.epc_page,
+			    SGX_EPC_OWNER_PAGE |
 			    SGX_EPC_PAGE_UNRECLAIMABLE);
 
 	/* Set only after completion, as encl->lock has not been taken. */
@@ -325,8 +326,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 			goto err_out;
 	}
 
-	sgx_record_epc_page(epc_page,
-			    SGX_EPC_PAGE_RECLAIMABLE);
+	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_PAGE |
+				      SGX_EPC_PAGE_RECLAIMABLE);
 	mutex_unlock(&encl->lock);
 	mmap_read_unlock(current->mm);
 	return ret;
@@ -981,6 +982,7 @@ static long sgx_enclave_modify_types(struct sgx_encl *encl,
 			mutex_lock(&encl->lock);
 
 			sgx_record_epc_page(entry->epc_page,
+					    SGX_EPC_OWNER_PAGE |
 					    SGX_EPC_PAGE_RECLAIMABLE);
 		}
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index c75ddc7168fa..e06b4aadb6a1 100644
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

