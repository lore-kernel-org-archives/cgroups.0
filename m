From: Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v7 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in
 secondary pagetable stats
Date: Wed, 24 Aug 2022 18:03:17 +0100
Message-ID: <437ad644-a6f7-4b5e-ecb6-e8ddf4e4dc75@arm.com>
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-5-yosryahmed@google.com>
 <319904e0-3722-8ab1-cf74-491b9c32e23b@arm.com> <87zgftra6e.wl-maz@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UnLEWXSgT4DQTcGUbDdRxvIjcrMpuFfUSeoH7DIAOA=;
 b=gGf0K13V4/YG4AzmRS8GTSwB6RF6WOAI0akyYgCGu6pOnu4dbKYETPW37X4KsHgtnTFxQqEeH3HBTFS70XfI10S23c8rdpAu7/DaNuP/Q2YiI1cbNN8tzDyiGov5tBhvG0tykGT2ccNMDIBUViggmFYKFzajUeKDNKC14kT37ds=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UnLEWXSgT4DQTcGUbDdRxvIjcrMpuFfUSeoH7DIAOA=;
 b=gGf0K13V4/YG4AzmRS8GTSwB6RF6WOAI0akyYgCGu6pOnu4dbKYETPW37X4KsHgtnTFxQqEeH3HBTFS70XfI10S23c8rdpAu7/DaNuP/Q2YiI1cbNN8tzDyiGov5tBhvG0tykGT2ccNMDIBUViggmFYKFzajUeKDNKC14kT37ds=
Content-Language: en-US
In-Reply-To: <87zgftra6e.wl-maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Huang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Shaoqin <sh>

On 24/08/2022 15:24, Marc Zyngier wrote:
> On Wed, 24 Aug 2022 14:43:43 +0100,
> Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org> wrote:
>>
>>> Count the pages used by KVM in arm64 for stage2 mmu in memory stats
>>> under secondary pagetable stats (e.g. "SecPageTables" in /proc/meminfo)
>>> to give better visibility into the memory consumption of KVM mmu in a
>>> similar way to how normal user page tables are accounted.
>>>
>>> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> Reviewed-by: Oliver Upton <oliver.upton-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>>> Reviewed-by: Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> ---
>>
>> I see that you are not including the memory reserved for the host
>> stage2 table when using protected KVM. Is this something worth adding?
>> (See arch/arm64/kvm/pkvm.c:kvm_hyp_reserve()).
>>
>> This reservation is done pretty early on in bootmem_init() so not sure
>> if this could cause some init ordering issues that might be tricky to
>> solve though.
> 
> I also don't see what this buys us. This memory can't be reclaimed,
> and is not part of KVM's job for the purpose of running guests, which
> is what this series is about.
> 
> If anything, it should be accounted separately.

OK fair enough. It just struck me from the patch description that the 
host stage2 might qualify as "pages used by KVM in arm64 for stage2 
mmu". But I don't have any understanding of the use case this is for.

Sorry for the noise!

Thanks,
Ryan
