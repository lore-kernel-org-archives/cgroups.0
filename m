From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v2 2/2] memcg: periodically flush the memcg stats
Date: Thu, 24 Jun 2021 16:01:26 +0200
Message-ID: <YNSQNu4ZW7mEX6LW@blackbook>
References: <20210615174435.4174364-1-shakeelb@google.com>
 <20210615174435.4174364-2-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="c4XJuQpPXESUwDMB"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624543288; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FEFKZdgTERWXT+0XJ1bL+AoGSIdGk1Zg9WIdMoUJSP4=;
        b=CWzYk38bXrB42FnPkKbbWY9XOlnfxGFr30hdadDcnhfnJjYKG2Q1WwBaF+eYarN5VVPpfF
        fZY829DJIgn6fhqh8AGEe3Dtoi2z476kM+l/07Y5JdlqevOQT8MR8N9KeCASCvfBN/wySl
        EWry2ykB05wxstef6iRnlUwBc//9vx0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624543288; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FEFKZdgTERWXT+0XJ1bL+AoGSIdGk1Zg9WIdMoUJSP4=;
        b=CWzYk38bXrB42FnPkKbbWY9XOlnfxGFr30hdadDcnhfnJjYKG2Q1WwBaF+eYarN5VVPpfF
        fZY829DJIgn6fhqh8AGEe3Dtoi2z476kM+l/07Y5JdlqevOQT8MR8N9KeCASCvfBN/wySl
        EWry2ykB05wxstef6iRnlUwBc//9vx0=
Content-Disposition: inline
In-Reply-To: <20210615174435.4174364-2-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <songmuchun@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Huang Ying <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org


--c4XJuQpPXESUwDMB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Shakeel.

On Tue, Jun 15, 2021 at 10:44:35AM -0700, Shakeel Butt <shakeelb@google.com=
> wrote:
> At the moment memcg stats are read in four contexts:
>=20
> 1. memcg stat user interfaces
> 2. dirty throttling
> 3. page fault
> 4. memory reclaim

Sorry for being dense or ignorant -- what do you refer to with the point
no. 3 (memcg stats reader during page fault)?

Thanks,
Michal

--c4XJuQpPXESUwDMB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmDUkDIACgkQia1+riC5
qSgkNQ//Wx0lGjWBl5Ptgkl24PLr6hC4dKT9xfGHtREMBivFRgsE7HDg49GLByPH
qUAvKXTGT6aD5vnwCWjQLC6DrLHSXCdDFWRdg0QjFtAoPGnNNoil0bZ1JJIwH7EU
RJ1CVAdMoCwGc0P1tY/fl3hb/l6alCa9ogmfmBtrDZYKIeYkAque3jRMgbzFwPqA
ME1FFj9eO4WyxTvl34p1Lc3S3rq2YBEWskuJ27f0okqfVo3TZAER8ZTHU9YEuSb0
fh/rspft73eHhmYLtri5zZYwsl8WudFavZYGBD/m01cwy8GlxMczm5aep4m4NDSY
+OFuESusbxrVAq7Kjq3UU0DKxQj+bN1QRnVcMt1ZUiiIPEn6sRUK/DYTPFMYCSrh
jaI9f8f5ADEfWuPanlLbcaTkxWFwOHRM6YxjP52NMcCXt7DMGJKxMxUXQdOd4PSY
HnMhO0BiJErkCdU3m5omvvT+aK5/dF8q6SaAwWLea+NeOBTxOIIaCRs0VtO9CRJb
zEE/bi+BKAsjKwMRIdk0QVLY+WpRP+WWi/Fb9s+nVleWkSgOb6ypst2rL0bNRGOr
4Xc/ouDNjDm1enrcWbxoeMSffYGc3WcpJ1D/mkAQrE+t2ElTAR8R+YHh5uWTsdzU
OzdNbHsqQDJEMEsU7L/oDFKhhAuK7oOSPBZx90X8QI/C3+XJypo=
=wXYz
-----END PGP SIGNATURE-----

--c4XJuQpPXESUwDMB--
