From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/3] cpuset: Allow setscheduler regardless of manipulated
 task
Date: Fri, 30 Jun 2023 20:42:51 +0200
Message-ID: <qmxqf4cnt4ajt7y43vmy7xjf7mgljnq4gxqkiqdmaadrcq4lfx@f4kxwy5wygvm>
References: <20230629091146.28801-1-mkoutny@suse.com>
 <20230629091146.28801-2-mkoutny@suse.com>
 <15c607d9-c1fa-ca11-d675-8f2b3a6fd15b@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="v3oci5sln533st5v"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1688150572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hzP6++sspeiMJGly5/GKvnU83DNQrkePv6Ujpx4JBFo=;
        b=WzwMOUZ7URL2pshBLAbrR5Eb1snRRrtSTCfPeViixI6CoyWR3brJj+Opy8GY3af3RexoqS
        QBRbdHfDEjAv47pVfxR/ZLVfOcteQydj6yXqtbF8EHg4iVioohn/g7MPxHxp/GqDb9Bwz/
        4ZK6Zr+Q+n15blaSHPLRsoHSPyG0mY4=
Content-Disposition: inline
In-Reply-To: <15c607d9-c1fa-ca11-d675-8f2b3a6fd15b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


--v3oci5sln533st5v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 29, 2023 at 08:11:33AM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Another fact about cpuset controller enabling is that both cpus_allowed and
> mems_allowed are empty at that point. You may also add these checks as a
> preconditions for disabling the security_task_setscheduler check.

I considered relying on that, however, there is more generic case when
migrating between two sibling that should be allowed in v2 too.
See the added test_cpuset_perms_object(). (Admittedly, it doesn't stress
the case when the two siblings had different CPUs but it could.)

Anyway, let's move on to v2 (where I addressed remaining comments).

Thanks,
Michal

--v3oci5sln533st5v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZJ8iKAAKCRAGvrMr/1gc
jsKlAP9Aq4WN+NlTiUnIUf8PeXwyJiCKLc3wgk3m+bILYfDpZgD7B4/zkWylYWB9
ySZ09DxxEk78SmXA9ZCPzwHdr/SkQAU=
=b3pu
-----END PGP SIGNATURE-----

--v3oci5sln533st5v--
