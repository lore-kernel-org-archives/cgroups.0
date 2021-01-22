From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Thu, 21 Jan 2021 16:09:22 -0800
Message-ID: <YAoXsluM+J9ICy99@google.com>
References: <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <YAi6RcbxTSMmNssw@google.com>
 <YAi9qNqiBjGvXMoI@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5B43/qTnJag/KIuHZ95pu4xZZ/OP+ZGwvSqErVBVefQ=;
        b=QPjyDabZlAqIUgik+G/LpiVQmoi31M4CpAZoE2IA6GPPirbHjXtU7aKqvxbLBidRmA
         X8uNXVrpHa3HmQZyYcFrK/DCD4va75v9VXF8Z+iakiKkBkW8utaus/QNohUtlnoB7CqM
         X9y9wErEa6Krei2ahz3jgJ2I4KZtueLITUWcE62XKDK6rQ72GLHzIXgfAsXbrBJx6jdC
         4RBtQtvMVXM07Ax+1Cq0xOT7+ijzCi1PiQF9Z/FeLuACVRh1MjEfm513NELriKgFLIzh
         i0sz16Pn/3b18CZk+oBe+VBpdTGKsS5dUzWtJUldptfuB1fPjchyCfRwm2o2r+s7fOHo
         KZxg==
Content-Disposition: inline
In-Reply-To: <YAi9qNqiBjGvXMoI@mtj.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jan 20, 2021 at 06:32:56PM -0500, Tejun Heo wrote:
> I don't know how many times I have to repeat the same point to get it
> across. For any question about actual abstraction, you haven't provided any
> kind of actual research or analysis and just keep pushing the same thing
> over and over again. Maybe the situation is such that it makes sense to
> change the rule but that needs substantial justifications. I've been asking
> to see whether there are such justifications but all I've been getting are
> empty answers. Until such discussions take place, please consider the series
> nacked and please excuse if I don't respond promptly in this thread.

I am sorry Tejun that you felt your feedback and questions are being ignored
or not answered properly by me. It was not my intent. Let me try again.

I am not able to come up with an abstraction for underlying the hardware
like we have for memory, cpu, and io with their respective cgroup
controllers, because each vendor is solving VM security issue in
different ways. For example:

s390 is using Ultravisor (UV) to disable access to the VMs memory from
the host.  All KVM interaction with their Protected Virtual Machines
(PVM) are handled through UV APIs. Here an encrypted guest image is
loaded first which is decrypted by UV and then UV disallows access to
PVMs memory and register state from KVM or other PVMs. PVMs are assigned
IDs known as secure execution IDs (SEID).  These IDs are not scarce
resource on the host.

AMD is encrypting runtime memory of a VM using an hardware AES engine in
the memory controller and keys are managed by an Arm based coprocessor
inside the CPU, for encryption and decryption of the data flow between
CPU and memory.  Their offering is known as Secure Encrypted
Virtualization (SEV). There are also two more enhanced offerings SEV-ES,
(memory + guest register state encryption), SEV-SNP (SEV-ES + memory
integrity protection + TCB rollback) in later generation of CPUs. At any
time only a limited number of IDs can be used simultaneously in the
processor. Initially only SEV IDs we available on the CPUs but in the
later generations of CPUs with the addition of SEV-ES, IDs were divided
in two groups SEV ASIDs for SEV guests, and SEV-ES ASIDs for SEV-ES and
SEV-SNP VMs. SEV firmware doesn't allow SEV ASIDs to launch SEV-ES and
SEV-SNP VMs. Ideally, I think its better to use SEV-SNP as it provides
highest protection but support in vmm and guest kernels are not there
yet. Also, old HW will not be able to run SEV-ES or SEV-SNP as they can
only run SEV ASIDs. I dont have data in terms of drawbacks running VM on
SEV-SNP in terms of speed and cost but I think it will be dependent on
workloads.

Intel has come up with Trusted Domain Extension (TDX) for their secure
VMs offering. They allow a VM to use multiple keys for private pages and
for pages shared with other VMs. Overall, this is called as Multi-Key
Total Memory Encryption (MKTME). A fixed number of encryption keys are
supported in MKTME engine. During execution these keys are identified
using KeyIDs which are present in upper bits of platform physical
addresses.

Only limited form of abstraction present here is that all are providing
a way to have secure VMs and processes, either through single key
encryption, multiple key encryptions or access denial.

A common abstraction of different underlying security behavior/approach
can mislead users in giving impression that all secure VMs/processes are
same. In my opinion, this kind of thing can work when we talk about
memory, cpu, etc, but for security related stuff will do more harm to
the end user than the benefit of simplicity of abstraction. The name of
the underlying feature also tells what kind of security guarantees a
user can expect on the platform for a VM and what kind is used.

Taking a step back, in the current scenario, we have some global shared
resources which are limited for SEV, SEV-ES, and TDX. There is also a
need for tracking and controlling on all 4 features for now. This is a
case for some kind of cgroup behavior to limit and control an aggregate
of processes using these system resources. After all, "cgroup is a
mechanism to organize processes hierarchically and distribute system
resources along the hierarchy in a controlled and configurable manner."

We are using SEV in KVM and outside KVM also for other products on
horizon. As cgroups are commonly used in many infrastructures for
resource control, scheduling, and tracking, this patch is helping us in
allocating jobs in the infrastructure along with memory, cpu and other
constraints in a coherent way.

If you feel encryption id cgroup is not good for long term or a
too specific use case then may be there should be a common cgroup which
can be a home for this kind and other kind of future resources where
there is need to limit a global resource allocation but are not abstract
or cannot be abstracted as the other existing cgroups. My current patch
is very generic and with few modifications, it can provide subsystems,
having valid requirements, a capability to use their own simple cgroup
interfaces with minimal code duplication and get robustness of generic
cgroup for free. Here, SEV will be the first user of this generic
cgroup. Need for this is clearly there.

Thanks Vipin
