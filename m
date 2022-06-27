From: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Mon, 27 Jun 2022 16:07:32 +0000
Message-ID: <YrnVxM/5KjVhkOnn@google.com>
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-2-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=l0pibN8bjG0PnvfGdr94sagjrAjKQlwTKx4ke7hg5TE=;
 b=KXpJaULYCMOBvM0KZ+Y0QmYKcs5GsOT3UDoT12OxOmZTuofXiRwwGm/WgJTM1heXoI
 t1dv3k342OQnZ9iooXjd608cniWLl0qlDw2/EFrZO3JITiMUniSnoS9vRpsVYcQj8vN/
 I7nko6H+yxfXlWmj6BpVmIQCvWqpF55RTmiG3dExwV8krl6JWA8dxuz7o3cuKUtlCKLL
 AUH1GrHaKcLi0AxNkq1Q0RlPIztx9SDq4ccjZXK7Aa2jkpBZXbRVUSJ+/fIBfJxIB9bo
 wqHrvEDbll+Qw87/iH2rzRcMOLCQ34VpKyfcZXoB0fUgM3GYU80A2xB80LHN6E80KQa1
 5riQ==
Content-Disposition: inline
In-Reply-To: <20220606222058.86688-2-yosryahmed@google.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>

On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> KVM mmu. This provides more insights on the kernel memory used
> by a workload.

Please provide more justification for NR_SECONDARY_PAGETABLE in the changelog.
Specially, answer the questions that were asked in the previous version:

  1. Why not piggyback NR_PAGETABLE?
  2. Why a "generic" NR_SECONDARY_PAGETABLE instead of NR_VIRT_PAGETABLE?

It doesn't have to be super long, but provide enough info so that reviewers and
future readers don't need to go spelunking to understand the motivation for the
new counter type.

And it's probably worth an explicit Link to Marc's question that prompted the long
discussion in the previous version, that way if someone does want the gory details
they have a link readily available.

Link: https://lore.kernel.org/all/87ilqoi77b.wl-maz@kernel.org
