From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 3/4] cgroup/cpuset: Include offline CPUs when tasks'
 cpumasks in top_cpuset are updated
Date: Fri, 17 Mar 2023 19:01:57 +0100
Message-ID: <20230317180157.uqlleobldg53pgj6@blackpad>
References: <20230317151508.1225282-1-longman@redhat.com>
 <20230317151508.1225282-4-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="u3ht7kwhkaibaz3y"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679076119; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WTRztahqz2rOmT22cd3MICikvHbnMvBL2SFE1d0xF/k=;
        b=nHJ3DUisVXwoFt+d4sENGkALy6IoVXBFrRHQbK6f7gZyEBjikHruO6aebIRJmR7ThpqKl+
        pVlmQw3G/NfjFekKSnlsuAthfqPaxn9NQzlPmp522sjb2U7MTDQFd/1N7brxvSGJsS3HeM
        OVpvDR8tpZs0nM/1zxIzFbwTeng+ebQ=
Content-Disposition: inline
In-Reply-To: <20230317151508.1225282-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


--u3ht7kwhkaibaz3y
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Fri, Mar 17, 2023 at 11:15:07AM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>   * Iterate through each task of @cs updating its cpus_allowed to the
>   * effective cpuset's.  As this function is called with cpuset_rwsem hel=
d,
> - * cpuset membership stays stable.
> + * cpuset membership stays stable. For top_cpuset, task_cpu_possible_mas=
k()
> + * is used instead of effective_cpus to make sure all offline CPUs are a=
lso
> + * included as hotplug code won't update cpumasks for tasks in top_cpuse=
t.
>   */

On Wed, Mar 15, 2023 at 11:06:20AM +0100, Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org=
> wrote:
> I see now that it returns offlined cpus to top cpuset's tasks.

I considered only the "base" set change cs->effective_cpus ->
possible_mask. (Apologies for that mistake.)

However, I now read the note about subparts_cpus

>         * effective_cpus contains only onlined CPUs, but subparts_cpus
>         * may have offlined ones.

So if subpart_cpus keeps offlined CPUs, they will be subtracted from
possible_mask and absent in the resulting new_cpus, i.e. undesirable for
the tasks in that cpuset :-/

Michal

--u3ht7kwhkaibaz3y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZBSrEwAKCRAkDQmsBEOq
ub2TAP9pF4P+p6q/Gyv+MLt5FYYDbFOYq0Pln5sL5iINLRsTkQEA2xdCNEw02ygM
fePZM8YSHXzb3KeNhLsD2b3PaS9m+AY=
=s2yK
-----END PGP SIGNATURE-----

--u3ht7kwhkaibaz3y--
