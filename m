Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795657110;
	b=mjyeBIVP9k8KGXV3Dck97Nh8xdDyPLQHjNgvp/hLVIRSrBl4kl51bim5U0JdOq00eORx
	 VWE+UhLhZGFc3jYJMg02CaMflXupTzy8mt+IvlgLq0hWIhd0916w5lF7YBFRRCWbY3Jdq
	 sq5wNFHAFvNiQL1LJyEnQTd8CqA1Kic2LtyeMpGh/611lZZm8nxr8w0WoEwkFaPxYn+T6
	 bXEmb0+7hO2MejrZ9CbVDOnf23GnU8TevTQCBI+uvMH5TvClGVp6rZs2IP2lMMZTcgcyP
	 rikSsg6cQ4qXtI2vddzobIAKFdo9Jwlxc55pr/s0aztitSiqXFCfXQnXA7swGKBlkYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795657110;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=GxW/rflHfiQTyXh6SuOErrXibGTX0Pbxp+1B3z4FF3k=;
	b=AeWzs/InQfZAHBE3Og/n24h15p7iQuWauLm69dG38KYf4asnQLzngmWViaPw5CDx8NYK
	 gz0d66EqKq9DC/bG0w2AZWjNBztiI7ehF9e/r4I625aBlF9z4KZwhgND3kRbY0/p9GXOi
	 o5dC/Nq0wL1x4tLil3Ic7Vo0npMQA9mB21oCzc1PFGCl4XxYM9912MTq9zvCH3qcaw3XX
	 Qq6OQsjzvCCnpYG5TXaP5b5V0ZLCXxgIXJ9lv4ZmVV4XV4YTswYv8ASeCVPksh7VbLuDT
	 NmcA3LHZizFOOdK7Vr439KeVboAGTwzcMAJc16leiNwTQ1Rq+PCEodKTY5CqSEvDW6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mails.ucas.ac.cn;
	spf=pass smtp.mailfrom=mails.ucas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.25
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98D7606A31E;
	Thu, 26 Nov 2026 01:38:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E98D7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.ucas.ac.cn
Received: from k3-03 (unknown [159.226.43.8])
	by APP-05 (Coremail) with SMTP id zQCowACXLrRqjQdrOdr2AQ--.256S2;
	Thu, 26 Nov 2026 09:37:50 +0800 (CST)
From: Tan Chi <tanchi25@mails.ucas.ac.cn>
To: anup@brainfault.org
Cc: atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	yosry@kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tanchi25@mails.ucas.ac.cn,
	lkp@intel.com
Subject: [PATCH v2] RISC-V: KVM: Account G-stage page table memory
Date: Thu, 26 Nov 2026 09:37:23 +0800
Message-ID: <20261126013724.2533363-1-tanchi25@mails.ucas.ac.cn>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACXLrRqjQdrOdr2AQ--.256S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuFW5Xry7Kw13Cw4fJF4Utwb_yoW7uw13pF
	WkC34S9w1rtr93Cr13JwnF9r13Ga95Gr45Ary29a45ZFsxtr9aywnYq342vF15Xr95Zayf
	XrZIgFyYvr4vywUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPF14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxV
	WxJr0_GcWlnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r
	1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAq
	YI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wrylc2xSY4
	AK67AK6w4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjTRK38n
	DUUUU
X-CM-SenderInfo: pwdquxrlsvqzpdlo2hpxfd2hldfou0/

RISC-V KVM currently does not account G-stage page table memory
in NR_SECONDARY_PAGETABLE.

Use kvm_account_pgtable_pages() to account for the allocation and
freeing of the root and lower-level page tables, including those
allocated when splitting huge page mappings.

This makes G-stage page table memory usage visible through
SecPageTables in /proc/meminfo and sec_pagetables in the cgroup
memory.stat interface.

Update the documentation accordingly.

Tested on a RISC-V KVM host running under QEMU TCG with Sv57x4.
The observed G-stage page table memory usage was:

  100 empty VMs:                         1600 KiB
  8 GiB sparsely mapped with 4 KiB pages: 16448 KiB
  256 MiB mapped with 2 MiB pages:          36 KiB
  After enabling dirty logging:           548 KiB

The accounting in /proc/meminfo, /proc/vmstat and cgroup
memory.stat matched the expected values and returned to zero
after destroying the VMs.

This reimplements the work originally proposed by Yosry Ahmed
in 2022, adapted to the current G-stage MMU code.

Link: https://lore.kernel.org/r/20220426053904.3684293-6-yosryahmed@google.com

