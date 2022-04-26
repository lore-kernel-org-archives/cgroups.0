From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64/mmu: count KVM page table pages in
 pagetable stats
Date: Tue, 26 Apr 2022 12:27:57 -0700
Message-ID: <CAJD7tkY-WZKcyer=TbWF0dVfOhvZO7hqPN=AYCDZe1f+2HA-QQ@mail.gmail.com>
References: <20220426053904.3684293-1-yosryahmed@google.com>
 <20220426053904.3684293-5-yosryahmed@google.com> <YmegoB/fBkfwaE5z@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-riscv-bounces+gcekr-kvm-riscv=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:Cc:To:Subject:Message-ID:Date:From:
	In-Reply-To:References:MIME-Version:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=sJqn7jUUjPXmhhsBTYTgXLN16KHPA9/ytx124g06ek0=; b=ruFG1nhZCoPYY8
	2xWPPypnO1QjMBgNgWqZ7IDkqaGvnSesGI/9CFtaJdHHmMug96MCn95nbpJJolhqtUzQZfKTazmpr
	GI3MEkM37AZ4rG9NMIpdepMgBf1pUO5H9a09PgrG3O1J1LSzmYqIXfaGp46tq97Pn/7K6WdXPqAMz
	YB7eNDhl2AiyaqXZ26DVo8jyoM7cVL+gYjXy7Ko4JRIwBO8nfzSPSPAfd3ZijycW463NuMJoIlk22
	YsaZVwt9nhpMDZjYAS55yQAUIysTmJqlfMQqEfSWaUeta/OhTcXUJ7ryFYZpMXRSh+EaFU/nGS4RC
	Y2/+vJoYtj2AB0t8kjyg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=iQFCk4jvRcDNbkwKt80r8M9Ev1zqOHCdGqGh5NtELGk=;
 b=kXX2A5pPeYzQ7cMHjUay8+MRco1JY+qcFRaRS08NAVmtfBRdvFVDmNjStpeUWkd6Zl
 vQU5f0FWDf6xsz3RbldyIy9/g5QXdZSQZuDeQifodlFGCf1YGsKpdQYyR2g9y7Y6oB7V
 /fsu0vO21DVFRug79wN6ff9wbCwuMNbpj0fPxn9wyJ+3cQTLW9PimSQ9f6xgnaxtH2fO
 AlrXyAXCzlK49e6n1Ju/HDLsl9jTbgxFH3GdBJYGeSidfswDSkOpdP8/KDLnQJLtqZUp
 IpGuwUWRrQLmAANIliRHGcWrJVnvTEjLAdmNwn2651HlpB30PBm/qWLfwGYSI3Qrg/mB
 i7nw==
In-Reply-To: <YmegoB/fBkfwaE5z@google.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kvm-riscv>,
 <mailto:kvm-riscv-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kvm-riscv/>
List-Post: <mailto:kvm-riscv@lists.infradead.org>
List-Help: <mailto:kvm-riscv-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kvm-riscv>,
 <mailto:kvm-riscv-request@lists.infradead.org?subject=subscribe>
Sender: "kvm-riscv" <kvm-riscv-bounces@lists.infradead.org>
Errors-To: kvm-riscv-bounces+gcekr-kvm-riscv=m.gmane-mx.org@lists.infradead.org
To: Oliver Upton <oupton@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, James Morse <james.morse@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Marc Zyngier <maz@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, linux-mips@vger.kernel.org, kvm@vger.ke

Hi Oliver,
Thanks so much for taking the time to take a look at this!

On Tue, Apr 26, 2022 at 12:35 AM Oliver Upton <oupton@google.com> wrote:
>
> Hi Yosry,
>
> On Tue, Apr 26, 2022 at 05:39:02AM +0000, Yosry Ahmed wrote:
> > Count the pages used by KVM in arm64 for page tables in pagetable stats.
> >
> > Account pages allocated for PTEs in pgtable init functions and
> > kvm_set_table_pte().
> >
> > Since most page table pages are freed using put_page(), add a helper
> > function put_pte_page() that checks if this is the last ref for a pte
> > page before putting it, and unaccounts stats accordingly.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >  arch/arm64/kernel/image-vars.h |  3 ++
> >  arch/arm64/kvm/hyp/pgtable.c   | 50 +++++++++++++++++++++-------------
> >  2 files changed, 34 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> > index 241c86b67d01..25bf058714f6 100644
> > --- a/arch/arm64/kernel/image-vars.h
> > +++ b/arch/arm64/kernel/image-vars.h
> > @@ -143,6 +143,9 @@ KVM_NVHE_ALIAS(__hyp_rodata_end);
> >  /* pKVM static key */
> >  KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
> >
> > +/* Called by kvm_account_pgtable_pages() to update pagetable stats */
> > +KVM_NVHE_ALIAS(__mod_lruvec_page_state);
> > +
> >  #endif /* CONFIG_KVM */
> >
> >  #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 2cb3867eb7c2..53e13c3313e9 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -152,6 +152,7 @@ static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
> >
> >       WARN_ON(kvm_pte_valid(old));
> >       smp_store_release(ptep, pte);
> > +     kvm_account_pgtable_pages((void *)childp, +1);
>
> What page tables do we want to account? KVM on ARM manages several page
> tables.
>
> For regular KVM, the host kernel manages allocations for the hyp stage 1
> tables in addition to the stage 2 tables used for a particular VM. The
> former is system overhead whereas the latter could be attributed to a
> guest VM.

Honestly I would love to get your input on this. The main motivation
here is to give users insights on the kernel memory usage on their
system (or in a cgroup). We currently have NR_PAGETABLE stats for
normal kernel page tables (allocated using
__pte_alloc_one()/pte_free()), this shows up in /proc/meminfo,
/path/to/cgroup/memory.stat, and node stats. The idea is to add
NR_SECONDARY_PAGETABLE that should include the memory used for kvm
pagetables, which should be a separate category (no overlap). What
gets included or not depends on the semantics of KVM and what exactly
falls under the category of secondary pagetables from the user's pov.

Currently it looks like s2 page table allocations get accounted to
kmem of memory control groups (GFP_KERNEL_ACCOUNT), while hyp page
table allocations do not (GFP_KERNEL). So we could either follow this
and only account s2 page table allocations in the stats, or make hyp
allocations use GFP_KERNEL_ACCOUNT as well and add them to the stats.
Let me know what you think.

>
> I imagine protected KVM is out of scope, since it actually manages its
> own allocations outside of the host kernel.
>
> Given this, I would recommend adding the accounting hooks to mmu.c as
> that is where we alloc/free table pages and it is in the host address
> space. kvm_s2_mm_ops and kvm_hyp_mm_ops point to all the relevant
> functions, though the latter is only relevant if we want to count system
> page tables too.

Yeah moving the accounting hooks to mmu.c is much cleaner, I will do
this in the next version. The only reason I did not do this is that I
found other kvm_pgtable_mm_ops structs (such as pkvm_pgtable_mm_ops),
but it looks like these may be irrelevant here.

>
> --
> Thanks,
> Oliver

-- 
kvm-riscv mailing list
kvm-riscv@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/kvm-riscv
