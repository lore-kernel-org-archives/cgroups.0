From: Tejun Heo <tj@kernel.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Wed, 20 Jan 2021 18:32:56 -0500
Message-ID: <YAi9qNqiBjGvXMoI@mtj.duckdns.org>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <YAi6RcbxTSMmNssw@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kuz1Z8yFOKqntoZqWEZMArKOxWgkIyDqBbny1W4ic1M=;
        b=HJlmkRDv2hPtYnuU5c270k+st/MAdNAqkEg/D9vHyvSK9kKH73Zjbctd7WVUKy6247
         HkQxh4CdcW2DT9yAgApoSW5PpLB4pjrOWlxx/EKsDvpOSfDC7qReqn950tJtAfAKWOzy
         KA/8CQvR6JfJrhPQtE9guNZttGprU+hbN4YyyaoiGtAJndqmJysGXPVyXyruoUDqLtL3
         omGUe1oEcvwiIpLmBTJek7bTA7w2yT27u25onP7lsCxZK46SQNs+JCLRKlf+mq2gGetG
         vydZ2LO27zn5lX+JaxD0f4njHfv2cQboM6Ync9BZTAbzNbGoWTk3d4aqmwS8isJMaTDe
         Hmnw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YAi6RcbxTSMmNssw@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh@google.com>
Cc: thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 20, 2021 at 03:18:29PM -0800, Vipin Sharma wrote:
> RDMA cgroup expose hardware details to users. In rdma.{max, current}
> interface files we can see actual hardware names. Only difference

No, what's shown is the device name followed by resources which are commonly
defined for all rdma devices. The format is the same as io controller
interface files.

> compared to Encryption ID cgroup is that latter is exposing that detail
> via file names.
> 
> Will you prefer that encryption ID cgroup do things similar to RDMA
> cgroup? It can have 3 files

I don't know how many times I have to repeat the same point to get it
across. For any question about actual abstraction, you haven't provided any
kind of actual research or analysis and just keep pushing the same thing
over and over again. Maybe the situation is such that it makes sense to
change the rule but that needs substantial justifications. I've been asking
to see whether there are such justifications but all I've been getting are
empty answers. Until such discussions take place, please consider the series
nacked and please excuse if I don't respond promptly in this thread.

> > Attaching the interface to kvm side, most likely, instead of exposing the
> > feature through cgroup.
> I am little confused, do you mean moving files from the kernel/cgroup/
> to kvm related directories or you are recommending not to use cgroup at
> all?  I hope it is the former :)
> 
> Only issue with this is that TDX is not limited to KVM, they have
> potential use cases for MKTME without KVM.

There are ways to integrate with cgroup through other interfaces - e.g. take
a look at how bpf works with cgroups. Here, it isn't ideal but may work out
if things actually require a lot of hardware dependent bits. There's also
RDT which exists outside of cgroup for similar reasons.

Thanks.

-- 
tejun
