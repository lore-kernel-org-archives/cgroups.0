From: Sean Christopherson <seanjc@google.com>
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
Date: Fri, 12 Mar 2021 12:51:25 -0800
Message-ID: <YEvUTatAjIoP7dPD@google.com>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <20210304231946.2766648-2-vipinsh@google.com>
 <YEpod5X29YqMhW/g@blackbook>
 <YEvFldKZ8YQM+t2q@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vDrjln050ZWSD2n57JKYsjj24mDG3Mu6cQfXoag8kqA=;
        b=o1+mWphvFvKetD8P/Z44PWPcjEPdOlxMP5SOQC16Tskp42s9q00lujmGOIFQWhhEaV
         1ink7OOHVOKxPCCC+xqBCilm4hYNtfYqXA93rZbxOrH+fXw4mCuIhAwvWzxV35JiV+lI
         F1bLUj/xMyG+8vXBR7aexe3fAaM4Tn1okrASG7GtrXc5qspcBWXZQM7rDaB+VFV0N60v
         kqKR+njm735YkwAXVBzJHHZZE38U649WTUg1VLZeSW1oWofsuolBzXu7AdqcTUoHQVzv
         iadBzD/YkaVT31MESOfV0PH2BVjAOVGU26qG6tzmz3UOVKovVIWHocspnwgnzALbc0so
         pMqQ==
Content-Disposition: inline
In-Reply-To: <YEvFldKZ8YQM+t2q@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vipin Sharma <vipinsh@google.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, thomas.lendacky@amd.com, brijesh.singh@amd.com, tj@kernel.org, rdunlap@infradead.org, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Mar 12, 2021, Vipin Sharma wrote:
> On Thu, Mar 11, 2021 at 07:59:03PM +0100, Michal Koutn=FD wrote:
> > > +#ifndef CONFIG_KVM_AMD_SEV
> > > +/*
> > > + * When this config is not defined, SEV feature is not supported and=
 APIs in
> > > + * this file are not used but this file still gets compiled into the=
 KVM AMD
> > > + * module.
> > > + *
> > > + * We will not have MISC_CG_RES_SEV and MISC_CG_RES_SEV_ES entries i=
n the enum
> > > + * misc_res_type {} defined in linux/misc_cgroup.h.
> > BTW, was there any progress on conditioning sev.c build on
> > CONFIG_KVM_AMD_SEV? (So that the defines workaround isn't needeed.)
>=20
> Tom, Brijesh,
> Is this something you guys thought about or have some plans to do in the
> future? Basically to not include sev.c in compilation if
> CONFIG_KVM_AMD_SEV is disabled.

It's crossed my mind, but the number of stubs needed made me back off.  I'm
certainly not opposed to the idea, it's just not a trivial change.
