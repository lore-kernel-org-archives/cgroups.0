From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC Patch 1/2] KVM: SVM: Create SEV cgroup controller.
Date: Mon, 21 Sep 2020 18:22:28 -0700
Message-ID: <20200922012227.GA26483@linux.intel.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922004024.3699923-2-vipinsh@google.com>
 <94c3407d-07ca-8eaf-4073-4a5e2a3fb7b8@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94c3407d-07ca-8eaf-4073-4a5e2a3fb7b8@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Vipin Sharma <vipinsh@google.com>, thomas.lendacky@amd.com, pbonzini@redhat.com, tj@kernel.org, lizefan@huawei.com, joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com, rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Dionna Glaze <dionnaglaze@google.com>, Erdem Aktas <erdemaktas@google.com>

On Mon, Sep 21, 2020 at 06:04:04PM -0700, Randy Dunlap wrote:
> Hi,
> 
> On 9/21/20 5:40 PM, Vipin Sharma wrote:
> > diff --git a/init/Kconfig b/init/Kconfig
> > index d6a0b31b13dc..1a57c362b803 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1101,6 +1101,20 @@ config CGROUP_BPF
> >  	  BPF_CGROUP_INET_INGRESS will be executed on the ingress path of
> >  	  inet sockets.
> >  
> > +config CGROUP_SEV
> > +	bool "SEV ASID controller"
> > +	depends on KVM_AMD_SEV
> > +	default n
> > +	help
> > +	  Provides a controller for AMD SEV ASIDs. This controller limits and
> > +	  shows the total usage of SEV ASIDs used in encrypted VMs on AMD
> > +	  processors. Whenever a new encrypted VM is created using SEV on an
> > +	  AMD processor, this controller will check the current limit in the
> > +	  cgroup to which the task belongs and will deny the SEV ASID if the
> > +	  cgroup has already reached its limit.
> > +
> > +	  Say N if unsure.
> 
> Something here (either in the bool prompt string or the help text) should
> let a reader know w.t.h. SEV means.
> 
> Without having to look in other places...

ASIDs too.  I'd also love to see more info in the docs and/or cover letter
to explain why ASID management on SEV requires a cgroup.  I know what an
ASID is, and have a decent idea of how KVM manages ASIDs for legacy VMs, but
I know nothing about why ASIDs are limited for SEV and not legacy VMs.
