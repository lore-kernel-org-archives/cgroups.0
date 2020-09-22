From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Date: Tue, 22 Sep 2020 14:14:04 -0700
Message-ID: <20200922211404.GA4141897@google.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922014836.GA26507@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jX0oqiM8ZRWUr1y81TApDh2RLCO5qMFygk0a8MYzzVI=;
        b=B1hYCzRIzXGxf476oO1RyhjC26uBYCDdckWaQTm5Z1XUjvlWEEJN1luX8NvRRESzqy
         uI37IR6+6MX61y1oGcN8An610Ee2QYGs6VGNllKq9m+zlneUHDzy3UsAGGBHv9DE1E1D
         qT8GQM4UVAesCA8kLMpRrA9ZeI4cfw8eGjxYKtyE0yjY59irZXh2Dfmz9OjumiYUu/qm
         yHTO7ctPRUbZ9EigdnrWAIXnwvosn5CW58fpf0+coea0060UfoW1dsYi0nQkVmy0O4VO
         g81iae2/630fno3kknm7E/zhJn0XhCUt3WhKQcA0ckIX/ElhyihqNT81SRkD23FlxBLs
         OQcQ==
Content-Disposition: inline
In-Reply-To: <20200922014836.GA26507-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: thomas.lendacky-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Sep 21, 2020 at 06:48:38PM -0700, Sean Christopherson wrote:
> On Mon, Sep 21, 2020 at 05:40:22PM -0700, Vipin Sharma wrote:
> > Hello,
> > 
> > This patch series adds a new SEV controller for tracking and limiting
> > the usage of SEV ASIDs on the AMD SVM platform.
> > 
> > SEV ASIDs are used in creating encrypted VM and lightweight sandboxes
> > but this resource is in very limited quantity on a host.
> > 
> > This limited quantity creates issues like SEV ASID starvation and
> > unoptimized scheduling in the cloud infrastructure.
> > 
> > SEV controller provides SEV ASID tracking and resource control
> > mechanisms.
> 
> This should be genericized to not be SEV specific.  TDX has a similar
> scarcity issue in the form of key IDs, which IIUC are analogous to SEV ASIDs
> (gave myself a quick crash course on SEV ASIDs).  Functionally, I doubt it
> would change anything, I think it'd just be a bunch of renaming.  The hardest
> part would probably be figuring out a name :-).
> 
> Another idea would be to go even more generic and implement a KVM cgroup
> that accounts the number of VMs of a particular type, e.g. legacy, SEV,
> SEV-ES?, and TDX.  That has potential future problems though as it falls
> apart if hardware every supports 1:MANY VMs:KEYS, or if there is a need to
> account keys outside of KVM, e.g. if MKTME for non-KVM cases ever sees the
> light of day.

I read about the TDX and its use of the KeyID for encrypting VMs. TDX
has two kinds of KeyIDs private and shared.

On AMD platform there are two types of ASIDs for encryption.
1. SEV ASID - Normal runtime guest memory encryption.
2. SEV-ES ASID - Extends SEV ASID by adding register state encryption with
		 integrity.

Both types of ASIDs have their own maximum value which is provisioned in
the firmware

So, we are talking about 4 different types of resources:
1. AMD SEV ASID (implemented in this patch as sev.* files in SEV cgroup)
2. AMD SEV-ES ASID (in future, adding files like sev_es.*)
3. Intel TDX private KeyID
4. Intel TDX shared KeyID

TDX private KeyID is similar to SEV and SEV-ES ASID. I think coming up
with the same name which can be used by both platforms will not be easy,
and extensible with the future enhancements. This will get even more
difficult if Arm also comes up with something similar but with different
nuances.

I like the idea of the KVM cgroup and when it is mounted it will have
different files based on the hardware platform.

1. KVM cgroup on AMD will have:
sev.max & sev.current.
sev_es.max & sev_es.current.

2. KVM cgroup mounted on Intel:
tdx_private_keys.max
tdx_shared_keys.max

The KVM cgroup can be used to have control files which are generic (no
use case in my mind right now) and hardware platform specific files
also.
