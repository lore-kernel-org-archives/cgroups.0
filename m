From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup: rstat: Simplified cgroup_base_stat_flush()
 update last_bstat logic
Date: Tue, 23 May 2023 17:14:28 +0200
Message-ID: <5g73i4yvi4ub4dqrf4dnq5qghkyckoygmgd2st6be3gg7twww2@w6zim6nxpt3b>
References: <20230518124142.57644-1-jiahao.os@bytedance.com>
 <f39b9229-e59c-2b1c-7f3f-1aeedfad44dc@bytedance.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wg2kypm56q6zgssf"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1684854870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TkLyPkT+GsXSuBlfsNmALpub2P5cbuZv3uR/8NK1ky0=;
        b=fcrH5ERbBAosvtM3sKUk3hFQzKgQeSkCA4K9SRdafLYsKszWYKAZid+OERHyO74Tz7T82s
        JSUdRkqoJzEk0MGj7qlVteas8OpU4uxXh/zsuaM/Kkkw8G8E2URO+5W8hru2wqxtrggH3Z
        2EF4m4urlnB9MG4mUGJYmbxLqQzgC6Y=
Content-Disposition: inline
In-Reply-To: <f39b9229-e59c-2b1c-7f3f-1aeedfad44dc-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--wg2kypm56q6zgssf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Jia.

On Fri, May 19, 2023 at 12:15:57PM +0800, Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>=
 wrote:
> Maybe something like this?

(Next time please send with a version bump in subject.)


> In cgroup_base_stat_flush() function, {rstatc, cgrp}->last_bstat
> needs to be updated to the current {rstatc, cgrp}->bstat after the
> calculation.
>=20
> For the rstatc->last_bstat case, rstatc->bstat may be updated on other
> cpus during our calculation, resulting in inconsistent rstatc->bstat
> statistics for the two reads. So we use the temporary variable @cur to
> record the read statc->bstat statistics, and use @cur to update
> rstatc->last_bstat.

If a concurrent update happens after sample of bstat was taken for
calculation, it won't be reflected in the flushed result.
But subsequent flush will use the updated bstat and the difference from
last_bstat would account for that concurrent change (and any other
changes between the flushes).

IOW flushing cannot prevent concurrent updates but it will give
eventually consistent (repeated without more updates) results.

> It is better for us to assign directly instead of using
> cgroup_base_stat_add() to update {rstatc, cgrp}->last_bstat.

Or do you mean the copying is faster then arithmetics?

Thanks,
Michal

--wg2kypm56q6zgssf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZGzYUgAKCRAkDQmsBEOq
uW/EAPwMre77h1BOYEzmFLgU5ag4wBzdTwS70cy56P6QTg7dgAEAwdZrK+0lAsgP
xGFhjmxnFKU0VP6MC3rCl/yhKOddwQ8=
=25fp
-----END PGP SIGNATURE-----

--wg2kypm56q6zgssf--
