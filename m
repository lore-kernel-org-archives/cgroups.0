From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 00/20] Add Cgroup support for SGX EPC memory
Date: Mon, 26 Sep 2022 11:30:39 -0700
Message-ID: <4898ee6cd2b6c6dc1e89890c4b26c5c80b4d9496.camel@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
         <YyyeSVSk/lWdo/W4@slm.duckdns.org>
         <4b8605533e5deade739249bfb341ab9c06d56a1e.camel@linux.intel.com>
         <YyyykUJQtYbPVctn@slm.duckdns.org>
         <7ff6d114-a6cc-e3c5-5edb-8ac0e527d8a9@intel.com>
         <Yy5KwnRTbFjmKE9X@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664217065; x=1695753065;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=bYxR8XqfZF9gxiYvUcSZcCJ2VTxb74tRDtYgU4TZI4Y=;
  b=QcYu8sB5yJJtuM3Q9Myf+sehUruV2bnc+6S/mMaKH4a20anB0SoPaeHm
   akbOZu2qqgQiKaJi9QO86SIeWqzgRm7UfJ+tCUTNqdU3zU0Kfg7HkhDDI
   8PEwPK2qKjJkcOu8e0JqkE/MWala6/T153BK1Pxc1yd9zBH3hvZP73pQz
   5HIYB0f+iV722nZeyqWRcMxvNeEg5T6KG9CcBpQwyZ3HzQkmbXB+6W9CV
   MrkG5gky7wtCtwSum25w3TChvcJNbrR8xlBqwANFtSrC+yN67LBvzjKLf
   wFWFpxstUBRCX9bLFMIj3lAoh1mhybdzNALLbEmzrygwAr71lu02Fz7iQ
   g==;
In-Reply-To: <Yy5KwnRTbFjmKE9X-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Fri, 2022-09-23 at 14:09 -1000, Tejun Heo wrote:
> Hello,
>=20
> On Thu, Sep 22, 2022 at 02:03:52PM -0700, Dave Hansen wrote:
> > On 9/22/22 12:08, Tejun Heo wrote:
> > > Can you please give more concrete examples? I'd love to hear how
> > > the SGX EPC
> > > memory is typically used in what amounts and what's the
> > > performance
> > > implications when they get reclaimed and so on. ie. Please
> > > describe a
> > > realistic usage scenario of contention with sufficient details on
> > > how the
> > > system is set up, what the applications are using the SGX EPC
> > > memory for and
> > > how much, how the contention on memory affects the users and so
> > > on.
> >=20
> > One wrinkle is that the apps that use SGX EPC memory are *normal*
> > apps.
> > =C2=A0There are frameworks that some folks are very excited about that
> > allow
> > you to run mostly unmodified app stacks inside SGX.=C2=A0 For example:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0https://github.com/gram=
ineproject/graphene
> >=20
> > In fact, Gramine users are the troublesome ones for overcommit.=C2=A0
> > Most
> > explicitly-written SGX applications are quite austere in their SGX
> > memory use; they're probably never going to see overcommit.=C2=A0 These
> > Gramine-wrapped apps are (relative) pigs.=C2=A0 They've been the ones
> > finding
> > bugs in the existing SGX overcommit code.
> >=20
> > So, where does all the SGX memory go?=C2=A0 It's the usual suspects:
> > memcached and redis. ;)
>=20
> Hey, so, I'm a bit weary that this doesn't seem to have a strong
> demand at
> this point. When there's clear shared demand, I usually hear from
> multiple
> parties about their use cases and the practical problems they're
> trying to
> solve and so on. This, at least to me, seems primarily driven by
> producers
> than consumers.
>=20
> There's nothing wrong with projecting future usages and jumping ahead
> the
> curve but there's a balance to hit, and going full-on memcg-style
> controller
> with three control knobs seems to be jumping the gun and may create
> commitments which we end up looking back on with a bit of regret.
>=20
> Given that, how about this? We can easily add the functionality of
> .max
> through the misc controller. Add a new key there, trycharge when
> allocating
> new memory, if fails, try reclaim and then fail allocation if reclaim
> fails
> hard enough. I belive that should give at least a reasonable place to
> start
> especially given that memcg only had limits with similar semantics
> for quite
> a while at the beginning.
>=20
> That way, we avoid creating a big interface commitments while
> providing a
> feature which should be able to serve and test out the immediate
> usecases.
> If, for some reason, many of us end up running hefty applications in
> SGX, we
> can revisit the issue and build up something more complete with
> provisions
> for backward compatibility.
>=20
> Thanks.
>=20

Hi Tejun,

thanks for your suggestion. Let me discuss this with customers who
requested this feature (not all customers like to respond publically)
and see if it will meet needs. If there is an issue, I'll respond back
with concerns.

Thanks,
Kristen

