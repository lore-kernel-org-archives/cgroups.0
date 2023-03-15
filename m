From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/5] cgroup/cpuset: Include offline CPUs when tasks'
 cpumasks in top_cpuset are updated
Date: Wed, 15 Mar 2023 11:06:18 +0100
Message-ID: <20230315100618.6cypp4l3vjpg2p7r@blackpad>
References: <20230306200849.376804-1-longman@redhat.com>
 <20230306200849.376804-3-longman@redhat.com>
 <20230314173411.fqaxoa2tfifnj6i3@blackpad>
 <957bd5c2-1bae-de95-f119-483ef64dab60@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yqt7k42xoiztgvzs"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678874780; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=auNt55LvkWQ3/5jHUnJWSmBV3O1aurOSCvt2OfSASXw=;
        b=EWusQoZrHm4R+Z8gOwf+VWiGLfTg/YPBBz4ukCor9snEInG4fAo11/bMdFC5EFIdKhzZ0Q
        htin41SUiyeWwMG+mevKr1YFOTOb489CJxVl4D+YgVVzz03EGv+stcJD7fwwWXLjvNl6HV
        VJ2dt74dBXEM23dSMQs4clS7lCkjrS4=
Content-Disposition: inline
In-Reply-To: <957bd5c2-1bae-de95-f119-483ef64dab60-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>


--yqt7k42xoiztgvzs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 14, 2023 at 03:02:53PM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> > > +			cpumask_andnot(new_cpus, possible_mask, cs->subparts_cpus);
> > > +		} else {
> > > +			cpumask_and(new_cpus, cs->effective_cpus, possible_mask);
> > > +		}
> > I'm wrapping my head around this slightly.
> > 1) I'd suggest swapping args in of cpumask_and() to have possible_mask
> >     consistently first.
> I don't quite understand what you meant by "swapping args". It is effecti=
ve
> new_cpus =3D cs->effective_cpus =E2=88=A9 possible_mask. What is the poin=
t of swapping
> cs->effective_cpus and possible_mask.

No effect except better readability (possible_mask comes first in the
other branch above too, left hand arg as the "base" that's modified).


> > 2) Then I'm wondering whether two branches are truly different when
> >     effective_cpus :=3D cpus_allowed - subparts_cpus
> >     top_cpuset.cpus_allowed =3D=3D possible_mask        (1)
> effective_cpus may not be equal "cpus_allowed - subparts_cpus" if some of
> the CPUs are offline as effective_cpus contains only online CPUs.
> subparts_cpu can include offline cpus too. That is why I choose that
> expression. I will add a comment to clarify that.

I see now that it returns offlined cpus to top cpuset's tasks.

> >=20
> > IOW, can you see a difference in what affinities are set to eligible
> > top_cpuset tasks before and after this patch upon CPU hotplug?
> > (Hm, (1) holds only in v2. So is this a fix for v1 only?)
>=20
> This is due to the fact that cpu hotplug code currently doesn't update the
> cpu affinity of tasks in the top cpuset. Tasks not in the top cpuset can
> rely on the hotplug code to update the cpu affinity appropriately.

Oh, I mistook this for hotplug changing behavior but it's actually for
updating top_cpuset when its children becomes a partition root.

	IIUC, top cpuset + hotplug has been treated specially because
	hotplug must have taken care of affinity regardless of cpuset.
	v1 allowed modification of top cpuset's mask (not sure if that
	worked), v2 won't allow direct top cpuset's mask modificiation
	but indirectly via partition root children.

So this is a continuation for 3fb906e7fabb ("cgroup/cpuset: Don't filter
offline CPUs in cpuset_cpus_allowed() for top cpuset tasks") to ensure
hotplug offline/online cycle won't overwrite top_cpuset tasks'
affinities (when partition change during offlined period).
This looks correct in this regard then.
(I wish it were simpler but that's for a different/broader top
cpuset+hotplug approach.)

Thanks,
Michal

--yqt7k42xoiztgvzs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZBGYmAAKCRAkDQmsBEOq
uaWcAQDsTN8vvkQ0WHz1vK9CcBuE+hz0udNCFVljCdlcN7YaoQD/ReBCP2l0Ow8V
Ka835fpnfysSJql4yq+mHpTDP+XMJAk=
=JvSg
-----END PGP SIGNATURE-----

--yqt7k42xoiztgvzs--
