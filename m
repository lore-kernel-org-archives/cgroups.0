From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: clarification about misc controller and capacity vs. max
Date: Wed, 2 Nov 2022 19:19:02 +0100
Message-ID: <20221102181902.GA25267@blackbody.suse.cz>
References: <2f7b7d6b10bdcbc9a73ea449d3636575124afa25.camel@intel.com>
 <Y2FPSqOaQGnISvXu@slm.duckdns.org>
 <14c21f13ebbcdbd0ea4f75b7fff790b31a05a5aa.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667413143; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i8OXey/PxRAn40mqSgN2tC64eUdoFvOstMSQHeo4Byg=;
        b=YpQdvG5XC6BH3CVi3lhlrFgAyQFPaf9DawEAPC38cwS/fmsTb31DiHYc3Nzse7GX5N79jf
        Qby8opGz8mAJvAIyC3cDAMgYOXsoaTfymYMQiXXeB4Z6/WT5f+UyDAVrdgjEsZXkNBhneu
        JAKZ4sK/0vVXuJwmxTbgUcXiycm9agA=
Content-Disposition: inline
In-Reply-To: <14c21f13ebbcdbd0ea4f75b7fff790b31a05a5aa.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: "Accardi, Kristen C" <kristen.c.accardi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Tue, Nov 01, 2022 at 05:03:25PM +0000, "Accardi, Kristen C" <kristen.c.a=
ccardi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> So to be clear, if I have this:
>=20
> /sys/fs/cgroup/misc.capacity
> some_res 10
>=20
> and this:
> /sys/fs/cgroup/test
>=20
> test.current will never be allowed to exceed 10.

If the capacity was initially larger than 10 and charges inside test
succeeded and then some event caused shrinking of the resource (without
synchronously preempting distributed units), then test.misc.current can
exceed the current capacity.

See the condition in misc_cg_current_show()
    if (READ_ONCE(misc_res_capacity[i]) || usage)

What the shrinking and preemption means is up to the implementation of
the particular miscresource.

IOW sum of 1st level children's .current may overrun capacity,
semantics is not defined by the misc controller (but it'd reject new
charges in such a situation).

(That's just for completeness. I understood from the rest that you
rather want to disable capacity checking.)

HTH,
Michal

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY2K0lAAKCRAkDQmsBEOq
ucMuAP9zkS5oP28Z2jHwng5UJQbSYQw4i/ls6fpyjRE4w3i5QgEA2vCtWWVForhC
EsFfz+2XCx5xTNicqVq9QroOFxGgIgw=
=Uxqg
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
