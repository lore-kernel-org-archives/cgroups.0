From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Fri, 15 Jan 2021 20:32:19 -0800
Message-ID: <YAJsUyH2zspZxF2S@google.com>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=78eb91iV6onC6q/hVFxGo4K1XPsW1qS27cVVQW2qr6s=;
        b=AhCJrurJWr5qakhtTFitP0L+ZLAyEUUdfmPca3QpxNzNGFZrZqXzwK7rGFldzEKG/g
         rJg/IJDxekMuO8bfkHTyYr74RzsMadcBKp3YR9g06tgDFSHtXj+chssKalfaIawkjxih
         BRVvlJPQYIvd4KdUAxAhR4o75d35icXrZB/EFP+iGbzySEycNsF4pX+FdJ9wg3SoTuE5
         rFtP8JHAXY+SgOM6dFnjOivvQw+GG6iyCeM1dcpiO6/ytRmGQmhhFtnGXUsk/g7/6di8
         Vd538ChRdWi0U4cRJs4gB1uu7Phm5CVMgdVGwZ8UBewEAtTIVAqqGMDPKErXtfOpnTpg
         SEvw==
Content-Disposition: inline
In-Reply-To: <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 15, 2021 at 10:43:32PM -0500, Tejun Heo wrote:
> On Fri, Jan 15, 2021 at 02:18:40PM -0800, Vipin Sharma wrote:
> > > * Why is .sev a separate namespace? Isn't the controller supposed to cover
> > >   encryption ids across different implementations? It's not like multiple
> > >   types of IDs can be in use on the same machine, right?
> > > 
> > 
> > On AMD platform we have two types SEV and SEV-ES which can exists
> > simultaneously and they have their own quota.
> 
> Can you please give a brief explanation of the two and lay out a scenario
> where the two are being used / allocated disjointly?
> 

SEV-ES has stronger memory encryption gurantees compared to SEV, apart
from encrypting the application memory it also encrypts register state
among other things. In a single host ASIDs can be distributed between
these two types by BIOS settings.

Currently, Google Cloud has Confidential VM machines offering using SEV.
ASIDs are not compatible between SEV and SEV-ES, so a VM running on SEV
cannot run on SEV-ES and vice versa

There are use cases for both types of VMs getting used in future.

> > > > Other ID types can be easily added in the controller in the same way.
> > > 
> > > I'm not sure this is necessarily a good thing.
> > 
> > This is to just say that when Intel and PowerPC changes are ready it
> > won't be difficult for them to add their controller.
> 
> I'm not really enthused about having per-hardware-type control knobs. None
> of other controllers behave that way. Unless it can be abstracted into
> something common, I'm likely to object.

There was a discussion in Patch v1 and consensus was to have individual
files because it makes kernel implementation extremely simple.

https://lore.kernel.org/lkml/alpine.DEB.2.23.453.2011131615510.333518@chino.kir.corp.google.com/#t

> 
> > > > +static int enc_id_cg_stat_show(struct seq_file *sf, void *v)
> > > > +{
> > > > +	unsigned long flags;
> > > > +	enum encryption_id_type type = seq_cft(sf)->private;
> > > > +
> > > > +	spin_lock_irqsave(&enc_id_cg_lock, flags);
> > > > +
> > > > +	seq_printf(sf, "total %u\n", enc_id_capacity[type]);
> > > > +	seq_printf(sf, "used %u\n", root_cg.res[type].usage);
> > > 
> > > Dup with .current and no need to show total on every cgroup, right?
> > 
> > This is for the stat file which will only be seen in the root cgroup
> > directory.  It is to know overall picture for the resource, what is the
> > total capacity and what is the current usage. ".current" file is not
> > shown on the root cgroup.
> 
> Ah, missed the flags. It's odd for the usage to be presented in two
> different ways tho. I think it'd make more sense w/ cgroup.current at root
> level. Is the total number available somewhere else in the system?

This information is not available anywhere else in the system. Only
other way to get this value is to use CPUID instruction (0x8000001F) of
the processor. Which also has disdvantage if sev module in kernel
doesn't use all of the available ASIDs for its work (right now it uses
all) then there will be a mismatch between what user get through their
code and what is actually getting used in the kernel by sev.

In cgroup v2, I didn't see current files for other cgroups in root
folder that is why I didn't show that file in root folder.

Will you be fine if I show two files in the root, something like:

encids.sev.capacity
encids.sev.current

In non root folder, it will be:
encids.sev.max
encids.sev.current

I still prefer encids.sev.stat, as it won't repeat same information in
each cgroup but let me know what you think.

Thanks
