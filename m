From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 0/2] cgroup: seq_file .next functions should increase
 position index
Date: Tue, 28 Jan 2020 18:27:37 +0100
Message-ID: <20200128172737.GA21791@blackbody.suse.cz>
References: <195bf4c6-2246-b816-f18f-110b156a9341@virtuozzo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <195bf4c6-2246-b816-f18f-110b156a9341-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Vasily.

On Sun, Jan 26, 2020 at 01:45:45PM +0300, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>=
 wrote:
> In Aug 2018 NeilBrown noticed=20
> commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and=
 interface")
> "Some ->next functions do not increment *pos when they return NULL...
> Note that such ->next functions are buggy and should be fixed.=20
> A simple demonstration is
Thanks for bringing this up.

I agree with your changes, however, I have some suggestions:

1) squash [PATCH 2/2] "cgroup_procs_next should increase position index"
   and [PATCH] "__cgroup_procs_start cleanup"
   - make it clear in the commit message that it's fixing the small
     buffer listing, it's not a mere cleanup(!)
2) for completeness, I propose squashing also this change (IOW,
   cgroup_procs_start should only initialize the iterator, not move it):

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4617,7 +4617,7 @@ static void *__cgroup_procs_start(struct seq_file *s,=
 loff_t *pos,
         * from position 0, so we can simply keep iterating on !0 *pos.
         */
        if (!it) {
-               if (WARN_ON_ONCE((*pos)++))
+               if (WARN_ON_ONCE(*pos))
                        return ERR_PTR(-EINVAL);

                it =3D kzalloc(sizeof(*it), GFP_KERNEL);
@@ -4625,7 +4625,7 @@ static void *__cgroup_procs_start(struct seq_file *s,=
 loff_t *pos,
                        return ERR_PTR(-ENOMEM);
                of->priv =3D it;
                css_task_iter_start(&cgrp->self, iter_flags, it);
-       } else if (!(*pos)++) {
+       } else if (!(*pos)) {
                css_task_iter_end(it);
                css_task_iter_start(&cgrp->self, iter_flags, it);
        } else

3) I was not able to reproduce the corrupted listing into small buffer
   on v1 hierarchy, i.e. the [PATCH 1/2] "cgroup_pidlist_next should update
   position index" log message should just explain the change is to
   satisfy seq_file iterator requirements.
  =20
I can send my complete diffs if the suggestions are unclear.

Michal

P.S. I really recommend using `git send-email` for sending out the
patches, it makes mail threading more readable.

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl4wbv8ACgkQia1+riC5
qShgzg/7BWRViIdTDGbGqb1pkQ4geFffExyrLqNKckWNmMdunN7K3rDMgehXJ/7m
Kew5UMkk5x1ef/eqyARyNEG41mT4qVTfmiJJ0c+N9/XbjMH6Tw35I9sjkS5CgsIh
xB2D9wk8W1ItPYaTr5hG2EoxEIi63wo6j+FxtRCVcoFuVGhDAOTtqI4uwl2VqW7E
XXaUkZMaQxcAOte3v3XfoumgX6/Bsn7JKymNZ5bXDqwTmzd28iiCC58PrklU7cLL
e4T4rWaE5nzaNZIVDtST/V54Vb/Pt3wZYd/Tp+HEKchaUiIZpdyp7zo7IE8CmcpK
+jBcAPpm4dOcBUMlx1mbfExUkTwhDwGTpnaNKmPEkdyG1jQ3NofwvwykofxxZkjy
h+7yqGxjqyNKIWRMi8IoZ6SRdRkzaWOcCOGzZpM9o695vt0+UG9fAqfihGDTxj2v
0Dsr6gSoFDs4zknyDK8eeQj5G9wCWkT0DdLeegghzOX9EpuxQahEcBmJqQhVAK7a
JVesQu1JDwA4Y7Q7ip99RNbD1eZtzrqgoMViGdL0wZEICR5XINOjbz/K+7+xQ/vr
hfywJD9/Hi96SX/JZHUbT+yopGyiglgqM9ZIjDv57EJR2BDVwTUQaQlf0sEbfiua
buu/c6UeT6VEk7QgekIa2DU4RnQsAI2/SyTmatgqsZURkvzShWc=
=U9Td
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
