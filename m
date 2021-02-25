From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC 1/2] cgroup: sev: Add misc cgroup controller
Date: Wed, 24 Feb 2021 20:57:36 -0800
Message-ID: <YDcuQFMbe5MaatBe@google.com>
References: <20210218195549.1696769-1-vipinsh@google.com>
 <20210218195549.1696769-2-vipinsh@google.com>
 <YDVIdycgk8XL0Zgx@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GCPvH/ftBaPKrIrg1SrRaA28WOD5QZfwlnEHwgccJos=;
        b=qcnZZYCJi98bpluIA+Q6PbpZt/DTsw6UAEq6IRMRd1PNOsFM6BO9kPihfoQQQb87Rx
         fsrwNx3FnRYOVp90fuaDu9oOIAHKQZ5JRcw5J4/+z10kW3ty+3KpTL1AUzSuEpCF/9CX
         c2ODR7C0MZAeApvSVIMhXxFEE4oO34Tfc3p1nBRDx/buMluyiYYrdFtAv9BTvjIwkNuL
         P7AGSBh/JZKXRr05hZuaMm7Vp/wH9GiJkDriIApAxmnd3CcoDOrjpj0FWSALeojZv+P/
         0JAirMem5/JvDvQ14shHJRy+NVY7k2H+KT9Fep2BLYxsIHztz/JM1LZDgnAXK8U1qVJf
         fFAQ==
Content-Disposition: inline
In-Reply-To: <YDVIdycgk8XL0Zgx@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, thomas.lendacky@amd.com
Cc: tj@kernel.org, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Feb 23, 2021 at 07:24:55PM +0100, Michal Koutn=FD wrote:
> On Thu, Feb 18, 2021 at 11:55:48AM -0800, Vipin Sharma <vipinsh@google.co=
m> wrote:
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > [...]
> > +#ifndef CONFIG_KVM_AMD_SEV
> > +/*
> > + * When this config is not defined, SEV feature is not supported and A=
PIs in
> > + * this file are not used but this file still gets compiled into the K=
VM AMD
> > + * module.
> I'm not familiar with the layout of KVM/SEV compile targets but wouldn't
> it be simpler to exclude whole svm/sev.c when !CONFIG_KVM_AMD_SEV?
>=20

Tom,
Is there any plan to exclude sev.c compilation if CONFIG_KVM_AMD_SEV is
not set?

> > +++ b/kernel/cgroup/misc.c
> > [...]
> > +/**
> > + * misc_cg_set_capacity() - Set the capacity of the misc cgroup res.
> > + * @type: Type of the misc res.
> > + * @capacity: Supported capacity of the misc res on the host.
> > + *
> > + * If capacity is 0 then the charging a misc cgroup fails for that typ=
e.
> > + *
> > + * The caller must serialize invocations on the same resource.
> > + *
> > + * Context: Process context.
> > + * Return:
> > + * * %0 - Successfully registered the capacity.
> > + * * %-EINVAL - If @type is invalid.
> > + * * %-EBUSY - If current usage is more than the capacity.
> When is this function supposed to be called? At boot only or is this
> meant for some kind of hot unplug functionality too?
>=20

This function is meant for hot unplug functionality too.

> > +int misc_cg_try_charge(enum misc_res_type type, struct misc_cg **cg,
> > +		       unsigned int amount)
> > [...]
> > +		new_usage =3D atomic_add_return(amount, &res->usage);
> > +		if (new_usage > res->max ||
> > +		    new_usage > misc_res_capacity[type]) {
> > +			ret =3D -EBUSY;
> I'm not sure the user of this resource accounting will always be able to
> interpret EBUSY returned from depths of the subsystem.
> See what's done in pids controller in order to give some useful
> information about why operation failed.

Just to be on the same page are you talking about adding an events file
like in pids?

>=20
> > +			goto err_charge;
> > +		}
> > +
> > +		// First one to charge gets a reference.
> > +		if (new_usage =3D=3D amount)
> > +			css_get(&i->css);
> 1) Use the /* comment */ style.
> 2) You pin the whole path from task_cg up to root (on the first charge).
> That's unnecessary since children reference their parents.
> Also why do you get the reference only for the first charger? While it
> may work, it seems too convoluted to me.
> It'd be worth documenting what the caller can expect wrt to ref count of
> the returned misc_cg.

Suppose a user charges 5 resources in a single charge call but uncharges
them in 5 separate calls one by one. I cannot take reference on every
charge and put the reference for every uncharge as it is not guaranteed
to have equal number of charge-uncharge pairs and we will end up with
the wrong ref count.

However, if I take reference at the first charge and remove reference at
last uncharge then I can keep the ref count in correct sync.

I can rewrite if condition to (new_usage =3D=3D amount && task_cg =3D=3D i)
this will avoid pinning whole path up to the root. I was thinking that
original code was simpler, clearly I was wrong.

Thanks
Vipin
