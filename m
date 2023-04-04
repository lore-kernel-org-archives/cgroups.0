From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 6/8] workingset: memcg: sleep when flushing stats in
 workingset_refault()
Date: Tue, 4 Apr 2023 18:53:05 +0200
Message-ID: <20230404165305.ffs7uscqpndnfytn@blackpad>
References: <20230330191801.1967435-1-yosryahmed@google.com>
 <20230330191801.1967435-7-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qfkseaqkxxqkcz24"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680627186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ll6vzEKQtu1d/iiPFBcw95nX9gIYgOaKMZRWVNUtfkM=;
        b=OnTsPuWsvR8SUopMCtCWMTgT2XxI3U2ix4/z/djlxuJpDe5rTy1vlqUc7rIQ79SwyWU+Ba
        aNQWpCYDuFeaj6SA/BU2bvIIYzm8uWKKX3KtU5qWEj3+h5Nzr/fpy+by5cNlp77YPmMqCo
        FWnVjkGyLQXqBJ8fQCYb63lUO4hLKBw=
Content-Disposition: inline
In-Reply-To: <20230330191801.1967435-7-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>


--qfkseaqkxxqkcz24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 30, 2023 at 07:17:59PM +0000, Yosry Ahmed <yosryahmed-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m> wrote:
> In workingset_refault(), we call
> mem_cgroup_flush_stats_atomic_ratelimited() to read accurate stats
> within an RCU read section and with sleeping disallowed. Move the
> call above the RCU read section to make it non-atomic.
>=20
> Flushing is an expensive operation that scales with the number of cpus
> and the number of cgroups in the system, so avoid doing it atomically
> where possible.

I understand why one does not process the whole flushing load in one go
in general.
However, I remember there were reports of workingset_refault() being
sensitive to latencies (hence the ratelimited call was created).

Is there any consideration on impact of this here?
(Or are there other cond_resched() precendents on this path? Should it
be mentioned like in the vmscan (7/8) commit?)

Thanks,
Michal

--qfkseaqkxxqkcz24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZCxV7gAKCRAkDQmsBEOq
uUD+AQD8wXXi9jmmMAZsQDelWPQkkod/PwIlrMWJ7mxxhDrGEwEAqpLPmU1ZnE0x
eJvubQemadydJAWDGZe8mox2qJ3iLAY=
=AwCK
-----END PGP SIGNATURE-----

--qfkseaqkxxqkcz24--
