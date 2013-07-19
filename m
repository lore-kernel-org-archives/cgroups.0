From: Konstantin Ryabitsev <mricon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Single process controlling all cgroups sounds like looking in
 right direction but wrong solution.
Date: Fri, 19 Jul 2013 16:01:21 -0400
Message-ID: <51E99B11.5020904@kernel.org>
References: <CANA3KFV6LmfKYUo305Fo2Yv_0kJGSSa7OjnGi8BMb+0Ys9e8NA@mail.gmail.com> <20130715032551.GA3046@ac100> <CANA3KFWdKbrpZDHHsqKeh-vugK7NjJ1xrFcXyYSRaKn0mUYewg@mail.gmail.com> <20130715123216.GA5663@sergelap> <CANA3KFVeYkvidYu=1rV_We3JLH5QEsogCnYQEdA6VGBKD2sbYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="AqEScAQoBLWP6avm9MpJOHQTPHEpfgjBS"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=sender:message-id:date:from:organization:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        bh=8lZxTs9appAjXNi8Ejz+aq1JxIhRqhGKXsKIioCjlVI=;
        b=J4pQ5eloB95lSAEVkwsRMwCTExHGO/ghbWPhLopH80EhQ24iu245cc/7OGK48DB9rh
         yy8K0rDmjGF/YlEZA49Jf8PfmLfHG90n62cZzHDlUekcZZdXpgdvovQgwtwT78kQp5Qy
         mP8tvxoPqUdIxeTBI/L1DaBKtbigmJ1LVhPxI=
In-Reply-To: <CANA3KFVeYkvidYu=1rV_We3JLH5QEsogCnYQEdA6VGBKD2sbYw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Peter Dolding <oiaohm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, webmaster-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AqEScAQoBLWP6avm9MpJOHQTPHEpfgjBS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 16/07/13 06:06 PM, Peter Dolding wrote:
> Webmaster https://www.kernel.org/doc/linux/MAINTAINERS   and the
> Maintainers file in git don't match.    Would suspect other sections
> in doc directory are also out.

Correct, that seems to have been completely overlooked. I just put
together a script that will auto-build and update the documentation
tree. The following is now auto-updated each time Linus tags his tree:

https://www.kernel.org/doc/Documentation/
https://www.kernel.org/doc/htmldocs/
https://www.kernel.org/doc/readme/
https://www.kernel.org/doc/linux/
https://www.kernel.org/doc/makehelp.txt

Best,
--=20
Konstantin Ryabitsev
Senior Systems Administrator
Linux Foundation Collab Projects
Montr=C3=A9al, Qu=C3=A9bec


--AqEScAQoBLWP6avm9MpJOHQTPHEpfgjBS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQGcBAEBAgAGBQJR6ZsRAAoJEI6WedmufEle8S4L/RtAbQDfVPUye0rgBRf91lNf
4qd5/bdoypAwul+omkQ7HNvKpDs4cNZM2PE4YLGLgbeHburA6mjjPHZ1iSyZPeCt
03iswjN+E0cBWMQbRlboLpjRp0DjmAa2S78X3A9xsc9WKsKbiYo5nkb+svl2nPN8
vp/1ZP1W4IsP08mhBBNgN4onDSj2bbwkGWkADVUv5FoB/4uSxnjRoUM3rKJ+1EwL
QRl6V6f80TRyej3ZoXUpO0frbDCJqVlnk9c+l/P38yMFbnIPDB1FgC79HqbjWMEc
SyPDo4vEg5WQA1xaXSGDN8a5XyAwq4yx+dlepwePHCOwNzuRdH6DH3dVRlRtf+In
QgYniN8XM+/1ARvel8nLdX9C3AKXGfD7klIOAmhqxsMf7NVen3/sss0T67LQL9CU
dlQUKynmJd3C/miOodWGpy0zI6/sKNGKcYep8MQ5oKT8bQci6zoVUbapP2DgUFpo
q2p/iJu/xKLK/WS3DCiH71qY9KzEEND8qqU8UdGJMg==
=qqpV
-----END PGP SIGNATURE-----

--AqEScAQoBLWP6avm9MpJOHQTPHEpfgjBS--