Signed-off-by: Tan Chi <tanchi25@mails.ucas.ac.cn>
---
Changes in v2:
- Use the allocation order to calculate the number of root page
  table pages, fixing a Clang warning reported by the kernel test
  robot.
  https://lore.kernel.org/oe-kbuild-all/20261126015340.s7bzBtEB-lkp@intel.com/

 Documentation/admin-guide/cgroup-v2.rst |  4 ++--
 Documentation/filesystems/proc.rst      |  2 +-
 arch/riscv/kvm/gstage.c                 |  6 +++++-
 arch/riscv/kvm/mmu.c                    | 12 ++++++++----
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..c79d6432ecc3 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1591,8 +1591,8 @@ The following nested keys are defined.
 
 	  sec_pagetables
 		Amount of memory allocated for secondary page tables,
-		this currently includes KVM mmu allocations on x86
-		and arm64 and IOMMU page tables.
+		this currently includes KVM mmu allocations on x86,
+		arm64 and riscv and IOMMU page tables.
 
 	  percpu (npn)
 		Amount of memory used for storing per-cpu kernel
diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index fa7a468e8edf..cd1a74da287c 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -1208,7 +1208,7 @@ PageTables
               Memory consumed by userspace page tables
 SecPageTables
               Memory consumed by secondary page tables, this currently includes
-              KVM mmu and IOMMU allocations on x86 and arm64.
+              KVM mmu and IOMMU allocations on x86, arm64 and riscv.
 NFS_Unstable
               Always zero. Previously counted pages which had been written to
               the server, but has not been committed to stable storage.
diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index 0aace3215d3e..f8841136d852 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -162,6 +162,7 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
 				return -ENOMEM;
 			set_pte(ptep, pfn_pte(PFN_DOWN(__pa(next_ptep)),
 					      __pgprot(_PAGE_TABLE)));
+			kvm_account_pgtable_pages(next_ptep, 1);
 		} else {
 			if (gstage_pte_leaf(ptep))
 				return -EEXIST;
@@ -357,6 +358,7 @@ bool kvm_riscv_gstage_split_huge(struct kvm_gstage *gstage,
 
 		set_pte(ptep, pfn_pte(PFN_DOWN(__pa(next_ptep)),
 				__pgprot(_PAGE_TABLE)));
+		kvm_account_pgtable_pages(next_ptep, 1);
 
 		if (flush)
 			gstage_tlb_flush(gstage, current_level, addr);
@@ -399,8 +401,10 @@ bool kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
 		for (i = 0; i < PTRS_PER_PTE; i++)
 			flush |= kvm_riscv_gstage_op_pte(gstage, addr + i * next_page_size,
 							 &next_ptep[i], next_ptep_level, op);
-		if (op == GSTAGE_OP_CLEAR)
+		if (op == GSTAGE_OP_CLEAR) {
+			kvm_account_pgtable_pages(next_ptep, -1);
 			put_page(virt_to_page(next_ptep));
+		}
 	} else {
 		old_pte = *ptep;
 		if (op == GSTAGE_OP_CLEAR)
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 6861c0e2728d..ab8d8c94a866 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -805,17 +805,18 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 int kvm_riscv_mmu_alloc_pgd(struct kvm *kvm)
 {
 	struct page *pgd_page;
+	int order = get_order(kvm_riscv_gstage_pgd_size);
 
 	if (kvm->arch.pgd != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
 		return -EINVAL;
 	}
 
-	pgd_page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
-			       get_order(kvm_riscv_gstage_pgd_size));
+	pgd_page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, order);
 	if (!pgd_page)
 		return -ENOMEM;
 	kvm->arch.pgd = page_to_virt(pgd_page);
+	kvm_account_pgtable_pages(kvm->arch.pgd, 1 << order);
 	kvm->arch.pgd_phys = page_to_phys(pgd_page);
 	kvm->arch.pgd_levels = kvm_riscv_gstage_max_pgd_levels;
 	kvm->arch.pgd_split_page_cache.gfp_zero = __GFP_ZERO;
@@ -828,6 +829,7 @@ void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
 	struct kvm_gstage gstage;
 	void *pgd = NULL;
 	bool flush = false;
+	int order = get_order(kvm_riscv_gstage_pgd_size);
 
 	write_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
@@ -843,8 +845,10 @@ void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
 
-	if (pgd)
-		free_pages((unsigned long)pgd, get_order(kvm_riscv_gstage_pgd_size));
+	if (pgd) {
+		kvm_account_pgtable_pages(pgd, -(1 << order));
+		free_pages((unsigned long)pgd, order);
+	}
 }
 
 void kvm_riscv_mmu_update_hgatp(struct kvm_vcpu *vcpu)

base-commit: 4dce97c6c265544342e716e62fd24bbb232590c5
-- 
2.53.0

