From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: update parent subparts cpumask while
 holding css refcnt
Date: Mon, 10 Jul 2023 17:51:24 +0200
Message-ID: <ag6ed2ebb3azrienshnvn775ejp6jsftx66we7mwcavv74q4s7@xm5djhor7bjl>
References: <20230701065049.1758266-1-linmiaohe@huawei.com>
 <fbabnjfly5w6fxrhe3eu6ebspngz2hd3tqs6rrbropcdvylnhs@ayjdpq73kwui>
 <74f1906e-fe58-c745-a851-b160374f7acf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ktauyloq4o6i5icy"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1689004285; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o3Yl6KJ5iaf9hnfCzXQRl84Iaqux0AkHxDIFY4RqjNw=;
        b=RZVYDWZ3/urg8+OJrIGYGpUrF751dlFkNaykpkxGQn+RqXVDGewk43zN/vQ2i0TKnuoxE/
        s7uQLUU69qyMXv11RQzR4bprnARgyqFrYmMNWSbM1NRZ3Q442UZgzD6NFe5dgPpxB63CnK
        wdVjoFlpxkXACX6TRNmKaO0oBArtHfg=
Content-Disposition: inline
In-Reply-To: <74f1906e-fe58-c745-a851-b160374f7acf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--ktauyloq4o6i5icy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 10, 2023 at 11:40:36AM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> I believe the primary reason is because update_parent_subparts_cpumask() can
> potential run for quite a while. So we don't want to hold the rcu_read_lock
> for too long.

But holding cpuset_mutex is even worse than rcu_read_lock()? IOW is the
relieve with this reason worth it?

> There may also be a potential that schedule() may be called.

Do you mean the spinlocks with PREEMPT_RT or anything else? (That seems
like the actual reason IIUC.)

Thanks,
Michal

--ktauyloq4o6i5icy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZKwo+gAKCRAGvrMr/1gc
jvoTAQDxUP5rRDvddw1/LeVeB6ciZXYjqioRtToDzNWdWiOIFAEAi10plOPMMm5q
0JhePeVrhp89P6ZsW9Vqi4y25ZY1mA4=
=qaQM
-----END PGP SIGNATURE-----

--ktauyloq4o6i5icy--
