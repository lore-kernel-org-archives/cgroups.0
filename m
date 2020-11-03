From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC Patch 1/2] KVM: SVM: Create SEV cgroup controller.
Date: Tue, 03 Nov 2020 08:39:12 -0800
Message-ID: <c0ee04a93a8d679f5e9ee7eea6467b32bb7063d6.camel@HansenPartnership.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
         <20200922004024.3699923-2-vipinsh@google.com>
         <94c3407d-07ca-8eaf-4073-4a5e2a3fb7b8@infradead.org>
         <20200922012227.GA26483@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1604421554;
        bh=HGUTyhqFV7T0x144FbiJ+dIW4PRgOPfbbL2emrIeZSI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=JV5wydhVcXN14b9so+1nEsuOqf/5654vfvCb3lKpcdvyNBGgNCjRZKR10SdqBr0zJ
         ZWHyYISVZXNaOIX7U/vHlBX3vhZn1ppqUUUAemdXH7gs1LjXrGnB4mcr1mhjCIX2BQ
         xIdn8A920w3BZhKsFhf9SsMnD1NHOkCYO8XZe3os=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1604421554;
        bh=HGUTyhqFV7T0x144FbiJ+dIW4PRgOPfbbL2emrIeZSI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=JV5wydhVcXN14b9so+1nEsuOqf/5654vfvCb3lKpcdvyNBGgNCjRZKR10SdqBr0zJ
         ZWHyYISVZXNaOIX7U/vHlBX3vhZn1ppqUUUAemdXH7gs1LjXrGnB4mcr1mhjCIX2BQ
         xIdn8A920w3BZhKsFhf9SsMnD1NHOkCYO8XZe3os=
In-Reply-To: <20200922012227.GA26483@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sean Christopherson <sean.j.christopherson@intel.com>, Randy Dunlap <rdunlap@infradead.org>
Cc: Vipin Sharma <vipinsh@google.com>, thomas.lendacky@amd.com, pbonzini@redhat.com, tj@kernel.org, lizefan@huawei.com, joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com, rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Dionna Glaze <dionnaglaze@google.com>, Erdem Aktas <erdemaktas@google.com>

On Mon, 2020-09-21 at 18:22 -0700, Sean Christopherson wrote:
> On Mon, Sep 21, 2020 at 06:04:04PM -0700, Randy Dunlap wrote:
> > Hi,
> > 
> > On 9/21/20 5:40 PM, Vipin Sharma wrote:
> > > diff --git a/init/Kconfig b/init/Kconfig
> > > index d6a0b31b13dc..1a57c362b803 100644
> > > --- a/init/Kconfig
> > > +++ b/init/Kconfig
> > > @@ -1101,6 +1101,20 @@ config CGROUP_BPF
> > >  	  BPF_CGROUP_INET_INGRESS will be executed on the ingress path
> > > of
> > >  	  inet sockets.
> > >  
> > > +config CGROUP_SEV
> > > +	bool "SEV ASID controller"
> > > +	depends on KVM_AMD_SEV
> > > +	default n
> > > +	help
> > > +	  Provides a controller for AMD SEV ASIDs. This controller
> > > limits and
> > > +	  shows the total usage of SEV ASIDs used in encrypted VMs on
> > > AMD
> > > +	  processors. Whenever a new encrypted VM is created using SEV
> > > on an
> > > +	  AMD processor, this controller will check the current limit
> > > in the
> > > +	  cgroup to which the task belongs and will deny the SEV ASID
> > > if the
> > > +	  cgroup has already reached its limit.
> > > +
> > > +	  Say N if unsure.
> > 
> > Something here (either in the bool prompt string or the help text)
> > should let a reader know w.t.h. SEV means.
> > 
> > Without having to look in other places...
> 
> ASIDs too.  I'd also love to see more info in the docs and/or cover
> letter to explain why ASID management on SEV requires a cgroup.  I
> know what an ASID is, and have a decent idea of how KVM manages ASIDs
> for legacy VMs, but I know nothing about why ASIDs are limited for
> SEV and not legacy VMs.

Well, also, why would we only have a cgroup for ASIDs but not MSIDs?

For the reader at home a Space ID (SID) is simply a tag that can be
placed on a cache line to control things like flushing.  Intel and AMD
use MSIDs which are allocated per process to allow fast context
switching by flushing all the process pages using a flush by SID. 
ASIDs are also used by both Intel and AMD to control nested/extended
paging of virtual machines, so ASIDs are allocated per VM.  So far it's
universal.

AMD invented a mechanism for tying their memory encryption technology
to the ASID asserted on the memory bus, so now they can do encrypted
virtual machines since each VM is tagged by ASID which the memory
encryptor sees.  It is suspected that the forthcoming intel TDX
technology to encrypt VMs will operate in the same way as well.  This
isn't everything you have to do to get an encrypted VM, but it's a core
part of it.

The problem with SIDs (both A and M) is that they get crammed into
spare bits in the CPU (like the upper bits of %CR3 for MSID) so we
don't have enough of them to do a 1:1 mapping of MSID to process or
ASID to VM.  Thus we have to ration them somewhat, which is what I
assume this patch is about?

James


