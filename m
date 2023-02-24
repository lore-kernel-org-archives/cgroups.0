From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v12 6/8] sched/fair: Add sched group latency support
Date: Fri, 24 Feb 2023 20:29:19 +0100
Message-ID: <20230224192919.d4fcde3dwh7betvm@blackpad>
References: <20230224093454.956298-1-vincent.guittot@linaro.org>
 <20230224093454.956298-7-vincent.guittot@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ach44qdpkbnxkdxs"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677266961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hnAMd8q05Oc+Az6aeyniIup+x2AJU5/PdX1pnOCHdJs=;
        b=cU2tCFgRPQYdnsnpsRf1Poa8TL/3C6O/oI0EPZZp19/BGEaSu17O+F+NHq4lp5ZzRzaTFk
        l9v2ieikO/5p3NfDdJjrp5yebQEsFutRZScsHqlaF6k22o+0Y2ViWpvl58eZRdowV/Lk7f
        0aW3Ztv9IcFZWs9dVMz+WqQOZ93Du6A=
Content-Disposition: inline
In-Reply-To: <20230224093454.956298-7-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org


--ach44qdpkbnxkdxs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Vincent.

On Fri, Feb 24, 2023 at 10:34:52AM +0100, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> +  cpu.latency.nice
> +	A read-write single value file which exists on non-root
> +	cgroups.  The default is "0".
> +
> +	The nice value is in the range [-20, 19].
> +
> +	This interface file allows reading and setting latency using the
> +	same values used by sched_setattr(2). The latency_nice of a group is
> +	used to limit the impact of the latency_nice of a task outside the
> +	group.

IIUC, the latency priority is taken into account when deciding between
entitites at the same level (as in pick_next_entity() or
check_preempt_wake()/find_matchig_se()).

So this group attribute is relevant in context of siblings (i.e. like
cpu.weight ~ bandwidth priority)?

I'm thus confused when it's referred to as a limit (in vertical sense).
You somewhat imply that in [1]:

> Regarding the behavior, the rule remains the same that a sched_entity
> attached to a cgroup will not get more (latency in this case) than
> what has been set for the group entity.

But I don't see where such a constraint would be implemented in the
code. (My cursory understanding above tends to horizontal comparisons.)

Could you please hint me which is right?

Thanks,
Michal

[1] https://lore.kernel.org/r/CAKfTPtDu=c-psGnHkoWSPRWoh1Z0VBBfsN++g+krv4B1SJmFjg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/


--ach44qdpkbnxkdxs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY/kQDQAKCRAkDQmsBEOq
ub3oAQDEfOX2TRBsjRsSXpo+vOEyZrjXeyDhQLhjWFuVBg+ULAD5ATvSCYRMEgA2
2bDHVH5lA4uSr/kcxYKHNEp+qw6K5w8=
=bajD
-----END PGP SIGNATURE-----

--ach44qdpkbnxkdxs--
