From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/3] cpuset: Allow setscheduler regardless of manipulated
 task
Date: Thu, 29 Jun 2023 14:26:31 +0200
Message-ID: <4fowzgkh7yo5ku2fsrptyi7jzikynjtq4zpfcx7k26vk4k6zj3@ubnupp5jqgle>
References: <20230629091146.28801-1-mkoutny@suse.com>
 <20230629091146.28801-2-mkoutny@suse.com>
 <15c607d9-c1fa-ca11-d675-8f2b3a6fd15b@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rblx2idammiw6ntz"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1688041592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wC2m3Yx3psKkEPLlun+ONLgR44D7q3seUbrUL2S3T30=;
        b=ZyZqr+cHIpkjvoD03dDSgbCDBElpsaWtwxFW05ulVIk2gwfLFWUUD/kMkVJ+Z2klCfYTol
        awCaBz7pOLURmVdQCBleNV4SQ2MLu1YT635FsDtY54RcGs8Z6WWBpSSqAeC5qiHL+Bt+PT
        m2fXD2pRIfLjACuOVSVmECXejka9U5A=
Content-Disposition: inline
In-Reply-To: <15c607d9-c1fa-ca11-d675-8f2b3a6fd15b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


--rblx2idammiw6ntz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 29, 2023 at 08:11:33AM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> So I think you should just use
> cgroup_subsys_on_dfl(cpuset_cgrp_subsys) as the v2 check if your focus
> is just to prevent problem when enabling cpuset controller.

I thought the bare cgroup_subsys_on_dfl(cpuset_cgrp_subsys) is not used
in cpuset.c but I was wrong -- yes, I'll change this.

> This change will likely conflict with the latest cpuset change on trackin=
g #
> of dl tasks in a cpuset. You will have to, at least, move the dl task che=
ck
> before the security_task_setscheduler() check.
>=20
> Another fact about cpuset controller enabling is that both cpus_allowed a=
nd
> mems_allowed are empty at that point. You may also add these checks as a
> preconditions for disabling the security_task_setscheduler check.

Ah, I will rebase on fresh mainline (or do you mean another reference?).

Thanks for the hints,
Michal

--rblx2idammiw6ntz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZJ14dQAKCRAGvrMr/1gc
jgWhAQCg5qoiDOfhNkRuhbqMER6ksJi/9R3UMnsTyDByQxNHcgD9Hxgyt1VPPcbL
NtdTozyc/W59t7siU73cfznURZII+Qk=
=E0Xs
-----END PGP SIGNATURE-----

--rblx2idammiw6ntz--
