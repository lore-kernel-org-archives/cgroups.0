From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 3/4] mm: memcg: let non-unified root stats flushes
 help unified flushes
Date: Tue, 5 Sep 2023 16:10:10 +0200
Message-ID: <hrpw2bjsrs3pzxympb7cz4nohyeztnxkmdtzbzlfdba6ugkken@dhcdbbbrv4fn>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-4-yosryahmed@google.com>
 <ZPXupwjewuLgksAI@dhcp22.suse.cz>
 <6tne52ip62ucev7nmnim3m7fhcydnwcytyxynrlxxgaf4cbqea@r4hec425izap>
 <ZPX6luPGqypp68+L@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5xl6u4xlnnymxuii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693923011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UfXW8hhd1XlJUbKT2y+Z8z/xpNcq0SYP8MPtpS/4cLs=;
        b=GsWx/gC+utWM4y3FM5UmDf/N2Yi6LqI1Q+E9qdDmspRlfhrmUO1gLMTtaIHxDWpCFfk9mn
        WkMV+6NSQv+LHG1vE2yUVWJfqytQfDGh4nbNWuHnn7DYijpnglIxeGrjCJF9SBLXDBAuYj
        qqDr8WTCv+a0GQ8kG0G1vHstZ++C+vw=
Content-Disposition: inline
In-Reply-To: <ZPX6luPGqypp68+L-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--5xl6u4xlnnymxuii
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 04, 2023 at 05:41:10PM +0200, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wr=
ote:
> So it also creates an undocumented but userspace visible behavior.
> Something that userspace might start depending on, right?

Yes but -
- depending on undocumented behavior is a mistake,
- breaking the dependency would manifest (in the case I imagine) as a
  performance regression (and if there are some users, the future can
  allow them configuring periodic kernel flush to compensate for that).

Or do you suggest these effects should be documented (that would require
deeper analysis of the actual effect)?=20


Thanks,
Michal

--5xl6u4xlnnymxuii
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZPc2wAAKCRAGvrMr/1gc
jlxaAP46l8gRlfACegKealpEqf4LldUZ6wJpB4fTVFaOGIrwtgD8C5FMCJxGkTXl
1GdDHiGP3h6e0MohvE8iIjMLkW8eyQk=
=yjdi
-----END PGP SIGNATURE-----

--5xl6u4xlnnymxuii--
