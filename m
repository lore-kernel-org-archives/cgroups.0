From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 6/6] KVM: mips/mmu: count KVM page table pages in pagetable stats
Date: Tue, 26 Apr 2022 05:39:04 +0000
Message-ID: <20220426053904.3684293-7-yosryahmed@google.com>
References: <20220426053904.3684293-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UwrHlKcfzo3tcKJryiZhc3lnWD2SSBQRLRI0NxtXWrY=;
        b=lNtBON0+mp7QtqbJUF/yxX4uqPIpQ5Y7hbeXAfVLxM4ZET7uCEK3knJCpkoyZMJa9s
         i7nzVR4VlmZxg+avleS7/Kn/bJZBjnZBXIxlYf/uArgxa5lJaYe/WDTMeZAb28KsbwWU
         ocTkXwvTjA1uESTwFj+I7wr5Rl5sM2mE2cN5TIARIpTfKY2dD2+gpHj1coFpygAy+fc7
         zaCTEQdiWA+0CcKFMaPUEAafXSOqS1yBx10IaODNf6+xQNBSZhNIV/u+JCOUySMFWRfr
         Ms9jv8dEpQuxx8npEiVjqTZIl7JhMtAENDSGpOK7TpWZOGwxxlN4+Ot896M99UFlnkfM
         gIIQ==
In-Reply-To: <20220426053904.3684293-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huacai Chen <chenhuacai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aleksandar Markovic <aleksandar.qemu.devel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anup Patel <anup-aa5cPYPs4nSSZfiimGR9Ow@public.gmane.org>, Atish Patra <atishp-WKKQYwWt7ev9JmXXK+q4OQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Shameer Kolothum <shameerali.kolothum.thodi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mips-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-riscv-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Count the pages used by KVM in mips for page tables in pagetable stats.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/mips/kvm/mips.c | 1 +
 arch/mips/kvm/mmu.c  | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index a25e0b73ee70..e60c1920a408 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -175,6 +175,7 @@ static void kvm_mips_free_gpa_pt(struct kvm *kvm)
 {
 	/* It should always be safe to remove after flushing the whole range */
 	WARN_ON(!kvm_mips_flush_gpa_pt(kvm, 0, ~0));
+	kvm_account_pgtable_pages((void *)kvm->arch.gpa_mm.pgd, -1);
 	pgd_free(NULL, kvm->arch.gpa_mm.pgd);
 }
 
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 1bfd1b501d82..18da2ac2ded7 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -81,8 +81,10 @@ pgd_t *kvm_pgd_alloc(void)
 	pgd_t *ret;
 
 	ret = (pgd_t *)__get_free_pages(GFP_KERNEL, PGD_ORDER);
-	if (ret)
+	if (ret) {
 		kvm_pgd_init(ret);
+		kvm_account_pgtable_pages((void *)ret, +1);
+	}
 
 	return ret;
 }
@@ -125,6 +127,7 @@ static pte_t *kvm_mips_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *cache,
 		pmd_init((unsigned long)new_pmd,
 			 (unsigned long)invalid_pte_table);
 		pud_populate(NULL, pud, new_pmd);
+		kvm_account_pgtable_pages((void *)new_pmd, +1);
 	}
 	pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd)) {
@@ -135,6 +138,7 @@ static pte_t *kvm_mips_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *cache,
 		new_pte = kvm_mmu_memory_cache_alloc(cache);
 		clear_page(new_pte);
 		pmd_populate_kernel(NULL, pmd, new_pte);
+		kvm_account_pgtable_pages((void *)new_pte, +1);
 	}
 	return pte_offset_kernel(pmd, addr);
 }
@@ -189,6 +193,7 @@ static bool kvm_mips_flush_gpa_pmd(pmd_t *pmd, unsigned long start_gpa,
 
 		if (kvm_mips_flush_gpa_pte(pte, start_gpa, end)) {
 			pmd_clear(pmd + i);
+			kvm_account_pgtable_pages((void *)pte, -1);
 			pte_free_kernel(NULL, pte);
 		} else {
 			safe_to_remove = false;
@@ -217,6 +222,7 @@ static bool kvm_mips_flush_gpa_pud(pud_t *pud, unsigned long start_gpa,
 
 		if (kvm_mips_flush_gpa_pmd(pmd, start_gpa, end)) {
 			pud_clear(pud + i);
+			kvm_account_pgtable_pages((void *)pmd, -1);
 			pmd_free(NULL, pmd);
 		} else {
 			safe_to_remove = false;
@@ -247,6 +253,7 @@ static bool kvm_mips_flush_gpa_pgd(pgd_t *pgd, unsigned long start_gpa,
 
 		if (kvm_mips_flush_gpa_pud(pud, start_gpa, end)) {
 			pgd_clear(pgd + i);
+			kvm_account_pgtable_pages((void *)pud, -1);
 			pud_free(NULL, pud);
 		} else {
 			safe_to_remove = false;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

