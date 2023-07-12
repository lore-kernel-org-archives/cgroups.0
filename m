From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 02/28] x86/sgx: Add EPC page flags to identify owner type
Date: Wed, 12 Jul 2023 16:01:36 -0700
Message-ID: <20230712230202.47929-3-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202925; x=1720738925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YaqmO5zwAAno/VG9svXY8o2blO0PZnu2ossyoP+/A04=;
  b=MDlDClxbT7f5pTgQZSoVCz2ncGXd+K+B4CivkTQP7LUKcRiNiPm7YG2G
   nxoDozHPrgxATZjgyZ9fq0bKEqgX41Ff02j6UTKPZ5e/ieD3GsulLB0Et
   tLkx9jq2hZU8ngPPpiOMgUVAdR74l/ASxvRAMeSWStmkOeuWBojENXV/E
   GvGsb6hBbUK+/tn0SICu1kRmh1O5i9j9o+jjqCIg+kB6FCiRy1wMjMpv9
   qHt0I7WdbY+kz2FUC51w5Pog4lJYBvYz9At7K67rCczsHC1qs5+KALSvk
   gMntWZYN0C9Hr/67kJbqlx5bLnqb6AyB4+bzEcijQCaBeJVysG4hm6UoR
   g==;
In-Reply-To: <20230712230202.47929-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Two types of owners, 'sgx_encl' for VA pages and 'sgx_encl_page' for other,
can be stored in the union field in sgx_epc_page struct introduced in the
previous patch.

When cgroup OOM support is added in a later patch, the owning enclave of a
page will need to be identified. Retrieving the sgx_encl struct from a
sgx_epc_page will be different if the page is a VA page vs. other enclave
pages.

Add 2 flags which will identify the type of the owner and apply them
accordingly to newly allocated pages.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

V3:
- Renamed the flags to clarify they are used to identify the type
of the owner.
---
 arch/x86/kernel/cpu/sgx/encl.c  | 4 ++++
 arch/x86/kernel/cpu/sgx/ioctl.c | 4 ++++
 arch/x86/kernel/cpu/sgx/sgx.h   | 6 ++++++
 3 files changed, 14 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 98e1086eab07..3bc2f95b1da2 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -252,6 +252,7 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 		epc_page = sgx_encl_eldu(&encl->secs, NULL);
 		if (IS_ERR(epc_page))
 			return ERR_CAST(epc_page);
+		epc_page->flags |= SGX_EPC_OWNER_ENCL_PAGE;
 	}
 
 	epc_page = sgx_encl_eldu(entry, encl->secs.epc_page);
@@ -260,6 +261,7 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 
 	encl->secs_child_cnt++;
 	sgx_mark_page_reclaimable(entry->epc_page);
+	entry->epc_page->flags |= SGX_EPC_OWNER_ENCL_PAGE;
 
 	return entry;
 }
@@ -379,6 +381,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	encl->secs_child_cnt++;
 
 	sgx_mark_page_reclaimable(encl_page->epc_page);
+	encl_page->epc_page->flags |= SGX_EPC_OWNER_ENCL_PAGE;
 
 	phys_addr = sgx_get_epc_phys_addr(epc_page);
 	/*
@@ -1235,6 +1238,7 @@ struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim)
 		sgx_encl_free_epc_page(epc_page);
 		return ERR_PTR(-EFAULT);
 	}
+	epc_page->flags |= SGX_EPC_OWNER_ENCL;
 
 	return epc_page;
 }
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index fa8c3f32ccf6..fe3e89cf013f 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -113,6 +113,8 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->attributes = secs->attributes;
 	encl->attributes_mask = SGX_ATTR_UNPRIV_MASK;
 
+	encl->secs.epc_page->flags |= SGX_EPC_OWNER_ENCL_PAGE;
+
 	/* Set only after completion, as encl->lock has not been taken. */
 	set_bit(SGX_ENCL_CREATED, &encl->flags);
 
@@ -323,6 +325,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 	}
 
 	sgx_mark_page_reclaimable(encl_page->epc_page);
+	encl_page->epc_page->flags |= SGX_EPC_OWNER_ENCL_PAGE;
 	mutex_unlock(&encl->lock);
 	mmap_read_unlock(current->mm);
 	return ret;
@@ -977,6 +980,7 @@ static long sgx_enclave_modify_types(struct sgx_encl *encl,
 			mutex_lock(&encl->lock);
 
 			sgx_mark_page_reclaimable(entry->epc_page);
+			entry->epc_page->flags |= SGX_EPC_OWNER_ENCL_PAGE;
 		}
 
 		/* Change EPC type */
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index dc1cbcfcf2d4..f6e3c5810eef 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -29,6 +29,12 @@
 /* Pages on free list */
 #define SGX_EPC_PAGE_IS_FREE		BIT(1)
 
+/* flag for pages owned by a sgx_encl_page */
+#define SGX_EPC_OWNER_ENCL_PAGE		BIT(3)
+
+/* flag for pages owned by a sgx_encl struct */
+#define SGX_EPC_OWNER_ENCL		BIT(4)
+
 struct sgx_epc_page {
 	unsigned int section;
 	u16 flags;
-- 
2.25.1

