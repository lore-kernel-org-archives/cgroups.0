From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup/cpuset: Allow only one active attach
 operation per cpuset
Date: Mon, 3 Apr 2023 18:47:36 +0200
Message-ID: <20230403164736.lpjdpzxxnjlpxrqv@blackpad>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-4-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kmhryddp6pf4i2i3"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680540458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VH+9LfYj7MbhreJ3Szg7MbF/2ha5Mr1B2SE9ELvDJ0M=;
        b=kJzshujXHzyGF/fo1Q6O+NTAfxbHv0w+eS/aHfJzJJpZLWjta2sh/QjUpKpd7xOVZOUqAG
        foWWC1LD1MDZKWlD/2bjPg3adOFbAoTMyJ+y0SS4NM3u17g5KEaAwxlrTcHkXdWZ9eC3Ay
        +vjsofb4QjlQvBe/hTWTGhpKpwLxZus=
Content-Disposition: inline
In-Reply-To: <20230331145045.2251683-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


--kmhryddp6pf4i2i3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 31, 2023 at 10:50:45AM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The current cpuset code uses the global cpuset_attach_old_cs variable
> to store the old cpuset value between consecutive cpuset_can_attach()
> and cpuset_attach() calls. Since a caller of cpuset_can_attach() may
> not need to hold the global cgroup_threadgroup_rwsem, parallel cpuset
> attach operations are possible.

Do I understand correctly this consequence of the cpuset_attach_task()
on the clone path?
In that particular case (with CLONE_INTO_CGROUP) cgroup_mutex is taken,
so the access the the old_cs variable should still be synchronized with
regular migrations that are also under cgroup_mutex.


> When there are concurrent cpuset attach operations in progress,
> cpuset_attach() may fetch the wrong value from cpuset_attach_old_cs
> causing incorrect result.  To avoid this problem while still allowing
> certain level of parallelism, drop cpuset_attach_old_cs and use a
> per-cpuset attach_old_cs value. Also restrict to at most one active
> attach operation per cpuset to avoid corrupting the value of the
> per-cpuset attach_old_cs value.

Secondly, semantically wouldn't a `void *ss_priv[CGROUP_SUBSYS_COUNT]`
in struct cgroup_taskset make it simpler wrt the exclusivity guarantees?

Thirdly, if my initial assumptino is right -- I'd suggest ordering this
before the patch `cgroup/cpuset: Make cpuset_fork() handle
CLONE_INTO_CGROUP properly` to spare backporters possible troubles if
this is would be a fixup to that.


Thanks,
Michal

--kmhryddp6pf4i2i3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZCsDJQAKCRAkDQmsBEOq
uS1zAP9TeBgc6NireljK5S1YDI/FdwDZFOk2ok2qCHerVad9/AD/bvO7HggZe7lO
MYuH4JuHJxwswQfaPVy7pxI4M5JDtgc=
=cc04
-----END PGP SIGNATURE-----

--kmhryddp6pf4i2i3--
