From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: memcg: add a helper for non-unified stats
 flushing
Date: Tue, 22 Aug 2023 15:01:01 +0200
Message-ID: <y7vvyndehadwy5ouounm5oyo52bqhsysiizuphzki2h3bwpdpc@3hvaq6sp6f4k>
References: <20230821205458.1764662-1-yosryahmed@google.com>
 <20230821205458.1764662-3-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nkqic6iypcnygsam"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1692709263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nPC9oXTPWIOvWWqbloyF9hpx3Cia2d5N+O5LkxGdFhc=;
        b=BSDgSSZyu2C+dtWRJVdM6RBEYpTsn5ecB93MOzrEO0y4G8bQ1lk/06vcv0UhQeGeSwo6ph
        AhtGAT4BNUtYS1CUT/E1rW1SiHS4RgTgDxzcU5pLf/jq337dypvzCNbK8Xe4QWXlzqDXSg
        SNyg4lfKK56Xuo6ORmPYg3KFZA3BxsY=
Content-Disposition: inline
In-Reply-To: <20230821205458.1764662-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--nkqic6iypcnygsam
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 21, 2023 at 08:54:57PM +0000, Yosry Ahmed <yosryahmed-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m> wrote:
> +static void do_stats_flush(struct mem_cgroup *memcg)
> +{
> +	cgroup_rstat_flush(memcg->css.cgroup);
	if(memcg =3D=3D root_mem_cgroup)
		atomic_set(&stats_flush_threshold, 0);
> +}
> +
>  /*
>   * do_unified_stats_flush - do a unified flush of memory cgroup statisti=
cs
>   *
> @@ -656,7 +667,7 @@ static void do_unified_stats_flush(void)
> =20
>  	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
> =20
> -	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
> +	do_stats_flush(root_mem_cgroup);
> =20
  -	atomic_set(&stats_flush_threshold, 0);
>  	atomic_set(&stats_flush_ongoing, 0);

You may reset stats_flush_threshold to save the unified flushers some
work.

Michal


--nkqic6iypcnygsam
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZOSxiwAKCRAGvrMr/1gc
jm71AQCt7WNfujH/Pjh8YjVKcytjG329tBz6ofp30cTENZIrxQD7BQe9CMXaQ46H
Ryr2cNLw9Zi0Z5DRW4nF1r5TaJyJ3Ac=
=k+uV
-----END PGP SIGNATURE-----

--nkqic6iypcnygsam--
