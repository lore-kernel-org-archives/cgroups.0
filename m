From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup/cpuset: Make cpuset_fork() handle
 CLONE_INTO_CGROUP properly
Date: Tue, 4 Apr 2023 11:19:53 +0200
Message-ID: <20230404091953.tcu3zg7npstk3ztc@blackpad>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-2-longman@redhat.com>
 <20230403165523.aphsec2epqi72k27@blackpad>
 <d9f0005c-6825-b2a0-eac3-fcbad6e32b2f@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="t44yctniyorb4iao"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680599995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i67LZvndle0FXns2qvwNfT1XOL/ofgh7nRXwodyjXPs=;
        b=Oh3tIDquq5GAp/daRsZLPe8+keWjgn/xo26/bDtxYuh/NyIXC8eUV2ajlDvD5PdX6e3Bxc
        LeWQwHKJ2/4tDCgTl+My4ZLnXLjN4po1o8GhZWAhU+UW6Yq397WVXZdN3DwwLA3IcuWvqN
        CCHm9q+hpAiowzhA58WooTHxjRuiAGo=
Content-Disposition: inline
In-Reply-To: <d9f0005c-6825-b2a0-eac3-fcbad6e32b2f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


--t44yctniyorb4iao
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 03, 2023 at 01:18:42PM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 1) PF_NO_SETAFFINITY flag - which won't be set in the case of fork() as it
> is for kthread only.
> 2) DL bandwidth - Juri has a cpuset outstanding to modify the way this check
> is being done. I want to wait until it is settled before tackling this, if
> necessary.

BTW what about CLONE_INTO_CGROUP where the target cpuset has empty
effective cpuset?

> 3) security_task_setscheduler() - the CLONE_INTO_CGROUP code has already
> checked that, we don't need to duplicate the check.

Not sure what this refers to.

> So we don't need a can_fork() check for now.

Anyway, good breakdown. Could you please add it to the commit message
too?

Regards,
Michal

--t44yctniyorb4iao
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZCvrtQAKCRAkDQmsBEOq
uXeGAQCpgXtPsXDXcfOTHX/nDug4IiTdeZK6ER7w5mOHPkUAxgD/cum39WzeVSGZ
V0835/NthpeochRAaHAX/FNgF63xlAw=
=b803
-----END PGP SIGNATURE-----

--t44yctniyorb4iao--
