From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
Date: Fri, 12 Mar 2021 11:48:37 -0800
Message-ID: <YEvFldKZ8YQM+t2q@google.com>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <20210304231946.2766648-2-vipinsh@google.com>
 <YEpod5X29YqMhW/g@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zuaTRfZk4KRzZSmxlNItyx5xWByHUkD0/JshLCV8WMM=;
        b=IaU52dkJTOEb+ySNKCWrDTgUccXTzzNVSIkFb/oKqISl2Zm82pfTIJJrINPh3gEISu
         wqODIgofIW2biXzNaXrk3K+R3ysiwdg1lxXYXgGwQhEoZim8L6kmWGvPvbPFsLuqwe2Q
         vVCGaYGtGcQzOgriqb7Hp2kKwnHn7/oAzr0LLbRo1OS1HxJtuPo8NChHgDBZXrOz/HOG
         VG/JR249fw7osncKemnky6bHNM+nEzmsBDygYDdRYTuS9U36krcOs5ZhiEDJ6Ylcq2sW
         2+IGeAShq0oeY79hz1mA+M0B0L64tNihivmYUoJmtqNaIdMvuwJtTIpBY/LhINyzP5aT
         1/jw==
Content-Disposition: inline
In-Reply-To: <YEpod5X29YqMhW/g@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, thomas.lendacky@amd.com, brijesh.singh@amd.com
Cc: tj@kernel.org, rdunlap@infradead.org, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Mar 11, 2021 at 07:59:03PM +0100, Michal Koutn=FD wrote:
> > +#ifndef CONFIG_KVM_AMD_SEV
> > +/*
> > + * When this config is not defined, SEV feature is not supported and A=
PIs in
> > + * this file are not used but this file still gets compiled into the K=
VM AMD
> > + * module.
> > + *
> > + * We will not have MISC_CG_RES_SEV and MISC_CG_RES_SEV_ES entries in =
the enum
> > + * misc_res_type {} defined in linux/misc_cgroup.h.
> BTW, was there any progress on conditioning sev.c build on
> CONFIG_KVM_AMD_SEV? (So that the defines workaround isn't needeed.)

Tom, Brijesh,
Is this something you guys thought about or have some plans to do in the
future? Basically to not include sev.c in compilation if
CONFIG_KVM_AMD_SEV is disabled.

Michal,
This should not be a blocker for misc controller. This thing can change
independent of misc cgroup.

Thanks
Vipin
