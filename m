From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v2 1/2] cgroup: sev: Add misc cgroup controller
Date: Wed, 3 Mar 2021 22:12:32 -0800
Message-ID: <YEB6ULUgbf+s8ydd@google.com>
References: <20210302081705.1990283-1-vipinsh@google.com>
 <20210302081705.1990283-2-vipinsh@google.com>
 <YD+ubbB4Tz0ZlVvp@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wrRdPDPB3VCRpfnlU4rkj1XLWJk4+xODxpIbuwpHG+Y=;
        b=Mym+BpeRKl4ppls7nPY+P84Wq2Ud/GZk6tA0DczxIwInISgM7CE1f2mF7YJfODiqK4
         XH3AcCKqc8EP1qDxSnxZfc3OaZgrLZjYhMxoQGdzAX9eRqIwn5TrLUe3aVvj1+95nlc4
         t+mWhOGTQervTzGSIfWDK0WpFFPiX1V/GhAgaMZQciXUpe3mRBZ2L2WcSt9gj0fbV+Nn
         ADWTRRnbMc4R+ee4X2l6udt04Tmxxf/PoypVtrzbHnC99T6/ZF3jFsQeGHxoRLFcd6su
         kjOdjT8wTHO84LDxBLDEo2trTu7feZ3mQESF3hDu+dWyyHlkU3nAlu8jZB26xsWoMJwP
         Iv9w==
Content-Disposition: inline
In-Reply-To: <YD+ubbB4Tz0ZlVvp-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 03, 2021 at 10:42:37AM -0500, Tejun Heo wrote:
> > +	atomic_t usage;
> > +};
> 
> Can we do 64bits so that something which counts memory can use this too?
> 
Sure.

> > +
> > +		if (usage > capacity)
> > +			return -EBUSY;
> 
> I'd rather go with allowing bringing down capacity below usage so that the
> users can set it to a lower value to drain existing usages while denying new
> ones. It's not like it's difficult to check the current total usage from the
> caller side, so I'm not sure it's very useful to shift the condition check
> here.
> 

Okay, I will change the code to set new capacity unconditionally.

Right now there is no API for the caller to know total usage, unless they
keep their own tally, I was thinking it will be useful to add one more API

unsigned long misc_cg_res_total_usage(enum misc_res_type type)

It will return root_cg usage for "type" resource.
Will it be fine?

> > +			pr_info("cgroup: charge rejected by misc controller for %s resource in ",
> > +				misc_res_name[type]);
> > +			pr_cont_cgroup_path(i->css.cgroup);
> > +			pr_cont("\n");
> 
> Should have commented on this in the priv thread but don't print something
> on every rejection. This often becomes a nuisance and can make an easy DoS
> vector at worst. If you wanna do it, print it once per cgroup or sth like
> that.

I didn't think in that way. Thanks, I will print it once per cgroup.

Thanks
Vipin
