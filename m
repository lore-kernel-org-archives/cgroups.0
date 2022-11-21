From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup/cpuset: Optimize cpuset_attach() on v2
Date: Mon, 21 Nov 2022 19:50:42 +0100
Message-ID: <20221121185042.GA15225@blackbody.suse.cz>
References: <20221112221939.1272764-1-longman@redhat.com>
 <20221112221939.1272764-3-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669056643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kOkPtxy1B+aPiwWUMn6zq0m1QzdZL/48YTvASqRGnL4=;
        b=eWMES88FsBzrH40LiK+qYy1lxRyYmEbH8g8dpl52Ug6pzifOHVL20SZLjKE2E6+eGQlmQq
        0SPeOxmtxbUghhnfMAFejUqhU2tnuReqkc/p/TwqTbR1ON2k0YK3Fv2aPRmcUvuLGo6Egc
        3ToqnD7s5N+41BcgKlBBW/cdlMD2+vs=
Content-Disposition: inline
In-Reply-To: <20221112221939.1272764-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 12, 2022 at 05:19:39PM -0500, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> +	/*
> +	 * In the default hierarchy, enabling cpuset in the child cgroups
> +	 * will trigger a number of cpuset_attach() calls with no change
> +	 * in effective cpus and mems. In that case, we can optimize out
> +	 * by skipping the task iteration and update.
> +	 */
> +	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
> +	    !cpus_updated && !mems_updated) {

I'm just wondering -- why is this limited to the default hierarchy only?
IOW why can't v1 skip too (when favorable constness between cpusets).

Thanks,
Michal

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY3vIfwAKCRAkDQmsBEOq
ueSvAQCyC6t+4Kgc9Ku5M0Twd+wYTQLyFcMCodNhZGs2DG56GQEA96Cg26FgHBCF
4fx2Ow2jpg02roncB1d72afOmf7dwwc=
=Py+0
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
