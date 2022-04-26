From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v3 5/6] KVM: riscv/mmu: count KVM page table pages in
 pagetable stats
Date: Tue, 26 Apr 2022 05:39:03 +0000
Message-ID: <20220426053904.3684293-6-yosryahmed@google.com>
References: <20220426053904.3684293-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-mips-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=a9VzBJlMLigws4pRoWaDUwEnDDiqJQ0nJjM8cxStkWo=;
        b=p8mJqCwHacTbFhvYHu8ybGXK2P+PghFMqaxHHJuqdpta07t/m8JQTkdFg82eEvuWYd
         OdSYMSKPBvO7ptjR046sAX/bHvFVjhg/pzuwVzXmGfoIsID/2GXXQHWYzh25sp8Zhqzf
         htWeN1iMzxl7/9Pdv1zinxHd6q+dx76sncvVGGjZOTWwwfxxB2qSbB8gn6IY5+O3yc7/
         BeF9G0WjghrY1fZ5jCmiJkVNg5fp3DJ1BPeCzpmLCtKqzsEWqGLssoJmyaPfwKCC+CiD
         5TQ/VweVfCM1sVLfYaViWaZEyQtlCxE0YpkORn8opIIBD11EyDSBFcvRbtm+lxTTiRjt
         7Vwg==
In-Reply-To: <20220426053904.3684293-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc@google.com>, Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, James Morse <james.morse@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Marc Zyngier <maz@kernel.org>
Cc: linux-mips@vger.kernel.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Yosry Ahmed <yosryahmed@google.com>

Count the pages used by KVM in riscv for page tables in pagetable stats.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 arch/riscv/kvm/mmu.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index f80a34fbf102..fcfb75713750 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -152,6 +152,7 @@ static int stage2_set_pte(struct kvm *kvm, u32 level,
 			next_ptep = kvm_mmu_memory_cache_alloc(pcache);
 			if (!next_ptep)
 				return -ENOMEM;
+			kvm_account_pgtable_pages((void *)next_ptep, +1);
 			*ptep = pfn_pte(PFN_DOWN(__pa(next_ptep)),
 					__pgprot(_PAGE_TABLE));
 		} else {
@@ -229,6 +230,7 @@ static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
 	pte_t *next_ptep;
 	u32 next_ptep_level;
 	unsigned long next_page_size, page_size;
+	struct page *p;
 
 	ret = stage2_level_to_page_size(ptep_level, &page_size);
 	if (ret)
@@ -252,8 +254,13 @@ static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
 		for (i = 0; i < PTRS_PER_PTE; i++)
 			stage2_op_pte(kvm, addr + i * next_page_size,
 					&next_ptep[i], next_ptep_level, op);
-		if (op == STAGE2_OP_CLEAR)
-			put_page(virt_to_page(next_ptep));
+		if (op == STAGE2_OP_CLEAR) {
+			p = virt_to_page(next_ptep);
+			if (page_count(p) == 1)
+				kvm_account_pgtable_pages((void *)next_ptep,
+							  -1);
+			put_page(p);
+		}
 	} else {
 		if (op == STAGE2_OP_CLEAR)
 			set_pte(ptep, __pte(0));
@@ -700,25 +707,27 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
 {
 	struct page *pgd_page;
+	int order;
 
 	if (kvm->arch.pgd != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
 		return -EINVAL;
 	}
 
-	pgd_page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
-				get_order(stage2_pgd_size));
+	order = get_order(stage2_pgd_size);
+	pgd_page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!pgd_page)
 		return -ENOMEM;
 	kvm->arch.pgd = page_to_virt(pgd_page);
 	kvm->arch.pgd_phys = page_to_phys(pgd_page);
