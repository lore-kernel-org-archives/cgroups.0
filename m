From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Thu, 21 Jan 2021 08:55:07 -0600
Message-ID: <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org> <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org> <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org> <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WPCFin+KBqWX0/DLdvou3LUlcQ9/2RoWQ1Gp+5oQ6M=;
 b=ULHrPxxjMzUWdACcYaQBsZy6dXDqI8I/LuDUK7lnVTUHGBLmyuIWFvj1VTmyyt++r8YBYomQcn7OSHe9k3eECN4Dpqsr+O2PHMs5c2XXtsAuK+A5NMf8JKkQUPXuvm8uDwxCSSLeIfPqi1HK/gq0CSVyCLb1rg2LXGYRKSqZfa8=
In-Reply-To: <YAhc8khTUc2AFDcd-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 1/20/21 10:40 AM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 19, 2021 at 11:13:51PM -0800, Vipin Sharma wrote:
>>> Can you please elaborate? I skimmed through the amd manual and it seemed to
>>> say that SEV-ES ASIDs are superset of SEV but !SEV-ES ASIDs. What's the use
>>> case for mixing those two?
>>
>> For example, customers can be given options for which kind of protection they
>> want to choose for their workloads based on factors like data protection
>> requirement, cost, speed, etc.
> 
> So, I'm looking for is a bit more in-depth analysis than that. ie. What's
> the downside of SEV && !SEV-ES and is the disticntion something inherently
> useful?
> 
>> In terms of features SEV-ES is superset of SEV but that doesn't mean SEV
>> ASIDs are superset of SEV ASIDs. SEV ASIDs cannot be used for SEV-ES VMs
>> and similarly SEV-ES ASIDs cannot be used for SEV VMs. Once a system is
>> booted, based on the BIOS settings each type will have their own
>> capacity and that number cannot be changed until the next boot and BIOS
>> changes.
> 
> Here's an excerpt from the AMD's system programming manual, section 15.35.2:
> 
>    On some systems, there is a limitation on which ASID values can be used on
>    SEV guests that are run with SEV-ES disabled. While SEV-ES may be enabled
>    on any valid SEV ASID (as defined by CPUID Fn8000_001F[ECX]), there are
>    restrictions on which ASIDs may be used for SEV guests with SEV- ES
>    disabled. CPUID Fn8000_001F[EDX] indicates the minimum ASID value that
>    must be used for an SEV-enabled, SEV-ES-disabled guest. For example, if
>    CPUID Fn8000_001F[EDX] returns the value 5, then any VMs which use ASIDs
>    1-4 and which enable SEV must also enable SEV-ES.

The hardware will allow any SEV capable ASID to be run as SEV-ES, however, 
the SEV firmware will not allow the activation of an SEV-ES VM to be 
assigned to an ASID greater than or equal to the SEV minimum ASID value. 
The reason for the latter is to prevent an !SEV-ES ASID starting out as an 
SEV-ES guest and then disabling the SEV-ES VMCB bit that is used by VMRUN. 
This would result in the downgrading of the security of the VM without the 
VM realizing it.

As a result, you have a range of ASIDs that can only run SEV-ES VMs and a 
range of ASIDs that can only run SEV VMs.

Thanks,
Tom

> 
>> We are not mixing the two types of ASIDs, they are separate and used
>> separately.
> 
> Maybe in practice, the key management on the BIOS side is implemented in a
> more restricted way but at least the processor manual says differently.
> 
>>> I'm very reluctant to ack vendor specific interfaces for a few reasons but
>>> most importantly because they usually indicate abstraction and/or the
>>> underlying feature not being sufficiently developed and they tend to become
>>> baggages after a while. So, here are my suggestions:
>>
>> My first patch was only for SEV, but soon we got comments that this can
>> be abstracted and used by TDX and SEID for their use cases.
>>
>> I see this patch as providing an abstraction for simple accounting of
>> resources used for creating secure execution contexts. Here, secure
>> execution is achieved through different means. SEID, TDX, and SEV
>> provide security using different features and capabilities. I am not
>> sure if we will reach a point where all three and other vendors will use
>> the same approach and technology for this purpose.
>>
>> Instead of each one coming up with their own resource tracking for their
>> features, this patch is providing a common framework and cgroup for
>> tracking these resources.
> 
> What's implemented is a shared place where similar things can be thrown in
> bu from user's perspective the underlying hardware feature isn't really
> abstracted. It's just exposing whatever hardware knobs there are. If you
> look at any other cgroup controllers, nothing is exposing this level of
> hardware dependent details and I'd really like to keep it that way.
> 
> So, what I'm asking for is more in-depth analysis of the landscape and
> inherent differences among different vendor implementations to see whether
> there can be better approaches or we should just wait and see.
> 
>>> * If there can be a shared abstraction which hopefully makes intuitive
>>>    sense, that'd be ideal. It doesn't have to be one knob but it shouldn't be
>>>    something arbitrary to specific vendors.
>>
>> I think we should see these as features provided on a host. Tasks can
>> be executed securely on a host with the guarantees provided by the
>> specific feature (SEV, SEV-ES, TDX, SEID) used by the task.
>>
>> I don't think each H/W vendor can agree to a common set of security
>> guarantees and approach.
> 
> Do TDX and SEID have multiple key types tho?
> 
>>> * If we aren't there yet and vendor-specific interface is a must, attach
>>>    that part to an interface which is already vendor-aware.
>> Sorry, I don't understand this approach. Can you please give more
>> details about it?
> 
> Attaching the interface to kvm side, most likely, instead of exposing the
> feature through cgroup.
> 
> Thanks.
> 
