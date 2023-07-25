From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] kernfs: attach uuid for every kernfs and report it in
 fsid
Date: Tue, 25 Jul 2023 16:07:17 +0200
Message-ID: <jy7ktvlb4tkg6pl2vll6u4gozfji7giddyseypj4w2d2ue4gvn@4tw7dmjy4hfv>
References: <20230710183338.58531-1-ivan@cloudflare.com>
 <2023071039-negate-stalemate-6987@gregkh>
 <CABWYdi39+TJd1qV3nWs_eYc7XMC0RvxG22ihfq7rzuPaNvn1cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7ajxxoxppngon7fy"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1690294038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J8/twdbVnVALjyy6alnaVgEL7SCtymIvo2fO0lAEw1A=;
        b=qtdc/DbznROvVm5FX3MMqXZU8IO/sm1dnPWwStcgf8XhwngPg/8F36cKRQCxhatKSPIlfZ
        +CDxXTnNzaFH/1RRe2u/5bP+Smx254C82UsNjI329f/rkl9GaBWT0AsChmjpADwDrINbLo
        F78flZYtWWIeNSgv/oDehdNdvzioFhk=
Content-Disposition: inline
In-Reply-To: <CABWYdi39+TJd1qV3nWs_eYc7XMC0RvxG22ihfq7rzuPaNvn1cQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>


--7ajxxoxppngon7fy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Mon, Jul 10, 2023 at 02:21:10PM -0700, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>=
 wrote:
> I want to monitor cgroup changes, so that I can have an up to date map
> of inode -> cgroup path, so that I can resolve the value returned from
> bpf_get_current_cgroup_id() into something that a human can easily
> grasp (think system.slice/nginx.service).

Have you considered cgroup_path_from_kernfs_id()?

> Currently I do a full sweep to build a map, which doesn't work if a
> cgroup is short lived, as it just disappears before I can resolve it.
> Unfortunately, systemd recycles cgroups on restart, changing inode
> number, so this is a very real issue.

So, a historical map of cgroup id -> path is also useful for you, right?
(IOW, cgroup_path_from_kernfs_id() is possible but it'd inflate log
buffer size if full paths were stored instead of ids.)

(I think a similar map would be beneficial for SCM_CGROUP [1] idea too.)


> There's also this old wiki page from systemd:
>=20
> * https://freedesktop.org/wiki/Software/systemd/Optimizations

The page also states:

> Last edited Sat 18 May 2013 08:20:38 AM UTC

Emptiness notifications via release_agent are so 2016 :-), unified
hiearchy has more convenient API [2], this is FTR.


My 0.02=E2=82=AC,
Michal

[1] https://uapi-group.org/kernel-features/
[2] https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html?#un-p=
opulated-notification


--7ajxxoxppngon7fy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZL/XEgAKCRAGvrMr/1gc
jnObAQCJ3C0hDVOfZEzkb1UOgnA4h3h266lsMaQDV8ICV1nHDQEAwyoY1QBjJ5E0
NgxyIDgfAir+2Th7xhf/1vF56yIvUA4=
=a7jr
-----END PGP SIGNATURE-----

--7ajxxoxppngon7fy--
