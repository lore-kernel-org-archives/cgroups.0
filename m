From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
Date: Fri, 12 Mar 2021 11:07:14 -0800
Message-ID: <YEu74hkEPEyvxC85@google.com>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <20210304231946.2766648-2-vipinsh@google.com>
 <YEpod5X29YqMhW/g@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=tJjzSwOgveQ7vdx3Cu3uc6PULmHuHzmVLjdTR0gLlhA=;
        b=ntQoBbcWXqtifUBev/B0KOJ7BdEhMcK4Vt5DvxlbjWTaLmYcIzto4hVOQ019Ktjclt
         IzpMHUC/yiAR42nNISAaWyzIojLrbFqvLiuqfCJeg4pkWHKlQIuqvE/fB5ka2n9/pkxv
         YKc+kNafGRjUbzhy/8GpyCOkWZhLaF7gTkkwxvjBQ05Zb4MpXjI1NEx/9kHWr5VG/hr9
         fyFTu4Dx4sGcxcI4/77RGpWwmxVRidKc9jp2iRX8mPbvdvav/UYKiLxb3Kwnjf/GxyYm
         jnVuPX8KHdjB2ohJT5DD6zNXt2j3Go/jUeaKAltxlVB+ClDE9O+cvF1HmjxqqD3oE3ec
         Q9sA==
Content-Disposition: inline
In-Reply-To: <YEpod5X29YqMhW/g@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: tj@kernel.org, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Mar 11, 2021 at 07:59:03PM +0100, Michal Koutn=FD wrote:
> Given different two-fold nature (SEV caller vs misc controller) of some
> remarks below, I think it makes sense to split this into two patches:
> a) generic controller implementation,
> b) hooking the controller into SEV ASIDs management.

Sounds good. I will split it.

> > +	if (misc_res_capacity[type])
> > +		cg->res[type].max =3D max;
> In theory, parallel writers can clash here, so having the limit atomic
> type to prevent this would resolve it. See also commit a713af394cf3
> ("cgroup: pids: use atomic64_t for pids->limit").

We should be fine without atomic64_t because we are using unsigned
long and not 64 bit explicitly. This will work on both 32 and 64 bit
machines.

But I will add READ_ONCE and WRITE_ONCE because of potential chances of
load tearing and store tearing.

Do you agree?

> > +static int misc_cg_capacity_show(struct seq_file *sf, void *v)
> > +{
> > +	int i;
> > +	unsigned long cap;
> > +
> > +	for (i =3D 0; i < MISC_CG_RES_TYPES; i++) {
> > +		cap =3D READ_ONCE(misc_res_capacity[i]);
> Why is READ_ONCE only here and not in other places that (actually) check
> against the set capacity value? Also, there should be a paired
> WRITE_ONCCE in misc_cg_set_capacity().

This was only here to avoid multiple reads of capacity and making sure
if condition and seq_print will see the same value. Also, I was not
aware of load and store tearing of properly aligned and machine word
size variables. I will add READ_ONCE and WRITE_ONCE at
other places.

Thanks
Vipin
