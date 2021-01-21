From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Thu, 21 Jan 2021 17:12:43 -0600
Message-ID: <d11e58ec-4a8f-5b31-063a-b6b45d4ccdc5@amd.com>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org> <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org> <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org> <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
 <YAmj4Q2J9htW2Fe8@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRL+bWJIrTrWSrEYx1+Z2WnEMk8WsuvuMDKRoMfxr2k=;
 b=ryLevIEdsa22F/Q6QUWObXT6V9dLrTqUgK2gwhW6PZJw+jnSLShvtlNUxNKQyay55++B+/S97rKedxvCDnsfxoVG9wd4s9QS2nlN81UUwNlfMppNViNLzDiw64vvhCyX4Q8dHbo0/K0JMPudpOB0MJUTWJYaaJIREGy9x6cQca4=
In-Reply-To: <YAmj4Q2J9htW2Fe8-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 1/21/21 9:55 AM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jan 21, 2021 at 08:55:07AM -0600, Tom Lendacky wrote:
>> The hardware will allow any SEV capable ASID to be run as SEV-ES, however,
>> the SEV firmware will not allow the activation of an SEV-ES VM to be
>> assigned to an ASID greater than or equal to the SEV minimum ASID value. The
>> reason for the latter is to prevent an !SEV-ES ASID starting out as an
>> SEV-ES guest and then disabling the SEV-ES VMCB bit that is used by VMRUN.
>> This would result in the downgrading of the security of the VM without the
>> VM realizing it.
>>
>> As a result, you have a range of ASIDs that can only run SEV-ES VMs and a
>> range of ASIDs that can only run SEV VMs.
> 
> I see. That makes sense. What's the downside of SEV-ES compared to SEV w/o
> ES? Are there noticeable performance / feature penalties or is the split
> mostly for backward compatibility?

SEV-ES is an incremental enhancement of SEV where the register state of 
the guest is protected/encrypted. As with a lot of performance questions, 
the answer is ...it depends. With SEV-ES, there is additional overhead 
associated with a world switch (VMRUN/VMEXIT) to restore and save 
additional register state. Also, exit events are now divided up into 
automatic exits (AE) and non-automatic exits (NAE). NAE events result in a 
new #VC exception being generated where the guest is then required to use 
the VMGEXIT instruction to communicate only the state necessary to perform 
the operation. A CPUID instruction is a good example, where a shared page 
is used to communicate required state to the hypervisor to perform the 
CPUID emulation, which then returns the results back through the shared 
page to the guest. So it all depends on how often the workload in question 
performs operations that result in a VMEXIT of the vCPU, etc.

Thanks,
Tom

> 
> Thanks.
> 
