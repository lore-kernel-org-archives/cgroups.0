From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Tue, 19 Jan 2021 23:13:51 -0800
Message-ID: <YAfYL7V6E4/P83Mg@google.com>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TTV6nYqcO5XSWys9zWm8wnK0Pv6PThaQer4+oGm8NGU=;
        b=HIc1eaI5kMbParlqoxUe710DEIElJcljsyDbh1ppcnKJbXKV202dwYfKtT37vYEsJd
         Igzd1+h2pYuRhJQincqk99FJ7Oi0Wm9IdIVFJ++zyiGx10XzKtS66jPCa7AxoVZejV2c
         hURdb8ummwjbEbDuaQonFCLiiarN8aM8f0PmyI6fka/dVXK6rZWjpLBAs6H340vKVaCM
         k7zNarmhmjrPX/jP+fmDQnR71WNX7fB8drCbiPH45F+dbEWVt+u6DIFOwR0CzZtXFah6
         5gHgWAQ0EhY5hXY/+S3ovR79cyKl37oyqvG6K/KYsz8LzYyDSEyhL3ZxSK3FAohzXA2j
         mG9g==
Content-Disposition: inline
In-Reply-To: <YAb//EYCkZ7wnl6D-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: thomas.lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 19, 2021 at 10:51:24AM -0500, Tejun Heo wrote:
> Hello,
> 
> On Fri, Jan 15, 2021 at 08:32:19PM -0800, Vipin Sharma wrote:
> > SEV-ES has stronger memory encryption gurantees compared to SEV, apart
> > from encrypting the application memory it also encrypts register state
> > among other things. In a single host ASIDs can be distributed between
> > these two types by BIOS settings.
> > 
> > Currently, Google Cloud has Confidential VM machines offering using SEV.
> > ASIDs are not compatible between SEV and SEV-ES, so a VM running on SEV
> > cannot run on SEV-ES and vice versa
> > 
> > There are use cases for both types of VMs getting used in future.
> 
> Can you please elaborate? I skimmed through the amd manual and it seemed to
> say that SEV-ES ASIDs are superset of SEV but !SEV-ES ASIDs. What's the use
> case for mixing those two?

For example, customers can be given options for which kind of protection they
want to choose for their workloads based on factors like data protection
requirement, cost, speed, etc.

In terms of features SEV-ES is superset of SEV but that doesn't mean SEV
ASIDs are superset of SEV ASIDs. SEV ASIDs cannot be used for SEV-ES VMs
and similarly SEV-ES ASIDs cannot be used for SEV VMs. Once a system is
booted, based on the BIOS settings each type will have their own
capacity and that number cannot be changed until the next boot and BIOS
changes.

We are not mixing the two types of ASIDs, they are separate and used
separately.

> 
> > > > > > Other ID types can be easily added in the controller in the same way.
> > > > > 
> > > > > I'm not sure this is necessarily a good thing.
> > > > 
> > > > This is to just say that when Intel and PowerPC changes are ready it
> > > > won't be difficult for them to add their controller.
> > > 
> > > I'm not really enthused about having per-hardware-type control knobs. None
> > > of other controllers behave that way. Unless it can be abstracted into
> > > something common, I'm likely to object.
> > 
> > There was a discussion in Patch v1 and consensus was to have individual
> > files because it makes kernel implementation extremely simple.
> > 
> > https://lore.kernel.org/lkml/alpine.DEB.2.23.453.2011131615510.333518-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org/#t
> 
> I'm very reluctant to ack vendor specific interfaces for a few reasons but
> most importantly because they usually indicate abstraction and/or the
> underlying feature not being sufficiently developed and they tend to become
> baggages after a while. So, here are my suggestions:

My first patch was only for SEV, but soon we got comments that this can
be abstracted and used by TDX and SEID for their use cases.

I see this patch as providing an abstraction for simple accounting of
resources used for creating secure execution contexts. Here, secure
execution is achieved through different means. SEID, TDX, and SEV
provide security using different features and capabilities. I am not
sure if we will reach a point where all three and other vendors will use
the same approach and technology for this purpose.

Instead of each one coming up with their own resource tracking for their
features, this patch is providing a common framework and cgroup for
tracking these resources.

> 
> * If there can be a shared abstraction which hopefully makes intuitive
>   sense, that'd be ideal. It doesn't have to be one knob but it shouldn't be
>   something arbitrary to specific vendors.

I think we should see these as features provided on a host. Tasks can
be executed securely on a host with the guarantees provided by the
specific feature (SEV, SEV-ES, TDX, SEID) used by the task.

I don't think each H/W vendor can agree to a common set of security
guarantees and approach.

> 
> * If we aren't there yet and vendor-specific interface is a must, attach
>   that part to an interface which is already vendor-aware.
Sorry, I don't understand this approach. Can you please give more
details about it?

Thanks
Vipin
