From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 01/18] cgroup/misc: Add per resource callbacks for
 CSS events
Date: Mon, 25 Sep 2023 19:57:17 +0300
Message-ID: <CVS5O6QV7OWF.UBP59U46WUBX@suppilovahvero>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-2-haitao.huang@linux.intel.com>
 <CVHOU5G1SCUT.RCBVZ3W8G2NJ@suppilovahvero>
 <op.2bci9anpwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695661043;
        bh=/TClsZXVGXCV9uINJx9IgXVRoHxhac9DAEBNZbscd1w=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=WBNUXt/WPWhBOc7FN29nn/y8nh1h4+x9bTO6ai3NHcfLzlWG/RF6iEYi1pEp1HTh8
         4LwFwL0c28Mm3QpAWj77WQVmkvBNkEA5CR6+zaET2Tlk2gaYI/0IrX/HOpkMeoOXyb
         cPRErNZxEP2NLg9LCXSqWIwcIYiputLZ3MLdTsN12Q68acODnioW443+WPg+HKIizl
         Nd/Z1N48K4NZ1DXFnadVJkdgIPRFCwXvnphpYImcEgrmtpxS/DHAc9lqiYJIEazOF2
         8r33lZHLd77+B7WO3wIROGBDbMbJwg0Yueyzyb71wNWRiLWJ6wUFrQTOGAvx3S6DS/
         40ITz+rb7puIw==
In-Reply-To: <op.2bci9anpwjvjmi-yDQzE4XY+yVaPPhiJ6yCxLKMmGWinSIL2HeeBUIffwg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Sat Sep 16, 2023 at 7:11 AM EEST, Haitao Huang wrote:
> Hi Jarkko
>
> On Wed, 13 Sep 2023 04:39:06 -0500, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> =
=20
> wrote:
>
> > On Wed Sep 13, 2023 at 7:06 AM EEST, Haitao Huang wrote:
> >> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >>
> >> Consumers of the misc cgroup controller might need to perform separate
> >> actions for Cgroups Subsystem State(CSS) events: cgroup alloc and free=
.
> >
> > nit: s/State(CSS)/State (CSS)/
> >
> > "cgroup alloc" and "cgroup free" mean absolutely nothing.
> >
> >
> >> In addition, writes to the max value may also need separate action. Ad=
d
> >
> > What "the max value"?
> >
> >> the ability to allow downstream users to setup callbacks for these
> >> operations, and call the corresponding per-resource-type callback when
> >> appropriate.
> >
> > Who are "the downstream users" and what sort of callbacks they setup?
>
> How about this?
>
> The misc cgroup controller (subsystem) currently does not perform resourc=
e =20
> type specific action for Cgroups Subsystem State (CSS) events: the =20
> 'css_alloc' event when a cgroup is created and the 'css_free' event when =
a =20
> cgroup is destroyed, or in event of user writing the max value to the =20
> misc.max file to set the consumption limit of a specific resource =20
> [admin-guide/cgroup-v2.rst, 5-9. Misc].
>
> Define callbacks for those events and allow resource providers to registe=
r =20
> the callbacks per resource type as needed. This will be utilized later by=
 =20
> the EPC misc cgroup support implemented in the SGX driver:
> - On cgroup alloc, allocate and initialize necessary structures for EPC =
=20
> reclaiming, e.g., LRU list, work queue, etc.
> - On cgroup free, cleanup and free those structures created in alloc.
> - On max write, trigger EPC reclaiming if the new limit is at or below =
=20
> current consumption.

Yeah, this is much better (I was on holiday, thus the delay on
response).

> Thanks
> Haitao

BR, Jarkko
