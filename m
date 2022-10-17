From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC] memcg rstat flushing optimization
Date: Mon, 17 Oct 2022 20:52:38 +0200
Message-ID: <20221017185238.GA7699@blackbody.suse.cz>
References: <CAJD7tkZQ+L5N7FmuBAXcg_2Lgyky7m=fkkBaUChr7ufVMHss=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666032759; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uIg/vWRDzwcg+FnbrRQRZsB7kMPtfjh8GsB556SPdCE=;
        b=opkb3ve0AqetQ24+LxR7h4nCUtfSNEtlQ16c+8jm7TtbDpuPTQc24EklqJhdYisPgtwIq+
        1hzt/V+jP3veWOnLweikP1UqTd6OsekH8QTMgpz1dzxJPs/N0pS1xWl7zohBsLC0rWCfHI
        yVO3G4J3tCyfvLTwQY8zDhjJ1Sp9+wI=
Content-Disposition: inline
In-Reply-To: <CAJD7tkZQ+L5N7FmuBAXcg_2Lgyky7m=fkkBaUChr7ufVMHss=A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Tue, Oct 04, 2022 at 06:17:40PM -0700, Yosry Ahmed <yosryahmed-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m> wrote:
> Sorry for the long email :)

(I'll get to other parts sometime in the future. Sorry for my latency :)

> We have recently ran into a hard lockup on a machine with hundreds of
> CPUs and thousands of memcgs during an rstat flush.
> [...]

I only respond with some remarks to this particular case.


> As you can imagine, with a sufficiently large number of
> memcgs and cpus, a call to mem_cgroup_flush_stats() might be slow, or
> in an extreme case like the one we ran into, cause a hard lockup
> (despite periodically flushing every 4 seconds).

Is this your modification from the upstream value of FLUSH_TIME (that's
every 2 s)?

In the mailthread, you also mention >10s for hard-lockups. That sounds
scary (even with the once per 4 seconds) since with large enough update
tree (and update activity) periodic flush couldn't keep up.
Also, it seems to be kind of bad feedback, the longer a (periodic) flush
takes, the lower is the frequency of them and the more updates may
accumulate. I.e. one spike in update activity can get the system into
a spiral of long flushes that won't recover once the activity doesn't
drop much more.=20

(2nd point should have been about some memcg_check_events() optimization
or THRESHOLDS_EVENTS_TARGET justifying delayed flush but I've found none to=
 be applicable.
Just noting that v2 fortunetly doesn't have the threshold
notifications.)

Regards,
Michal

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY02kdAAKCRAkDQmsBEOq
ucSYAQC1iiT2OoWMBWVeABnkerHapSlZb9R02QB2KaKYuq0IeQEAhZVf5gQ3FK2e
7yTBVL+HCfkrSeToyI19ckXOnIIGBwA=
=s/Rd
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
