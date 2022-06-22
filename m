From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup.c: remove redundant check for mixable cgroup in
 cgroup_migrate_vet_dst
Date: Wed, 22 Jun 2022 19:49:57 +0200
Message-ID: <20220622174957.GB669@blackbody.suse.cz>
References: <20220621092358.223594-1-linf@wangsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655920198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=opRo91P/GqK7yMzaovz4eIUEVNzRY22y9hP9e6SynAE=;
        b=D+jNeDTCFQct16h23qveyk5vzFvj/kMfo/QQR3E6yoNoigE+Frq/OOcIgnkqPh7y9namtq
        mj78bxp35TL74EPYrn99JM4gLqtVq/vNwS8vF00br3rWKiqQHWVE67NGbPEYqoanRFYTPU
        2WNEO0SeZeekiINyeRZE7VxL9KstvGY=
Content-Disposition: inline
In-Reply-To: <20220621092358.223594-1-linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Lin Feng <linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 21, 2022 at 05:23:58PM +0800, Lin Feng <linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org> wrote:
> so explicitly checking in cgroup_migrate_vet_dst is unnecessary.

Good catch.

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>


--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYrNWQQAKCRAkDQmsBEOq
ucMQAQC0vzEGYqYMe6iT+QCRjrhLmh+/uMOR0c3LFFtmaHJ61QEAqVYmOYC4n0eP
w/y9++DuP60Q2oG0yFUWmok1L6iL1gs=
=mSj7
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
