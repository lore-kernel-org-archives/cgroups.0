From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Fri, 15 Jan 2021 22:43:32 -0500
Message-ID: <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/rrxaLl/1RYv52Tg0tmQaRL1KMmod/XpsPxJFkVknMw=;
        b=pNabNEooGioMTBokqWDJs4vPKzX6S2/DjTzFl3fopsSC+CcHCbpL9lL559Asbyt60E
         gWSrSZmHP5WIGcbDaHDs2xuEHm235/Dr8eiqMjj3SM2zjw8TCOats7USFDvUUHEbZwrC
         sUrCLnkSxnGEQC45/05qUT30+tf9LFuLN8utC/5DQ7KEAezjyk1R27XavvgXohBbftmg
         nwadR36gQdasHOIGPufBPtwJ3lFyKzGF8Xc36K0UMb+yd2SvYQh3XyEtkXNv9y7b2HXB
         giDPpmqTrqal1FaxZXlKkePNsvel6tULDXWt2XEo64T5+wOUvHPX+uoz4uC3htXu5ZCJ
         7egQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YAIUwGUPDmYfUm/a@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: thomas.lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jan 15, 2021 at 02:18:40PM -0800, Vipin Sharma wrote:
> > * Why is .sev a separate namespace? Isn't the controller supposed to cover
> >   encryption ids across different implementations? It's not like multiple
> >   types of IDs can be in use on the same machine, right?
> > 
> 
> On AMD platform we have two types SEV and SEV-ES which can exists
> simultaneously and they have their own quota.

Can you please give a brief explanation of the two and lay out a scenario
where the two are being used / allocated disjointly?

> > > Other ID types can be easily added in the controller in the same way.
> > 
> > I'm not sure this is necessarily a good thing.
> 
> This is to just say that when Intel and PowerPC changes are ready it
> won't be difficult for them to add their controller.

I'm not really enthused about having per-hardware-type control knobs. None
of other controllers behave that way. Unless it can be abstracted into
something common, I'm likely to object.

> > > +static int enc_id_cg_stat_show(struct seq_file *sf, void *v)
> > > +{
> > > +	unsigned long flags;
> > > +	enum encryption_id_type type = seq_cft(sf)->private;
> > > +
> > > +	spin_lock_irqsave(&enc_id_cg_lock, flags);
> > > +
> > > +	seq_printf(sf, "total %u\n", enc_id_capacity[type]);
> > > +	seq_printf(sf, "used %u\n", root_cg.res[type].usage);
> > 
> > Dup with .current and no need to show total on every cgroup, right?
> 
> This is for the stat file which will only be seen in the root cgroup
> directory.  It is to know overall picture for the resource, what is the
> total capacity and what is the current usage. ".current" file is not
> shown on the root cgroup.

Ah, missed the flags. It's odd for the usage to be presented in two
different ways tho. I think it'd make more sense w/ cgroup.current at root
level. Is the total number available somewhere else in the system?

Thanks.

-- 
tejun
