From: Aleksa Sarai <asarai@suse.de>
Subject: Re: Cgroups "pids" controller does not update "pids.current" count
 immediately
Date: Fri, 15 Jun 2018 03:27:57 +1000
Message-ID: <20180614172757.ovu6sbolcgc4cdjr@gordon>
References: <77af3805-e912-2664-f347-e30c0919d0c4@icdsoft.com>
 <20180614172634.ymoik5uov3vzftmp@gordon>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ffjecwbgrtrqriux"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180614172634.ymoik5uov3vzftmp@gordon>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Ivan Zahariev <famzah@icdsoft.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


--ffjecwbgrtrqriux
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-06-15, Aleksa Sarai <asarai@suse.de> wrote:
> > I've tested this on 4.14.27 and 4.4.0-124-generic Ubuntu.
> >=20
> > If I start a couple of processes which exit very quickly (like a simple=
 Bash
> > script with many commands in it), the reported value in "pids.current" =
is
> > not updated immediately when processes exit. This leads to too many
> > processes incorrectly accounted in "pids.current" which hits the "pids.=
max"
> > prematurely.
>=20
> One possible reason for this might be related to zombie processes.
> cgroup.procs doesn't include any zombie processes (tasks are removed
> when they exit(2)), but the pids controller does track zombies (tasks
> are removed when the 'struct task' is put'd). This could explain why
> there's a discrepancy which clears itself up after a short period of
> time -- though I am not sure that your reproducer will actually produce
> zombies (I only took a quick look at it).

Scratch that -- it can happen even without zombies. Basically it just
depends on when the 'task struct' is freed (which could happen
arbitrarily later than the process exit(2)-ed).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--ffjecwbgrtrqriux
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlsipZ0ACgkQnhiqJn3b
jbTowg//Q3Bz8gL+xLSPM+qPx5XjzY8pwhJWMvL/dPcXLSDeLyAvNnKJzmNk2yw8
wp7TCm2Prl6IG/lb9VP/HK7Vy/EKDHfTeH72HPUsIpVLaQbSL0+CGEIlYJGBHseo
XNj4Db75jFu9VtbJe33m9SnDweIh8W3+e8raqLUz55vbX4oCRMzXBMtH44waKKxN
22vWutgvrhZhWd3CDdAAnJKh1EGIZqeSSui4v/aZ+lFFX49ydMEzwvf1yMAVLTGT
RKiWFfpLDvEuPL21nPjVxkIXT2cLA9vb9dNs5xyOtEZtVKHnl6CMJRGx8Htu7VxT
mX4+BRqDK059F/uU0PK/GsklvgrDGYCMpf9zZARwJBymm0VuKo+BFbPS/EcZIV41
LsgN2NH0Ksm5g67F/5XfSkuS23zQqVBLn3Sq3YJcM1k8wEUd9UNicQ6O/QXQ2kZM
Mga/tlwe5Iyep+dpYT50om655hY1Ya7+v1FXmpxcBxSJ3RPLwQ7UD4E30X4mVKNI
o0Ubp2kFRPw4BvVVQxDF1Oat7TeWssbY4szSIF/ATIAtv+yGtCF7E4QEFdFQUE/q
1I7AmO8ui7977s37w5vWThMfFvlpORfsKibVnBx75pXzpXkloNnYFJZuuYBi/WoX
I3bCjAvrSXKtTSIlcXUB/hAkoD8fe9W6htUhWck4DoYbc+1cJWE=
=iDN8
-----END PGP SIGNATURE-----

--ffjecwbgrtrqriux--
