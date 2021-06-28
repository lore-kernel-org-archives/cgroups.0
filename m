From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: Prevent inode/dentry trashing?
Date: Mon, 28 Jun 2021 15:30:40 +0200
Message-ID: <YNnPAJ4HNoN6g6T9@blackbook>
References: <ce330972-78e6-4347-9735-72ee7bb21ef5@pmhahn.de>
 <YNX8anv2yCnkVPXy@blackbook>
 <88451906-e537-0ac3-b8f2-16bfc4d77ea6@metux.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="23tDw59TYEHMEItr"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624887042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zyfn/kWlkauY+pHbZcSX9v7/QNEs3F9SnoD6jJx438E=;
        b=KSOivs4rN9bmnqLxszIaB+3+XkCnzZKpu5DMGBLHO+Dr6Db1aFtuUh1+/+HNJ5ILN5qQhw
        rO8UARV6w+8hpVJXv9UsODf3qcM98tmM9lM9gli6ZmNVeffvFPBwCnsp8Uhk8eimicLkXL
        1ta4rcGPmuSUHVKM4UpL+bhEdxW4TPY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624887041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zyfn/kWlkauY+pHbZcSX9v7/QNEs3F9SnoD6jJx438E=;
        b=Uvigr1rGojU5z9c4mfvyFMH+cAQxsvYAV0S8Cm3SiFjHpgI3bNx1I3gPUyqm97wXVSYnlG
        w4JQ9fXf6dOLPDieNJ2WpbvjT8wHaJW28Bjk+7CY33B2Pypp/aa0cWbhD/s3cmKLDGSBw/
        kg+O1+wtWohABmyGy6ToUmd8ypScQwU=
Content-Disposition: inline
In-Reply-To: <88451906-e537-0ac3-b8f2-16bfc4d77ea6-EcKl7qYKIbxeoWH0uzbU5w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: "Enrico Weigelt, metux IT consult" <lkml-EcKl7qYKIbxeoWH0uzbU5w@public.gmane.org>
Cc: Philipp Hahn <pmhahn+lkml-isSyJ6YaLy+zQB+pC5nmwQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


--23tDw59TYEHMEItr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 28, 2021 at 11:40:39AM +0200, "Enrico Weigelt, metux IT consult" <lkml-EcKl7qYKIbxeoWH0uzbU5w@public.gmane.org> wrote:
> Could you please tell a bit more how this really works ?
> (maybe some pointers to the code)

When cgroup's consumption is about to cross the configured limit,
reclaim is started
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/memcontrol.c?id=62fb9874f5da54fdb243003b386128037319b219#n2579

that may evict old entries
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/vmscan.c?id=62fb9874f5da54fdb243003b386128037319b219#n2852

and if there's still no success freeing some space the dentry allocation
can fail
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/slab.h?id=62fb9874f5da54fdb243003b386128037319b219#n277

(This describes just one code path, the subject isn't always a dentry.)

> I'm curios what happens if those cache objects are used by different
> cgroups - are they accounted to multiple times (once per cgroup) ?
> What happens when one cgroup using some cache object reaching its limit,
> wile another one does not ?

That's explained here
https://www.kernel.org/doc/html/v5.13/admin-guide/cgroup-v2.html#memory-ownership

Michal

--23tDw59TYEHMEItr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmDZzv0ACgkQia1+riC5
qSgmvBAAmj9Nu4YOqC+vW3bzkl/j1kAtpQrjZBdeOxRZv4OVMm6twWDtZOPavLXK
5f9YRIDaRjfJGlPInMR+OqHmwhATTlI0kJFEWTzM8Q3P0i548NJRxF/sIb5cSUjV
oI0BBcbNvXLb/O2XWMVmltHNAk9EDD1ivMY8EOKVGJ4mCoAsYMC0QdCgb8CkIcC/
xAok5nosUFy098U2BuTY6hWR9RwZcdto2l/257F2xz/08BIabrrlSpi+nfBvtXTr
c7/sLHN3ewG5TxhxfUGl6iZjgUVCaWMVHsOxad5BXFfqMpGC6eY2H/Ayiokzc/BD
L6/B5GeUndYrEeyu+MV1ZMgvpeh8KasTAVTpTDWPHvC7cLgAxLVT3CHHv7Kssi4U
TQWMny5EREhC2ZzA3UDiE2AnCIqh7xGK/qMmTYyzPwX4SdRfyYbJ4Dk08hPW8doD
nF/Iq3SqdoG7y5Zm+2EKitiEY8YBH3LPo/ZCCC/5KF9DnxVZlgZHFueMCI3JruL+
ZU5EOn7YFRaKrXHqX4p6u4+PpY3H/Q4aElEazoFsGX+fmeMIY43GSXZLbAb+aiRE
qDxuJQjAKfF+7G8nj7ezXV9vFnrm2h8BJLV4/adTA09b5zTteHiAdsPeffoR7rAr
auuQ3Jl2Hzb7gi/BrpQyfJtKjOrP5wDTVs4VBLyvTZVjeReshx8=
=5TgM
-----END PGP SIGNATURE-----

--23tDw59TYEHMEItr--
