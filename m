From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 3/6] cgroup/cpuset: Add a new isolated cpus.partition
 type
Date: Thu, 24 Jun 2021 14:51:41 +0200
Message-ID: <YNR/3fydXvAi3OsN@blackbook>
References: <20210621184924.27493-1-longman@redhat.com>
 <20210621184924.27493-4-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7y/hTF6KceCxU12n"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624539102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OStIT+/k9HjAMVEft/RiVSrSrqRUKVMppJc/bLZhAsc=;
        b=h1TVxq0gwwlLbYqvb8tWbr/SwshfATjxvexZQDFL2biMzuzXxMfRnglO5nSJ12QdFh3lZZ
        FArNIcJjJMRUX5Blw8IDk3onyywNZfB2DYPVTIBceONow2v4WnuszUCeCPzCtPz99jrNKs
        yidy5cAz7L/uV6PBm7+zmb9Z1OtOTTM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624539102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OStIT+/k9HjAMVEft/RiVSrSrqRUKVMppJc/bLZhAsc=;
        b=h1TVxq0gwwlLbYqvb8tWbr/SwshfATjxvexZQDFL2biMzuzXxMfRnglO5nSJ12QdFh3lZZ
        FArNIcJjJMRUX5Blw8IDk3onyywNZfB2DYPVTIBceONow2v4WnuszUCeCPzCtPz99jrNKs
        yidy5cAz7L/uV6PBm7+zmb9Z1OtOTTM=
Content-Disposition: inline
In-Reply-To: <20210621184924.27493-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


--7y/hTF6KceCxU12n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Mon, Jun 21, 2021 at 02:49:21PM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>     cgroup/cpuset: Add a new isolated cpus.partition type
>=20
>     Cpuset v1 uses the sched_load_balance control file to determine if lo=
ad
>     balancing should be enabled.  Cpuset v2 gets rid of sched_load_balance
>     as its use may require disabling load balancing at cgroup root.
>=20
>     For workloads that require very low latency like DPDK, the latency
>     jitters caused by periodic load balancing may exceed the desired
>     latency limit.
>=20
>     When cpuset v2 is in use, the only way to avoid this latency cost is =
to
>     use the "isolcpus=3D" kernel boot option to isolate a set of CPUs. Af=
ter
>     the kernel boot, however, there is no way to add or remove CPUs from
>     this isolated set. For workloads that are more dynamic in nature, that
>     means users have to provision enough CPUs for the worst case situation
>     resulting in excess idle CPUs.
>=20
>     To address this issue for cpuset v2, a new cpuset.cpus.partition type
>     "isolated" is added which allows the creation of a cpuset partition
>     without load balancing. This will allow system administrators to
>     dynamically adjust the size of isolated partition to the current need
>     of the workload without rebooting the system.

I like this work.
Would it be worth generalizing the API to be on par with what isolcpus=3D
can configure? (I.e. not only load balancing but the other dimensions of
isolation (like the flags nohz and managed_irq now).)

I don't know if all such behaviors could be implemented dynamically
(likely not easy) but the API could initially implement just what you do
here with the "isolated" partition type.

The variant I'm thinking of would keep just the "root" and "member"
partitions type and the "root" type could be additionally configured via
cpuset.cpus.partition.flags (for example).

WDYT?

Michal

--7y/hTF6KceCxU12n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmDUf9gACgkQia1+riC5
qSgrew/9Hq4FG5rOCmGFt93pb5UT4E9slWA9EWdsCCpq97TsB9YXl8KsEYana9aP
4ZCRW2ySHqn0LpjKlgbYruhXX9IICNAOr6KHHKW8RgKTPnBHsXpwuhQhDJdDLQ54
U1DGX+WfTTuTFM8dO2VJcdSHl3c/7xxr1L5rp9Z3Soetzp219w6p/SE3WDZYW1Q1
ur+Yq/Fjl6x8YU/7U1c18sHP1H7xTw9yC94NxZ/gwhyJzxxR8LDWTvTr9ZJcN2qP
ywzJbuhH6dcZrAJUYbR990SryS1mDDD8nZx5iZJC005oR4m5Ce7kahU/lmv5Oe0n
TCgPjA0idwjXED3pCeARRVdl6nuFmi+hXO9SV9HpLwoDVTWF2F2g6wb49g2tkIwK
0BNtpYv2F0Mg0hmY3wCJH5IDBMkJemNgCUj+SRlwngJgYRbNcUvLmCloapbFLsC+
3JziiJqkeOhlAIfpMYHsEXV0OHDkYLuHsf5cZ/We2qFoY955niGZti9EE+rMfh0V
DNMwk7vmSSCffEFOzwP0cwGiyF6AC83JgX3eEpPAfArt+4CReEYi6r0gmdD8VYUG
8ezyxEa9/zVgARjzB5U7/7r2OSquhmEg/uKhRs/XqeFP53MyAaJnPWIEXehyIsXL
SgRvceYyw+U0Pvm/oYplJF8VLNIadWNzMOK9yqQCnNx6y9ogShU=
=SVZh
-----END PGP SIGNATURE-----

--7y/hTF6KceCxU12n--
