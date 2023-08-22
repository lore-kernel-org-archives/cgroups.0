From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH 0/3] memcg: non-unified flushing for userspace stats
Date: Tue, 22 Aug 2023 15:00:55 +0200
Message-ID: <a4opjlmm5it3ujoypcgjfljfamjvr7gu34sc7lrjldfbqzz4lj@6w4lqdcfd3zu>
References: <20230821205458.1764662-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rsgiuzyi263iyyyh"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1692709257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OAbqRGEAHu7Ri1BEFwHTiMJqbULQ9AggcksOng91Am0=;
        b=cvqkpboFbqEuoqpJwUDKKnH2hSxO9sIKRD0OoHN68lpKaWPMvn6sYj3+y0FrVNkubvdd7y
        fhRZvkxdGrVB+2klXgVvUwuoxPBUH8NGm3GOyNzDLkZAbcqa6o+Bcu80dpJ1LGXUdWbeAr
        YktZZL9KkXW/Gqnkv6S94Mwwu6RQorc=
Content-Disposition: inline
In-Reply-To: <20230821205458.1764662-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


--rsgiuzyi263iyyyh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Mon, Aug 21, 2023 at 08:54:55PM +0000, Yosry Ahmed <yosryahmed@google.com> wrote:
> For userspace reads, unified flushing leads to non-deterministic stats
> staleness and reading cost.

I only skimed previous threads but I don't remember if it was resolved:
a) periodic flushing was too much spaced for user space readers (i.e. 2s
   delay is too much [1]),
b) periodic flushing didn't catch up (i.e. full tree flush can
   occassionaly take more than 2s) leading to extra staleness?

[1] Assuming that nr_cpus*MEMCG_CHARGE_BATCH error bound is also too
    much for userspace readers, correct?

> The cost of userspace reads are now determinstic, and depend on the
> size of the subtree being read. This should fix both the *sometimes*
> expensive reads (due to flushing the entire tree) and occasional
> staless (due to skipping flushing).

This is nice, thanks to the atomic removal in the commit 0a2dc6ac3329
("cgroup: remove cgroup_rstat_flush_atomic()"). I think the smaller
chunks with yielding could be universally better (last words :-).

Thanks,
Michal


--rsgiuzyi263iyyyh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZOSxhQAKCRAGvrMr/1gc
jql9AP416SvKn+uj/hrokt/s6nOdeQdWlzpvkkf2UKZg17whHgD/SdSKRx0jIIbq
nqT/QXyO3EYKtOWfLu6jR/PVNXm4+A8=
=/E7c
-----END PGP SIGNATURE-----

--rsgiuzyi263iyyyh--
