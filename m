From: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Subject: Re: [BUG] NULL pointer de-ref when setting io.cost.qos on LUKS
 devices
Date: Tue, 03 Mar 2020 15:40:38 +0100
Message-ID: <24bd31cdaa3ea945908bc11cea05d6aae6929240.camel@sipsolutions.net>
References: <1dbdcbb0c8db70a08aac467311a80abcf7779575.camel@sipsolutions.net>
         <20200303141902.GB189690@mtj.thefacebook.com>
         (sfid-20200303_151905_302479_14795E89)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-j4uCKWQWPoDS0sEousKX"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200303141902.GB189690-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org> (sfid-20200303_151905_302479_14795E89)
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--=-j4uCKWQWPoDS0sEousKX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-03-03 at 09:19 -0500, Tejun Heo wrote:
> Hello,
>=20
> On Tue, Mar 03, 2020 at 03:13:10PM +0100, Benjamin Berg wrote:
> > so, I tried to set io.latency for some cgroups for the root device,
> > which is ext4 inside LVM inside LUKS.
>=20
> It's pointless on compound devices. I think the right thing to do here
> is disallowing to enable it on those devices.

I believe systemd tries to resolve to /dev/sda but that seems to fail
for me. So I think there is a bug in that code; I'll verify that and
submit a fix if so.

Which device should actually be selected? Is it /dev/sda or the mapper
device that / is mounted from?

Benjamin

--=-j4uCKWQWPoDS0sEousKX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEED2NO4vMS33W8E4AFq6ZWhpmFY3AFAl5ebGYACgkQq6ZWhpmF
Y3DTFw//VcGWBCbgwz1EKl5qv3UCTAc1Ra0D+vtWN6PD21vXyMF+gU4yrxIF5ZO4
aW4FwhM0MgmrBRsgew/6pH1TkIsE8bIlh1h8fi921ISOVYygvu0QRKuQ6Gll1trA
+yS+J9e9NrDAio1xPkopG/Lf/ZiyO9a88aeiGckEQ7j3xXEW4pCM42gttYoLugh3
qVI8vTvj1Ns0SCQ/qq25UH2Tk5h7IUA4efmNbeZElDGRBBAKhSGNg4r9zLZFVdU9
4PPQ69jBTXjK5uB2x6DuroH5vYHOlJcRb0yaZpFOMqbk5QoaXfi094gKBVllqdLB
hAI0P3lR64xQhmSkP7J4Y8zkhDQMKiCFxbJDAk6a/HQmYSb3fc7tX7yBljZWI2HK
Cthf7MGU3+ElqevQ8a/bglssB8Rw1ufoxOgh1TDDRSRVXmRm2szUY2V/EVQYqlT/
aqpogxLDCYKluvn6N6wAGLV1hPIeuUo6Ld34f0lcA69c/dccdBQ+CCM6ToAHvfMl
+YQAN6cN2mV1iRKzjq3O3beVV1ueoOtaHDKbuHy22c7SqRx1mwZUuyydfuGpLNSv
djo9Y9LPMBVL+hHkDNNtHFmV7vguTEqirD6nnoKj/HtUofyS9o/Ylh9EOhkr1eMi
9Q4cjZG2ydksugCidpVDL1ZbkeeFNH5OnJ4ZIWH0lvCy3y0dzHo=
=NGp6
-----END PGP SIGNATURE-----

--=-j4uCKWQWPoDS0sEousKX--

