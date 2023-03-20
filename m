From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 3/4] cgroup/cpuset: Include offline CPUs when tasks'
 cpumasks in top_cpuset are updated
Date: Mon, 20 Mar 2023 16:04:33 +0100
Message-ID: <20230320150433.v3xcl7rqsxz4x6tg@blackpad>
References: <20230317151508.1225282-1-longman@redhat.com>
 <20230317151508.1225282-4-longman@redhat.com>
 <20230317180157.uqlleobldg53pgj6@blackpad>
 <11b5454b-42c7-fb0d-f071-c46712f76f3b@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="g3azguixlje76xpd"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679324675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hwWqYXOi2JWUeQesBva9impsRBcN0SMjROswWsfpc4s=;
        b=r8Ym2XCbihrsxLtFN08w06AOIshHu11IbK2BZr6ABPHC7XQk0y0yK4mY8d81jkGe3H0/Cg
        lsmCJu73Fn24TssqB10M9LUnvuQ3AtCZSk4r3zEmQlIbFacyS0/YKpuAR+VVVD9U66RiN7
        G/cFWEmoCSMmZbkRpEUr1vD4mv0gFA0=
Content-Disposition: inline
In-Reply-To: <11b5454b-42c7-fb0d-f071-c46712f76f3b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


--g3azguixlje76xpd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 17, 2023 at 02:05:32PM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> A cpu will be in the subparts_cpus only if it has been given to the child
> partition. So when it becomes online, it will become part of the scheduling
> domain that child partition. Only the tasks in that child partition will get
> their cpumasks updated to use it, not those in the top cpuset.

Right, it's actually the difference between offlining a CPU and giving it
to a sub-partition (hence a removed child (or switched to member) before
CPU onlining). It's clear to me now.

Thanks,
Michal

--g3azguixlje76xpd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZBh1/wAKCRAkDQmsBEOq
uX3wAQCFD+U7rIP4rxH0pPPjBiVpGL+85S7rzdSIW7hL/H4DaAD/VJF7JKo6+E01
gtBEpTVziKoADESQUhA8DJ2KYUQIlw4=
=n3My
-----END PGP SIGNATURE-----

--g3azguixlje76xpd--
