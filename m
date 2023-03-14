From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH] io_uring/io-wq: stop setting PF_NO_SETAFFINITY on io-wq
 workers
Date: Tue, 14 Mar 2023 17:25:59 +0100
Message-ID: <20230314162559.pnyxdllzgw7jozgx@blackpad>
References: <0f0e791b-8eb8-fbb2-ea94-837645037fae@kernel.dk>
 <CA+wXwBRGzfZB9tjKy5C2_pW1Z4yH2gNGxx79Fk-p3UsOWKGdqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uyivj7p6qmo4u3py"
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678811161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qCpZsOY5vJMjrXMVquacAcLviS125U1g/UvmRs8jcGQ=;
        b=Ok5CcADsyEF9K4jNrmLOkw8s2o2IgQhGhdildAhZaa+J8gjBAVX2PTB8m1VQ+nm3plgDJN
        3X0fMtDxV3vUVbQYDdTSMGqyKBS2bc4msaV93wabX2FkM3lgjMLhx/2mYGerwjm5XudZ22
        PZ62Sa165WA+sRtmvq0ECzQQ2S3JqvE=
Content-Disposition: inline
In-Reply-To: <CA+wXwBRGzfZB9tjKy5C2_pW1Z4yH2gNGxx79Fk-p3UsOWKGdqA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
To: Daniel Dao <dqminh@cloudflare.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org


--uyivj7p6qmo4u3py
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Tue, Mar 14, 2023 at 10:07:40AM +0000, Daniel Dao <dqminh@cloudflare.com=
> wrote:
> IMO this violated the principle of cpuset and can be confusing for end us=
ers.
> I think I prefer Waiman's suggestion of allowing an implicit move to cpus=
et
> when enabling cpuset with subtree_control but not explicit moves such as =
when
> setting cpuset.cpus or writing the pids into cgroup.procs. It's easier to=
 reason
> about and make the failure mode more explicit.
>=20
> What do you think ?

I think cpuset should top IO worker's affinity (like sched_setaffinity(2)).
Thus:
- modifying cpuset.cpus	                update task's affinity, for sure
- implicit migration (enabling cpuset)  update task's affinity, effective n=
op
- explicit migration (meh)              update task's affinity, =C2=AF\_(=
=E3=83=84)_/=C2=AF

My understanding of PF_NO_SETAFFINITY is that's for kernel threads that
do work that's functionally needed on a given CPU and thus they cannot
be migrated [1]. As said previously for io_uring workers, affinity is
for performance only.

Hence, I'd also suggest on top of 01e68ce08a30 ("io_uring/io-wq: stop
setting PF_NO_SETAFFINITY on io-wq workers"):

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -233,7 +233,6 @@ static int io_sq_thread(void *data)
                set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
        else
                set_cpus_allowed_ptr(current, cpu_online_mask);
-       current->flags |=3D PF_NO_SETAFFINITY;

        mutex_lock(&sqd->lock);
        while (1) {

Afterall, io_uring_setup(2) already mentions:
> When cgroup setting cpuset.cpus changes (typically in container
> environment), the bounded cpu set may be changed as well.

HTH,
Michal

[1] Ideally, those should always remain in the root cpuset cgroup.

--uyivj7p6qmo4u3py
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZBCgFQAKCRAkDQmsBEOq
uToxAP4keIUYnddLzWuMVTcOzV5Nz9bslmaqVryt3DN9oeHutQEAyKJDJ8EXUYZ7
msh+kzh3Yisk1lIIEy1mAet2xe+LsgY=
=q1Cl
-----END PGP SIGNATURE-----

--uyivj7p6qmo4u3py--
