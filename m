From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: cgroup: Clarification around usage_in_bytes and its relation to
 the page counter
Date: Tue, 2 May 2023 19:44:57 +0200
Message-ID: <p37th7kmkn3njp6nuu22qi5vnse3mdhlqen4wlk3ps26bdaujd@prgdu3vtm47y>
References: <CAAKLMZ1fM1d4Drw0D2AkEwAG9iFOyT9qboy1REWtwS6Q00BA6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="32lmaltfn23dhzgl"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683049499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MgLp4vIr0EtQova6tp/E9AbDg/ZxYjK50xAdJLTkr8o=;
        b=W66VaMlPsdg7qRR+/IjaOJTeNwxv1vMoKD8HyGhhnW4wrsOVBZ487iYDyvOIPhdoHgH9Hm
        8RB2Cnn2eU6iapC8fKjJM4AUsjeeKvGJWyD8qQ5HLDlKart23CaVomHZ5j28XszssBqbW6
        DD6fZk6sFljHjHnzkpoQX/rZy+PMziA=
Content-Disposition: inline
In-Reply-To: <CAAKLMZ1fM1d4Drw0D2AkEwAG9iFOyT9qboy1REWtwS6Q00BA6Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Michael Honaker <mchonaker-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--32lmaltfn23dhzgl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Michael.

On Wed, Apr 12, 2023 at 09:22:07PM -0400, Michael Honaker <mchonaker-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I have been trying to get an accurate measurement of memory usage of a
> non-root cgroup, specifically a Kubernetes container,

Beware that containers are more or less based on sharing resources,
shared accounting is difficult and hence _accurate_ measurement may not
be available or the numbers need some amount of interpretation.

> and noticed some inconsistencies when comparing the value of
> `memory.usage_in_bytes` with the information in `memory.stat`. After
> further investigation of the cgroup docs
> (/admin-guide/cgroups/memory.rst#usage_in_bytes) and an old LMKL
> thread ("real meaning of memory.usage_in_bytes"),

[OT: I suggest you move to cgroup v2, the entities are IMO better named
and it's also more futureproof ;-)]

> I came to the understanding that `usage_in_bytes` actually shows the
> value of the resource counter which is an overestimation due to the
> counter being split into per-cpu chunks for caching,

I didn't read the thread but it's true that per-cpu batching may result
in an error (both signs in theory). Since around v5.13 the
implementation changed and error should be better:
O(nr_cpus * nr_cgroups(subtree) * MEMCG_CHARGE_BATCH) -> O(nr_cpus * MEMCG_CHARGE_BATCH).

> and that the real usage can be calculated from RSS+Cache gathered from
> `memory.stat`.  I've created cadvisor issue #3286
> (https://github.com/google/cadvisor/issues/3286) which goes into
> greater detail on my investigation with examples.

The difference that you spot there is not caused (merely) by the per-cpu
optimization.
What you see as the difference is mainly kernel memory (e.g. dentries,
inodes, task_struct,...) -- RSS+Cache would only show memory that
userspace is directly responsible for but not the kernel structures
(whose size depends on kernel implementation afterall).

(On v2, you could see breakdown of the kernel memory usage besides
others in memory.stat.)

> Is the above understanding still correct with the new page counters?
> If so, could any memory allocations be reflected in `usage_in_bytes`
> but not in `stat` for child cgroups? I want to ensure I'm not
> missing anything by only monitoring the `stat` file.

I hope the abve sheds some light on these questions.

Michal

--32lmaltfn23dhzgl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZFFMFgAKCRAkDQmsBEOq
uW7sAP93XpdrwS/ZlcnjTUBXiArOSqPj3IhP2i88OpLg4ZvXwgEAn+XPgGGv+hWQ
wWxCTQjSrPbSD9acugPheEOKr/razQM=
=s6ba
-----END PGP SIGNATURE-----

--32lmaltfn23dhzgl--
