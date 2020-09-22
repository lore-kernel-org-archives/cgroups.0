From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC Patch 1/2] KVM: SVM: Create SEV cgroup controller.
Date: Tue, 22 Sep 2020 09:05:08 -0700
Message-ID: <20200922160508.GA4017872@google.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922004024.3699923-2-vipinsh@google.com>
 <94c3407d-07ca-8eaf-4073-4a5e2a3fb7b8@infradead.org>
 <20200922012227.GA26483@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3cb2ln5okcTwbkZwIHw36/uS8TyOTC34MG+GPkwSrZc=;
        b=ket6MFsKGgeTKg06rAwU3VDAPgvifvWos8wL/PnPWPRsfN8itIg22pijPAXgFiUxD8
         Fd7QHl+cLoi+AojYI/uzZLiSnkiKfZrV0aT1MEDwgG5wUcL5BAy0o6ZN9q6zf5x5EzEe
         +vgACDfDyXI94Lso05jFSaPdPdjsYsl78/DZsmWSL+HdbBnaqlPM35rtfcVt5gLOelRw
         Yo9TEUDsIhXgyB14PuoaFO8HxUGK2iYlLlmUDF49sNxPlVfj/fCxmT+ONyEa9FVYQg8v
         qBO57Zf8p6I4kE7DkzGlQqZdpm45ZncnEFrK0CQkrt73NeKcuVR1Km00Fjp55T7bNcux
         ++6w==
Content-Disposition: inline
In-Reply-To: <20200922012227.GA26483-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dionna Glaze <dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Erdem Aktas <erdemaktas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Sep 21, 2020 at 06:22:28PM -0700, Sean Christopherson wrote:
> On Mon, Sep 21, 2020 at 06:04:04PM -0700, Randy Dunlap wrote:
> > Hi,
> > 
> > On 9/21/20 5:40 PM, Vipin Sharma wrote:
> > > diff --git a/init/Kconfig b/init/Kconfig
> > > index d6a0b31b13dc..1a57c362b803 100644
> > > --- a/init/Kconfig
> > > +++ b/init/Kconfig
> > > @@ -1101,6 +1101,20 @@ config CGROUP_BPF
> > >  	  BPF_CGROUP_INET_INGRESS will be executed on the ingress path of
> > >  	  inet sockets.
> > >  
> > > +config CGROUP_SEV
> > > +	bool "SEV ASID controller"
> > > +	depends on KVM_AMD_SEV
> > > +	default n
> > > +	help
> > > +	  Provides a controller for AMD SEV ASIDs. This controller limits and
> > > +	  shows the total usage of SEV ASIDs used in encrypted VMs on AMD
> > > +	  processors. Whenever a new encrypted VM is created using SEV on an
> > > +	  AMD processor, this controller will check the current limit in the
> > > +	  cgroup to which the task belongs and will deny the SEV ASID if the
> > > +	  cgroup has already reached its limit.
> > > +
> > > +	  Say N if unsure.
> > 
> > Something here (either in the bool prompt string or the help text) should
> > let a reader know w.t.h. SEV means.
> > 
> > Without having to look in other places...
> 
> ASIDs too.  I'd also love to see more info in the docs and/or cover letter
> to explain why ASID management on SEV requires a cgroup.  I know what an
> ASID is, and have a decent idea of how KVM manages ASIDs for legacy VMs, but
> I know nothing about why ASIDs are limited for SEV and not legacy VMs.

Thanks for the feedback, I will add more details in the Kconfig and the
documentation about SEV and ASID.
