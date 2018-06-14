From: Aleksa Sarai <asarai@suse.de>
Subject: Re: Cgroups "pids" controller does not update "pids.current" count
 immediately
Date: Fri, 15 Jun 2018 03:26:34 +1000
Message-ID: <20180614172634.ymoik5uov3vzftmp@gordon>
References: <77af3805-e912-2664-f347-e30c0919d0c4@icdsoft.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n2z34pfmzym6bcpm"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <77af3805-e912-2664-f347-e30c0919d0c4@icdsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Ivan Zahariev <famzah@icdsoft.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


--n2z34pfmzym6bcpm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-06-14, Ivan Zahariev <famzah@icdsoft.com> wrote:
> I posted a kernel bug about this a month ago but it did not receive any
> attention: https://bugzilla.kernel.org/show_bug.cgi?id=3D199713

I believe that very few people watch the kernel bugzilla -- it's almost
always better to send a mail to LKML (speaking of which, you should
always include <linux-kernel@vger.kernel.org> in Cc).

> I've tested this on 4.14.27 and 4.4.0-124-generic Ubuntu.
>=20
> If I start a couple of processes which exit very quickly (like a simple B=
ash
> script with many commands in it), the reported value in "pids.current" is
> not updated immediately when processes exit. This leads to too many
> processes incorrectly accounted in "pids.current" which hits the "pids.ma=
x"
> prematurely.

One possible reason for this might be related to zombie processes.
cgroup.procs doesn't include any zombie processes (tasks are removed
when they exit(2)), but the pids controller does track zombies (tasks
are removed when the 'struct task' is put'd). This could explain why
there's a discrepancy which clears itself up after a short period of
time -- though I am not sure that your reproducer will actually produce
zombies (I only took a quick look at it).

> The "memory" controller, for example, works as expected and does not suff=
er
> from this asynchronous lag.

I'm not sure what makes the memory controller and the pids controller
comparable in this aspect -- there is no "pids.current" for the memory
controller.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--n2z34pfmzym6bcpm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlsipUYACgkQnhiqJn3b
jbQOrhAAgG6rzxPTPP0i7Y2oMqlWigk48dx8cXdvRRa2jRYMZGURPi5F0zFm+9lT
man19bmp5vFWAHsjfVh6ufh6A76jUEkgRdnb8EGy/U0ABf5dgkQylXshPUFNmNW2
sxvadMadWBlR/BIGFO48h0CDJd59DoWegnkwdTMN9oOCdCc+g2N18IssCUT7DHL3
fYcyB4Qbgygg12ZDze/znp8DoMnuDKGbZLZHeQctn7lbAkpCvvKxJo/V1hvewgtf
dr7C4YghzsUt2LWkgNSPwX/WuU23b3nvz51w9yaEhCrOWkPKp353CHHnck5JsDFC
asAryTvko05AKDrXv3KvlPMB6poye8o0gZkIlXKsmdoYwrjNhjccIHEaUrcdawgD
II5NKZmkNFcvce2pjXVd090SaeZX2rxigu0f21Ez9+liWmBwaQKJWCmFMUURS7Gy
3HHFwRNtEpYxT3PNqONYdq1tmqnnlZekDBHr+DBvDLAVHwhG4fIlnTZmQYfjb8l+
RdAqFMQzde7/3xn5MkKWloUI2D/Bd24OYUH3Q2QcgwxKq4XmGr/EE3Qd6nX2Zome
iF4FBJ20V9XhBWFCpei6Cx1NYx2NZjdpg/W7BGLtgnpNtViMxgmSy25427Z3onrw
+84zAFh3lWCcNqUtc3Ptek4tprqkPJnFqk235pLXZ2ekFLO62Zs=
=CcXs
-----END PGP SIGNATURE-----

--n2z34pfmzym6bcpm--
