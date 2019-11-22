From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: mount cgroup with "already mounted or cgroup busy"
Date: Fri, 22 Nov 2019 16:19:48 +0100
Message-ID: <20191122151948.GB14375@blackbody.suse.cz>
References: <11be9352e1e54ebebad078b1dac7b670@baidu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <11be9352e1e54ebebad078b1dac7b670@baidu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: "Li,Rongqing" <lirongqing@baidu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tj@kernel.org" <tj@kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Li.

On Wed, Oct 30, 2019 at 09:32:41AM +0000, "Li,Rongqing" <lirongqing@baidu.c=
om> wrote:
> I meet a issue, and not sure if it is normal
It is a consequence of how cgroup state is retained.

I considered a "trivial" fix, however, I learnt later it'd be a revert
(and hence regression) of=20
	3c606d35fe97 "cgroup: prevent mount hang due to memory controller lifetime"

> Using the below script, the last line mount will fail after unmount
> And it will fail until reboot system
The cause is that controllers remained pinned to the same root.
You can unpin them by mounting/unmounting again attached to the same
root (i.e. cpu,cpuset again).

(Perhaps the logic in cgroup1_root_to_use may be changed to cope better
with the "stateless" controllers.)

Michal

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl3X/JAACgkQia1+riC5
qSjBrw//bqjJVzaKkfcqi3QnWN7tcJnRB4kscGgj394bxZWDEaDCt5hnUblyD85Z
MNTSmkcTGGhGjRmnjKDYPDXr18PaOvVZu5etkpGYCza7SZ/g/MH/9W3DstVwVOzA
UudRbYwOHwieb93kKPNeE+uVKiKmXT+5AEpDCgqiQKPKRtdwRkJnxBPe0+Ii/cj3
YCo4ydhMQoDv5k7Vze1ZCLS3zAKNDJQQmcp3lPaBCDdlkTe0VE6DGFJwhQmZE3S0
4ezWkuDKpY+ab429voibjKskWfmfZI7miX6iMcx7txe1o8EYzMoKmCexWusNCSSa
x7Eoi5pLmj+FK0DbMU+3H3mH2h/W0YmeK/d5ZbYI33R8DTRt2vPQgH3WiSVVqtay
IITNljYshLP0VPWPUM+lWtO0QZzAhUGDAWpIXVclr1OymQxa9k/fRDrho+138QNM
8RChlt82rkXeF9v8OfgdZx8vvJVfCfxzKf61R2RK1qas8LB+F87m2hSjUfwAUX0K
BW5LTyyPwu7Fgj8bq8W1wNPk425QwZHYk83uPJnFXLiimUR5jK5Ixs1iT++l7Aci
E7dZsX3bVcaCx2YCFA1TYjF3eTqu4fKooChHQT3RNTHXcIbQHmvaZLpGhWVNk8EW
gZ39bdXJYxxLBpSIDmoiDOWkjMREW1dRZjMrN3pkHWPEcl0AsOw=
=WHd6
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
