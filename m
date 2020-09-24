From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Date: Thu, 24 Sep 2020 14:55:18 -0500
Message-ID: <cb592c59-a50e-5901-71fe-19e43bc9e37e@amd.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922014836.GA26507@linux.intel.com>
 <20200922211404.GA4141897@google.com> <20200924192116.GC9649@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7UsubZXg6mj4POG76N8fBLORLqTy1tMWbSBMVsqZjc=;
 b=CghLWnKR5Pccxu1UMlfbcFLUu4tLtpyBtQcGsQYeWjDvcHDh7LWnEQmqce4PzQsd1TbbXYkkeVGrfgPDb6bsuRdm9cD0+5Sk37jQcXrpnA8qN63Gk8bStURTJ4LWDLi5DQJVgtMdNDLgynW8IjlTQBOfY9EeIDneo2zBOAFXq/0=
In-Reply-To: <20200924192116.GC9649-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 9/24/20 2:21 PM, Sean Christopherson wrote:
> On Tue, Sep 22, 2020 at 02:14:04PM -0700, Vipin Sharma wrote:
>> On Mon, Sep 21, 2020 at 06:48:38PM -0700, Sean Christopherson wrote:
>>> On Mon, Sep 21, 2020 at 05:40:22PM -0700, Vipin Sharma wrote:
>>>> Hello,
>>>>
>>>> This patch series adds a new SEV controller for tracking and limiting
>>>> the usage of SEV ASIDs on the AMD SVM platform.
>>>>
>>>> SEV ASIDs are used in creating encrypted VM and lightweight sandboxes
>>>> but this resource is in very limited quantity on a host.
>>>>
>>>> This limited quantity creates issues like SEV ASID starvation and
>>>> unoptimized scheduling in the cloud infrastructure.
>>>>
>>>> SEV controller provides SEV ASID tracking and resource control
>>>> mechanisms.
>>>
>>> This should be genericized to not be SEV specific.  TDX has a similar
>>> scarcity issue in the form of key IDs, which IIUC are analogous to SEV ASIDs
>>> (gave myself a quick crash course on SEV ASIDs).  Functionally, I doubt it
>>> would change anything, I think it'd just be a bunch of renaming.  The hardest
>>> part would probably be figuring out a name :-).
>>>
>>> Another idea would be to go even more generic and implement a KVM cgroup
>>> that accounts the number of VMs of a particular type, e.g. legacy, SEV,
>>> SEV-ES?, and TDX.  That has potential future problems though as it falls
>>> apart if hardware every supports 1:MANY VMs:KEYS, or if there is a need to
>>> account keys outside of KVM, e.g. if MKTME for non-KVM cases ever sees the
>>> light of day.
>>
>> I read about the TDX and its use of the KeyID for encrypting VMs. TDX
>> has two kinds of KeyIDs private and shared.
> 
> To clarify, "shared" KeyIDs are simply legacy MKTME KeyIDs.  This is relevant
> because those KeyIDs can be used without TDX or KVM in the picture.
> 
>> On AMD platform there are two types of ASIDs for encryption.
>> 1. SEV ASID - Normal runtime guest memory encryption.
>> 2. SEV-ES ASID - Extends SEV ASID by adding register state encryption with
>> 		 integrity.
>>
>> Both types of ASIDs have their own maximum value which is provisioned in
>> the firmware
> 
> Ugh, I missed that detail in the SEV-ES RFC.  Does SNP add another ASID type,
> or does it reuse SEV-ES ASIDs?  If it does add another type, is that trend
> expected to continue, i.e. will SEV end up with SEV, SEV-ES, SEV-ES-SNP,
> SEV-ES-SNP-X, SEV-ES-SNP-X-Y, etc...?

SEV-SNP and SEV-ES share the same ASID range.

Thanks,
Tom

> 
>> So, we are talking about 4 different types of resources:
>> 1. AMD SEV ASID (implemented in this patch as sev.* files in SEV cgroup)
>> 2. AMD SEV-ES ASID (in future, adding files like sev_es.*)
>> 3. Intel TDX private KeyID
>> 4. Intel TDX shared KeyID
>>
>> TDX private KeyID is similar to SEV and SEV-ES ASID. I think coming up
>> with the same name which can be used by both platforms will not be easy,
>> and extensible with the future enhancements. This will get even more
>> difficult if Arm also comes up with something similar but with different
>> nuances.
> 
> Honest question, what's easier for userspace/orchestration layers?  Having an
> abstract but common name, or conrete but different names?  My gut reaction is
> to provide a common interface, but I can see how that could do more harm than
> good, e.g. some amount of hardware capabilitiy discovery is possible with
> concrete names.  And I'm guessing there's already a fair amount of vendor
> specific knowledge bleeding into userspace for these features...
> 
> And if SNP is adding another ASID namespace, trying to abstract the types is
> probably a lost cause.
> 
>  From a code perspective, I doubt it will matter all that much, e.g. it should
> be easy enough to provide helpers for exposing a new asid/key type.
> 
>> I like the idea of the KVM cgroup and when it is mounted it will have
>> different files based on the hardware platform.
> 
> I don't think a KVM cgroup is the correct approach, e.g. there are potential
> use cases for "legacy" MKTME without KVM.  Maybe something like Encryption
> Keys cgroup?
> 
>> 1. KVM cgroup on AMD will have:
>> sev.max & sev.current.
>> sev_es.max & sev_es.current.
>>
>> 2. KVM cgroup mounted on Intel:
>> tdx_private_keys.max
>> tdx_shared_keys.max
>>
>> The KVM cgroup can be used to have control files which are generic (no
>> use case in my mind right now) and hardware platform specific files
>> also.
> 
> My "generic KVM cgroup" suggestion was probably a pretty bad suggestion.
> Except for ASIDs/KeyIDs, KVM itself doesn't manage any constrained resources,
> e.g. memory, logical CPUs, time slices, etc... are all generic resources that
> are consumed by KVM but managed elsewhere.  We definitely don't want to change
> that, nor do I think we want to do anything, such as creating a KVM cgroup,
> that would imply that having KVM manage resources is a good idea.
> 
