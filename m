From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/3 cgroup/for-5.20] cgroup: Elide write-locking
 threadgroup_rwsem when updating csses on an empty subtree
Date: Tue, 26 Jul 2022 16:31:56 +0200
Message-ID: <20220726143156.GA14370@blackbody.suse.cz>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1658845918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3bsbGkr+ml3ccu5dQDVYwxJTp4j0IzVNFei719oDR5g=;
        b=STBJKCutDeRpcV4piN3dyy6Q7s+/PZX/QfVLGhYZGPG/3K5mGwgF5D6Qgmr8Lqyp7B9MLp
        XZnivzHP6JzcJkMqM+lNYANR4ZblsmElZxeIlorLvwjEcq0phL02P+zBf0qtagFOo0NDIA
        76C370KAMi/SpSKUDQlogfZj6DS5DQ4=
Content-Disposition: inline
In-Reply-To: <YtDvN0wJ6CKaEPN8-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Thu, Jul 14, 2022 at 06:38:15PM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> However, if the subtree doesn't contain any tasks, there aren't gonna
> be any cgroup migrations.

Nice catch.

> This condition can be trivially detected by testing whether
> mgctx.preloaded_src_csets is empty. Elide write-locking
> threadgroup_rwsem if the subtree is empty.

This check is perhaps even more robust than, e.g. cgroup_is_populated()
due to possible zombie cases.

>  kernel/cgroup/cgroup.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYt/6twAKCRAkDQmsBEOq
ubXRAQD90uqCtIlSRrYwhHsL3H1Goqr3zq/aW3zZtjBIDp5HWQD/c2FILXRb5yDW
GMTSvPlWlLg8Q8IgL0Exn+tuoQwgDwM=
=yafZ
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
