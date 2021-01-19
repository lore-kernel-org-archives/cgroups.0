From: Tejun Heo <tj@kernel.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Tue, 19 Jan 2021 10:51:24 -0500
Message-ID: <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QcyMDDVr7CULOAn4Y79GHadhfUa6Q0T6oHNJlZ8GjWw=;
        b=Yer91Bx8c4Zuf1jc7YE1BhjV1iCXJqwpcbRE/LVgACcNIm3xYd/qExI++Vi5WEHKWn
         h4Q3B9iNjHGBstOD7f7waSofR3i2l0oNGDU9laQHLyX+/zYYktlFoV0ZTe7fjLqqo7fd
         sIiq82ij96CVIZIpR+mIPzExMbuBALZCMme1Nrmb0DboFYLMIBQLK05OPJO+ZyqTc05a
         daKfvHLmry82KJR9/iqFcLQOQFZLGjLOmSspQyJ7tY0LKKjX5aiZ107DAR/NlIGF3PiX
         XfTgFPaVwKS6MVwb49o+BNhXvKTxY4pd+TrVD35ssENsLzTINILsfmIxnI6Y8se5xAeu
         vmQg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YAJsUyH2zspZxF2S@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh@google.com>
Cc: thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 15, 2021 at 08:32:19PM -0800, Vipin Sharma wrote:
> SEV-ES has stronger memory encryption gurantees compared to SEV, apart
> from encrypting the application memory it also encrypts register state
> among other things. In a single host ASIDs can be distributed between
> these two types by BIOS settings.
> 
> Currently, Google Cloud has Confidential VM machines offering using SEV.
> ASIDs are not compatible between SEV and SEV-ES, so a VM running on SEV
> cannot run on SEV-ES and vice versa
> 
> There are use cases for both types of VMs getting used in future.

Can you please elaborate? I skimmed through the amd manual and it seemed to
say that SEV-ES ASIDs are superset of SEV but !SEV-ES ASIDs. What's the use
case for mixing those two?

> > > > > Other ID types can be easily added in the controller in the same way.
> > > > 
> > > > I'm not sure this is necessarily a good thing.
> > > 
> > > This is to just say that when Intel and PowerPC changes are ready it
> > > won't be difficult for them to add their controller.
> > 
> > I'm not really enthused about having per-hardware-type control knobs. None
> > of other controllers behave that way. Unless it can be abstracted into
> > something common, I'm likely to object.
> 
> There was a discussion in Patch v1 and consensus was to have individual
> files because it makes kernel implementation extremely simple.
> 
> https://lore.kernel.org/lkml/alpine.DEB.2.23.453.2011131615510.333518@chino.kir.corp.google.com/#t

I'm very reluctant to ack vendor specific interfaces for a few reasons but
most importantly because they usually indicate abstraction and/or the
underlying feature not being sufficiently developed and they tend to become
baggages after a while. So, here are my suggestions:

* If there can be a shared abstraction which hopefully makes intuitive
  sense, that'd be ideal. It doesn't have to be one knob but it shouldn't be
  something arbitrary to specific vendors.

* If we aren't there yet and vendor-specific interface is a must, attach
  that part to an interface which is already vendor-aware.

> This information is not available anywhere else in the system. Only
> other way to get this value is to use CPUID instruction (0x8000001F) of
> the processor. Which also has disdvantage if sev module in kernel
> doesn't use all of the available ASIDs for its work (right now it uses
> all) then there will be a mismatch between what user get through their
> code and what is actually getting used in the kernel by sev.
> 
> In cgroup v2, I didn't see current files for other cgroups in root
> folder that is why I didn't show that file in root folder.
> 
> Will you be fine if I show two files in the root, something like:
> 
> encids.sev.capacity
> encids.sev.current
> 
> In non root folder, it will be:
> encids.sev.max
> encids.sev.current
> 
> I still prefer encids.sev.stat, as it won't repeat same information in
> each cgroup but let me know what you think.

Yeah, this will be a first and I was mostly wondering about the same number
appearing under different files / names on root and !root cgroups. I'm
leaning more towards capacity/current but let me think about it a bit more.

Thank you.

-- 
tejun
