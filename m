From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH] cgroup: pids: use {READ,WRITE}_ONCE for pids->limit
 operations
Date: Tue, 15 Oct 2019 02:59:31 +1100
Message-ID: <20191014155931.jl7idjebhqxb3ck3@yavin.dot.cyphar.com>
References: <20191012010539.6131-1-cyphar@cyphar.com>
 <20191014154136.GF18794@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="x7whfzqvnijraall"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191014154136.GF18794@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org


--x7whfzqvnijraall
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-10-14, Tejun Heo <tj@kernel.org> wrote:
> On Sat, Oct 12, 2019 at 12:05:39PM +1100, Aleksa Sarai wrote:
> > Because pids->limit can be changed concurrently (but we don't want to
> > take a lock because it would be needlessly expensive), use the
> > appropriate memory barriers.
>=20
> I can't quite tell what problem it's fixing.  Can you elaborate a
> scenario where the current code would break that your patch fixes?

As far as I can tell, not using *_ONCE() here means that if you had a
process changing pids->limit from A to B, a process might be able to
temporarily exceed pids->limit -- because pids->limit accesses are not
protected by mutexes and the C compiler can produce confusing
intermediate values for pids->limit[1].

But this is more of a correctness fix than one fixing an actually
exploitable bug -- given the kernel memory model work, it seems like a
good idea to just use READ_ONCE() and WRITE_ONCE() for shared memory
access.

[1]: https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--x7whfzqvnijraall
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXaSbYAAKCRCdlLljIbnQ
ErlGAPwNNvA0NEl3lea4jocc7jw2pPmGBL5rg/Ogyourf6PDpgD+IJJGCeNm9CFT
vQo8yItkhrGR/QEne2SQK5v1XqPseg8=
=ZrpX
-----END PGP SIGNATURE-----

--x7whfzqvnijraall--
