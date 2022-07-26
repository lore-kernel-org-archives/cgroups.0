From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/3 cgroup/for-5.20] cgroup: Add "no" prefixed mount
 options
Date: Tue, 26 Jul 2022 16:32:46 +0200
Message-ID: <20220726143246.GA23794@blackbody.suse.cz>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1658845967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lsmx+z/oBusYDzp7fU39ROvdgKcbPo4y7ckSVswOWzk=;
        b=HxBBAsWtFVAyfycssrnjYDTMniIYsSROXdSpEs3X/jBvj9faRaiOA75LODa8RZ9dziGpIj
        Zvi1yqZfuf6AIi+GvxTE+Qrtprr3yURaJWVDd30dBiKOPQcdG6tAx+VVeXe4my2RGo4N6f
        sKxTTspWLeEzTjxEM90jJfWI8vR8nK8=
Content-Disposition: inline
In-Reply-To: <YtDvU4jRPSsarcNp-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 14, 2022 at 06:38:43PM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> We allow modifying these mount options via remount. Let's add "no" prefixed
> variants so that they can be turned off too.

They can be turned off:

> // on v5.19-rc?
> :~ # grep cg /proc/mounts
> cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate 0 0
> :~ # mount -t cgroup2 cgroup2 /sys/fs/cgroup/ -oremount
> :~ # grep cg /proc/mounts
> cgroup2 /sys/fs/cgroup cgroup2 rw,relatime 0 0

The mount(2) says about remounting:
> The  mountflags  and  data  arguments should match the values used in
> the original mount() call, except for those parameters that are being
> deliberately changed.

Or is this a provision for the fsconfig(2) API?

> +	fsparam_flag("memory_nolocalevents",	Opt_memory_nolocalevents),
> +	fsparam_flag("memory_norecursiveprot",	Opt_memory_norecursiveprot),

These are not 'no' prefixes of the option :-)

I.e. it seem more consistent to prefix whole boolean option name (in
accordance with other FS options but I know limited subset of them).
In the end, this should be handled generically for boolean options in
the VFS and not via custom options.

Also, this allows both
	'nsdelegate,nonsdelegate'
and
	'nonsdelegate,nsdelegate'
(nsdelegate is just an example) where the 'no' always overrides being a
hidden implementation detail.

I find this patch a bit weird.


Thanks,
Michal

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYt/7CwAKCRAkDQmsBEOq
uV3mAQCItCNZ+qgk+YsiePoYjqY2EogjCLrFfuM3E5vqQkJKuAD/Zz/xId+puHZe
b3vUeGdCg/W5RERU4NX0miYjHXAv6gA=
=F2ZO
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
