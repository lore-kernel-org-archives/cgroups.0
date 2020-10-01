From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Date: Thu, 1 Oct 2020 17:44:08 -0500
Message-ID: <cc3e88df-0c6e-2a8c-80aa-4dc3f0d8cea9@amd.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922014836.GA26507@linux.intel.com>
 <20200922211404.GA4141897@google.com> <20200924192116.GC9649@linux.intel.com>
 <cb592c59-a50e-5901-71fe-19e43bc9e37e@amd.com>
 <CAMkAt6oX+18cZy_t3hm0zo-sLmTGeGs5H9YAWvj7WBU7_uwU5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yEf+g4mo8w0D7XEf1cNEBHsUvG2MK+XzzJpAg645/b8=;
 b=ZXxnp6t/YxDRquY4idTdiS24BWvX4DF5YPcc6KNNEkK453VbDTHvTlpU/Vm7mNYAYKF2mOVtaZVcbThb0d2T7QMOl51xpmxqdF4uMi4n6DfKpSkIRNUwSK5kxBAiMBUD2LPvsflXoVIW40b6pg4gQpIC+kt15uReGNQkL9SQqv8=
In-Reply-To: <CAMkAt6oX+18cZy_t3hm0zo-sLmTGeGs5H9YAWvj7WBU7_uwU5Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Gonda <pgonda-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, "Singh, Brijesh" <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, "Grimm, Jon" <jon.grimm-5C7GfCeVMHo@public.gmane.org>, eric.vantassell-5C7GfCeVMHo@public.gmane.org, Matt Gingell <gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kvm list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/1/20 1:08 PM, Peter Gonda wrote:
> On Thu, Sep 24, 2020 at 1:55 PM Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org> wrote:
>>
>> On 9/24/20 2:21 PM, Sean Christopherson wrote:
>>> On Tue, Sep 22, 2020 at 02:14:04PM -0700, Vipin Sharma wrote:
>>>> On Mon, Sep 21, 2020 at 06:48:38PM -0700, Sean Christopherson wrote:
>>>>> On Mon, Sep 21, 2020 at 05:40:22PM -0700, Vipin Sharma wrote:
>>>>>> Hello,
>>>>>>
>>>>>> This patch series adds a new SEV controller for tracking and limiting
>>>>>> the usage of SEV ASIDs on the AMD SVM platform.
>>>>>>
>>>>>> SEV ASIDs are used in creating encrypted VM and lightweight sandboxes
>>>>>> but this resource is in very limited quantity on a host.
>>>>>>
>>>>>> This limited quantity creates issues like SEV ASID starvation and
>>>>>> unoptimized scheduling in the cloud infrastructure.
>>>>>>
>>>>>> SEV controller provides SEV ASID tracking and resource control
>>>>>> mechanisms.
>>>>>
>>>>> This should be genericized to not be SEV specific.  TDX has a similar
>>>>> scarcity issue in the form of key IDs, which IIUC are analogous to SEV ASIDs
>>>>> (gave myself a quick crash course on SEV ASIDs).  Functionally, I doubt it
>>>>> would change anything, I think it'd just be a bunch of renaming.  The hardest
>>>>> part would probably be figuring out a name :-).
>>>>>
>>>>> Another idea would be to go even more generic and implement a KVM cgroup
>>>>> that accounts the number of VMs of a particular type, e.g. legacy, SEV,
>>>>> SEV-ES?, and TDX.  That has potential future problems though as it falls
>>>>> apart if hardware every supports 1:MANY VMs:KEYS, or if there is a need to
>>>>> account keys outside of KVM, e.g. if MKTME for non-KVM cases ever sees the
>>>>> light of day.
>>>>
>>>> I read about the TDX and its use of the KeyID for encrypting VMs. TDX
>>>> has two kinds of KeyIDs private and shared.
>>>
>>> To clarify, "shared" KeyIDs are simply legacy MKTME KeyIDs.  This is relevant
>>> because those KeyIDs can be used without TDX or KVM in the picture.
>>>
>>>> On AMD platform there are two types of ASIDs for encryption.
>>>> 1. SEV ASID - Normal runtime guest memory encryption.
>>>> 2. SEV-ES ASID - Extends SEV ASID by adding register state encryption with
>>>>                integrity.
>>>>
>>>> Both types of ASIDs have their own maximum value which is provisioned in
>>>> the firmware
>>>
>>> Ugh, I missed that detail in the SEV-ES RFC.  Does SNP add another ASID type,
>>> or does it reuse SEV-ES ASIDs?  If it does add another type, is that trend
>>> expected to continue, i.e. will SEV end up with SEV, SEV-ES, SEV-ES-SNP,
>>> SEV-ES-SNP-X, SEV-ES-SNP-X-Y, etc...?
>>
>> SEV-SNP and SEV-ES share the same ASID range.
> 
> Where is this documented? From the SEV-SNP FW ABI Spec 0.8 "The
> firmware checks that ASID is an encryption capable ASID. If not, the
> firmware returns INVALID_ASID." that doesn't seem clear that an SEV-ES
> ASID is required. Should this document be more clear?

I let the owner of the spec know and it will be updated.

Thanks,
Tom

> 
