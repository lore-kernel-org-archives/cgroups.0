From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/5] cgroup/cpuset: Skip task update if hotplug doesn't
 affect current cpuset
Date: Tue, 14 Mar 2023 17:50:30 +0100
Message-ID: <20230314165030.beu2ywtvqa3p45ta@blackpad>
References: <20230306200849.376804-1-longman@redhat.com>
 <20230306200849.376804-2-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="unrarqlmrlmuhj23"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678812631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6k/rQNu/3JyQ0BkZUFMKmdlCm0FllNjLs/p7eJHqbcg=;
        b=qAycucas010i4uea/GBqMOUweebj+BqtWiQY5kdCyAyeeC5Nq4Jd4YxHpuyx/9ulQeHhxQ
        5ZXX+V+S7NJjDJiPZ52HRgXL4afacwBG2RW/BtBSsdsIaf8n47HyAhXn4eYhv2C4Bvg4y7
        S1ZnBDCq6m40G47JaT0JjlCoN0PL8FY=
Content-Disposition: inline
In-Reply-To: <20230306200849.376804-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>


--unrarqlmrlmuhj23
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 06, 2023 at 03:08:45PM -0500, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> If a hotplug event doesn't affect the current cpuset, there is no point
> to call hotplug_update_tasks() or hotplug_update_tasks_legacy(). So
> just skip it.

This skips "insane" modification of cs->cpus_allowed in
hotplug_update_tasks_legacy() but assuming cs->cpus_allowed is kept in
sync with cs->effective_cpus on v1, it is OK to skip the update based
only on effective_cpus check.

Hence,

>  kernel/cgroup/cpuset.c | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

--unrarqlmrlmuhj23
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZBCl1AAKCRAkDQmsBEOq
ub7vAQDuvydF9uT/t92mbXmbdJFDwYtaoBzZSBR7muvk51dYZAD/VflSkqUiEoJf
DK7RTVV/JCWxbff4B8Ud16JHw7PsfQU=
=Phpc
-----END PGP SIGNATURE-----

--unrarqlmrlmuhj23--
