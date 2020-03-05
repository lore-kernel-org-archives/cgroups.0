From: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Subject: Re: [BUG] NULL pointer de-ref when setting io.cost.qos on LUKS
 devices
Date: Thu, 05 Mar 2020 11:31:29 +0100
Message-ID: <71515f7a143937ab9ab11625485659bb7288f024.camel@sipsolutions.net>
References: <1dbdcbb0c8db70a08aac467311a80abcf7779575.camel@sipsolutions.net>
         <20200303141902.GB189690@mtj.thefacebook.com>
         <24bd31cdaa3ea945908bc11cea05d6aae6929240.camel@sipsolutions.net>
         <20200304164205.GH189690@mtj.thefacebook.com>
         (sfid-20200304_174209_151624_50E7536A)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-mcjR0yXznIKw1TEhCYUl"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200304164205.GH189690-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org> (sfid-20200304_174209_151624_50E7536A)
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--=-mcjR0yXznIKw1TEhCYUl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-03-04 at 11:42 -0500, Tejun Heo wrote:
> [SNIP]
>=20
> Right now, the situation isn't great with dm. When pagecache
> writebacks go through dm, in some cases including dm-crypt, the cgroup
> ownership information is completely lost and all writes end up being
> issued as the root cgroup, so it breaks down when dm is in use.

Fair enough.

> In the longer term, what we wanna do is controlling at physical
> devices (sda here) and then updating dm so that it can maintain and
> propagate the ownership correctly but we aren't there yet.

Perfect, so what I am seeing is really just a small systemd bug. Thansk
for confirming, I'll submit a patch to fix it.

Benjamin

--=-mcjR0yXznIKw1TEhCYUl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEED2NO4vMS33W8E4AFq6ZWhpmFY3AFAl5g1QEACgkQq6ZWhpmF
Y3DEqg//VPcO2qUEZ7XODL8iSVDhK1pGXv5KSILnsiTyDXo4wHPND3tNcpOAceU+
l1fufTA2LMbXtH1BMPmlEL/lMQK27IUss0J3PyihPBWjdC31KTpxixCr/61mERo6
zQSnGGUYoNsVwyMP8kl5DcNFscY42fOcnx5Ot5GdfYrw35Lqniv7OctQyCXU5vAD
MeEbW2jE7J8vusMMr4Bn68fIUuXYLE1Thx0FIn4HtH9mpyQsfyXFDGqq/92AHbsS
SpP3H+iVjOf0v5oAV+0NZMu6HE5o+g36HpvS4UzODdLynfYkmFPcwoxpfUQ9bDT/
Yrv7uAUvlikRekvPNo3TBg3Yh8oIuri+tVvTZzgdnldyDPU8RhQjd6q11XR7OASb
tFONjiI5w2xzLmuY96R7KHac31O0zEmNDpYSGOx56HCLu7gx4mkU4usdDB0IqRbZ
iawu0jvpwRhneDW3p5mQDm2DMRcAuAAX9NviezqktvRkzfwgJyeyeQzhwEy24a2J
cgVAT6f5KVi+JE0NWaCS17GIL2vPmRB/pbbE6KIi9+5ZFRtby6ppU6W8QLXb5c8d
jzcgIMuL2HB/YWCqvMR4ZQukPD/TnaCvLiA8zof1PboGXh7vPxMPfoladjCUEFS7
IPA2B4YjF3TZtr8AIqgmi5qrg+BCJVtaKp0shvrpJzA1v5SDsqU=
=PIRG
-----END PGP SIGNATURE-----

--=-mcjR0yXznIKw1TEhCYUl--

