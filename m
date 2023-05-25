From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH] blk-cgroup: Flush stats before releasing blkcg_gq
Date: Thu, 25 May 2023 16:11:50 +0200
Message-ID: <3ej42djuuzwx36yf2yeo5ggyrvogeaguos5jtve2bvuaejnwff@fak3yjwe2fbi>
References: <20230524011935.719659-1-ming.lei@redhat.com>
 <CAJD7tkZkbro4H-QC=RJx_dfCdGQ5c=4NJhbFrcEmQSidaaMOmg@mail.gmail.com>
 <ZG14VnHl20lt9jLc@ovpn-8-17.pek2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yw4zsdelcidbb6wx"
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1685023912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s2JH6pTYcJePjQtM79Iqz39SbWKAXK4Qz2x1GSVTfLY=;
        b=RGyV9NO3PzYGEcee4AtXtXB1xO4jeCtqPc89Ldtc0+jxV2LTOn8SQ2TVpUKhPg82a72hSf
        YbPYy5G/nF0nG2sLTc/iU8w/kbOdF8XcQEeWGzx+nvYujx9CrkrQOgXNaZVwM/7RqJZIQQ
        djbtpQ6hb7F/xxxVsfTH6VBOufQttEQ=
Content-Disposition: inline
In-Reply-To: <ZG14VnHl20lt9jLc@ovpn-8-17.pek2.redhat.com>
List-ID: <cgroups.vger.kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Linux-MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>


--yw4zsdelcidbb6wx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 24, 2023 at 10:37:10AM +0800, Ming Lei <ming.lei@redhat.com> wr=
ote:
> > I am not at all familiar with blkcg, but does calling
> > cgroup_rstat_flush() in offline_css() fix the problem?
>=20
> Except for offline, this list needs to be flushed after the associated di=
sk
> is deleted.

Why the second flush trigger?
a) To break another ref-dependency cycle (like on the blkcg side)?
b) To avoid stale data upon device removal?

(Because b) should be unnecessary, a future reader would flush when
needed.)

Thanks,
Michal

--yw4zsdelcidbb6wx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZG9spAAKCRAkDQmsBEOq
ufTLAP9NX8DIiij6/hpnoy9/M+nnSBemEZ9lY1LODUguhjSJrAEA5g8mQPrBr8KR
A7VHGk9AX3B3eIPAFYavVz4cMoIrYwE=
=56eg
-----END PGP SIGNATURE-----

--yw4zsdelcidbb6wx--
