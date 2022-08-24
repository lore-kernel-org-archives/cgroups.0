From: Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v7 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Wed, 24 Aug 2022 14:41:49 +0100
Message-ID: <5ac13c91-0e42-533b-42d0-c78573c7aef3@arm.com>
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-2-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8QO4NfCRvPIxHD4KoVawSEO35sm00qw6iLvrhxKuD8=;
 b=2Dnu/yQaOPnMvsog7c+Q5GKZuzvmuIUdZMsEOklil0M49jnr7hazZ9kZnsP7oItBXvjxEXVvb8r5Thxm6oNGXAu/83ZlvJ+3c6GA7rR52eLKpzq0LjU8r2NFhcZ85/ksWwmXKXUrE7EQNoVN0o1TKrTUr2/3fNu8WHN8NmnU8ZA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8QO4NfCRvPIxHD4KoVawSEO35sm00qw6iLvrhxKuD8=;
 b=2Dnu/yQaOPnMvsog7c+Q5GKZuzvmuIUdZMsEOklil0M49jnr7hazZ9kZnsP7oItBXvjxEXVvb8r5Thxm6oNGXAu/83ZlvJ+3c6GA7rR52eLKpzq0LjU8r2NFhcZ85/ksWwmXKXUrE7EQNoVN0o1TKrTUr2/3fNu8WHN8NmnU8ZA=
Content-Language: en-US
In-Reply-To: <20220823004639.2387269-2-yosryahmed@google.com>
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

> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index e7aafc82be99..898c99eae8e4 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -982,6 +982,7 @@ Example output. You may not have all of these fields.
>       SUnreclaim:       142336 kB
>       KernelStack:       11168 kB
>       PageTables:        20540 kB
> +    SecPageTables:         0 kB
>       NFS_Unstable:          0 kB
>       Bounce:                0 kB
>       WritebackTmp:          0 kB
> @@ -1090,6 +1091,9 @@ KernelStack
>                 Memory consumed by the kernel stacks of all tasks
>   PageTables
>                 Memory consumed by userspace page tables
> +SecPageTables
> +              Memory consumed by secondary page tables, this currently
> +              currently includes KVM mmu allocations on x86 and arm64.

nit: I think you have a typo here: "currently currently".

Thanks,
Ryan
