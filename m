From: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v5 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Date: Mon, 27 Jun 2022 16:22:46 +0000
Message-ID: <YrnZVgq1E/u1nYm0@google.com>
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-4-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cV3hVzy9TYCqPFueATEq37SOh6vFTuLA/SrvAB62Xzg=;
        b=BseriqoiozT548bWf87kfEM21QE/lsC7Xh53iRBx2LmFdeNav386MocuZafko2ZdzZ
         JQe5ovxOhcstFhT8iCD21C825q81Za8C3tdgW13ebnSYPD7k8WHS3yPH0VHQSCGZnmQf
         FicGbHrtEuD0O3jI+Q4LIietAgpYwoWp5qedMxPLBADENHHnn+UkkXouxHyxDA/j0F9g
         moM6KAIDklQszHLohnncrg9SWHa8qDcecTbUS930nHP7JYFxSIbGRQKh+59wLE+AXy7E
         fCLhJT8SPzPCj5eph3yGYAVFqleuzS1aYTb4Me1axhRhNHXk+NS3u9/PAs9nbb1c6HO+
         fcfA==
Content-Disposition: inline
In-Reply-To: <20220606222058.86688-4-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.ker

On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> Count the pages used by KVM mmu on x86 for in secondary pagetable stats.

"for in" is funky.  And it's worth providing a brief explanation of what the
secondary pagetable stats actually are.  "secondary" is confusingly close to
"second level pagetables", e.g. might be misconstrued as KVM counters for the
number of stage-2 / two-dimension paging page (TDP) tables.

Code looks good, though it needs a rebased on kvm/queue.
