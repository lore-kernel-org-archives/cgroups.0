From: Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v7 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in
 secondary pagetable stats
Date: Wed, 24 Aug 2022 14:43:43 +0100
Message-ID: <319904e0-3722-8ab1-cf74-491b9c32e23b@arm.com>
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-5-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny0RVwBuBXUc/FcCoAgN5AtwiUXmoinaWxS/N0eMdYM=;
 b=gN3riQNW3YK4E3DJpvnIT5cm7Os/GVq3CTeY1a1maZKqWAwp8Onu0Q5+7lfTdU8v3vUrYR7BstjDhCvTA1T4GN57+T2bTXmsg+NVvdfjVLntINXd4YTS5eN06qoovxdUMxYMHHqUTVEvoZ+T9c2kmKGQiKatRuuDkal62aIGT/s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny0RVwBuBXUc/FcCoAgN5AtwiUXmoinaWxS/N0eMdYM=;
 b=gN3riQNW3YK4E3DJpvnIT5cm7Os/GVq3CTeY1a1maZKqWAwp8Onu0Q5+7lfTdU8v3vUrYR7BstjDhCvTA1T4GN57+T2bTXmsg+NVvdfjVLntINXd4YTS5eN06qoovxdUMxYMHHqUTVEvoZ+T9c2kmKGQiKatRuuDkal62aIGT/s=
Content-Language: en-US
In-Reply-To: <20220823004639.2387269-5-yosryahmed@google.com>
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
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed@google.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Shaoqin <shaoqin.huang@intel.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, nd@arm.com, Huang@google.com, linux-arm-kernel@lists.infradead.org

> Count the pages used by KVM in arm64 for stage2 mmu in memory stats
> under secondary pagetable stats (e.g. "SecPageTables" in /proc/meminfo)
> to give better visibility into the memory consumption of KVM mmu in a
> similar way to how normal user page tables are accounted.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> ---

I see that you are not including the memory reserved for the host stage2 
table when using protected KVM. Is this something worth adding? (See 
arch/arm64/kvm/pkvm.c:kvm_hyp_reserve()).

This reservation is done pretty early on in bootmem_init() so not sure 
if this could cause some init ordering issues that might be tricky to 
solve though.

Thanks,
Ryan
