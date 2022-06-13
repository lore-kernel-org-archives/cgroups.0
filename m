From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v11 7/8] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Mon, 13 Jun 2022 16:24:52 +0200
Message-ID: <20220613142452.GB6910@blackbody.suse.cz>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-8-longman@redhat.com>
 <YqYnQ4U4t6j/3UaL@slm.duckdns.org>
 <404171dc-0da3-21f2-5003-9718f875e967@redhat.com>
 <YqarMyNo9oHxhZFh@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655130294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0QxbXQTWScLBHdZkYfR8jKfBuUw2/vlOoxDD3FnCzX0=;
        b=CMvjzQmOEJZmJ+aCXYUtYR6cV2a6B/yT0U+mHCBSEypUkXGJFDyWBPHB0Z7IkXFKBXiRob
        WaN/MSCTSa5yUU5jEZUlmEXKUyG+tp45OcGy7/VDzJHcTwEDmzJg2g6ueidLXSqAt3+sjI
        8jYUsq6TWTWCGAp7ockBvOyJRSK4p7w=
Content-Disposition: inline
In-Reply-To: <YqarMyNo9oHxhZFh-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 12, 2022 at 05:12:51PM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>=20
> On Sun, Jun 12, 2022 at 11:02:38PM -0400, Waiman Long wrote:
> > That is the behavior enforced by setting the CPU_EXCLUSIVE bit in cgrou=
p v1.
> > I haven't explicitly change it to make it different in cgroup v2. The m=
ajor
> > reason is that I don't want change to one cpuset to affect a sibling
> > partition as it may make the code more complicate to validate if a part=
ition
> > is valid.
>=20
> If at all possible, I'd really like to avoid situations where a parent ca=
n't
> withdraw resources due to something that a descendant does.

My understanding of the discussed paragraph is that the changes are only
disallowed only among siblings on one level (due to exclusivity rule,
checked in validate_change()). A change in parent won't affect
(non)exclusivity of (valid) children so it's simply allowed.

So the docs (and implementation by a quick look) is sensible.

Michal

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYqdIsgAKCRAkDQmsBEOq
uQsKAQCuQgJeY8pngbeck33qpmT/9IqMQLfNBYRRLLM9dlUPbgEAw+wDMnZ9MjQW
KY6lhKrvUT5CEfFIjAzZay9tJBO/BAU=
=JcWM
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
