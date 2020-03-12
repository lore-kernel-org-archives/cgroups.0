From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH v3 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Thu, 12 Mar 2020 15:09:09 -0600
Message-ID: <23C0E698-9507-40FE-9F37-9F1C4CD55192@dilger.ca>
References: <20200312200317.31736-1-dxu@dxuuu.xyz>
 <20200312200317.31736-2-dxu@dxuuu.xyz>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_0A2AC55E-C672-4E48-973E-0DE56BB09E8C";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=Jm0QuoVYWLIkEIZ1aBkYIS2YTC2nnJykHw8y19YRbks=;
        b=lG44gMEia2yLgM2EF2gUy3A+yfFoluTTTEHv1h8h40hRfZL7AlPyQlA7WYGXAVAHzi
         7QKR+Dvo0BqrSXJK1rkIhgiH4sRxoCYokpaBqrhIHYw1MotZQI3g+0Y3H6dYy+Sldh6b
         5x/arYiXXXIvikCJgNqNAY90rwJMaiA2hFzydsMa8m8K3p4RyNc9kQdgEgUWgNaE71Jr
         nA9iPZbBBYdfKcsxwknObDM5kENiyvEAG9YTEKLtbDbWdb/Ijt0Z0cMnbUETGeX6SJYE
         vpsHe0GKamqSYBlw5o1rTslT4QSxie1OOVRfAneDZt94IqcPgM8OBWZhK7nHfxnm2V/2
         sraQ==
In-Reply-To: <20200312200317.31736-2-dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org


--Apple-Mail=_0A2AC55E-C672-4E48-973E-0DE56BB09E8C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 12, 2020, at 2:03 PM, Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org> wrote:
>=20
> xattr values have a 64k maximum size. This can result in an order 4
> kmalloc request which can be difficult to fulfill. Since xattrs do not
> need physically contiguous memory, we can switch to kvmalloc and not
> have to worry about higher order allocations failing.
>=20
> Signed-off-by: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>

Reviewed-by: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>

> ---
> fs/xattr.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 90dd78f0eb27..0d3c9b4d1914 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -817,7 +817,7 @@ struct simple_xattr *simple_xattr_alloc(const void =
*value, size_t size)
> 	if (len < sizeof(*new_xattr))
> 		return NULL;
>=20
> -	new_xattr =3D kmalloc(len, GFP_KERNEL);
> +	new_xattr =3D kvmalloc(len, GFP_KERNEL);
> 	if (!new_xattr)
> 		return NULL;
>=20
> @@ -882,7 +882,7 @@ int simple_xattr_set(struct simple_xattrs *xattrs, =
const char *name,
>=20
> 		new_xattr->name =3D kstrdup(name, GFP_KERNEL);
> 		if (!new_xattr->name) {
> -			kfree(new_xattr);
> +			kvfree(new_xattr);
> 			return -ENOMEM;
> 		}
> 	}
> @@ -912,7 +912,7 @@ int simple_xattr_set(struct simple_xattrs *xattrs, =
const char *name,
> 	spin_unlock(&xattrs->lock);
> 	if (xattr) {
> 		kfree(xattr->name);
> -		kfree(xattr);
> +		kvfree(xattr);
> 	}
> 	return err;
>=20
> --
> 2.21.1
>=20


Cheers, Andreas






--Apple-Mail=_0A2AC55E-C672-4E48-973E-0DE56BB09E8C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl5qpPwACgkQcqXauRfM
H+C6PRAApl5bisDXFp/jGULE8gpDy3JaNCc1YAKuK3qMiZB5UjjbzcMkMR9k31ka
BEfal9TrS7iPffpjhYEXcjStZ/cOQYzp8X7BhN/e+cVP+C+KRxD8E7LniFjfO6ib
84FMjaCTwFcQzIymBQ8TFjk6QUAOBnOX+eILuWKtRcJegg/sSPq/lLwW1YwGxiOY
3884UCNusbn7R60JPNY/69+0z93a4zVj5qXLw7Ufzclsozvag8IVO/2S1XI8BWh5
CZlLGZXDoU1a3W2DqUC7Plajctgd/XuEjER1UrRiIsYKJnkK8gytcegPUedb/efR
zy58TVNiEHW76yDk0ZVyeIkcXb0p3yeBZVa6HNZ4b1pAd16JNkvdPxQkns5zITvL
fCJqSpHzRXoKCsh4Tb8xYv0mDyVx5V4VqIZHcn9sXSijak4E29vN+PebpbPomC4j
BypStjLh7f3bJ9toRIr3yiReVi4TxxytaewJ2ATRfevquO/dsdToec8j7ewhXhEC
WPpALISGRkrG5xRbDgaGl9Zm9A9a5UeMokR+wMmWIjMicmxLjFdH99afhC+LWEF/
DYSTvBiFu0e2m5RJNUe9iSPCt/moM43e6GwFZSUDJhRFIxgn3s15rUwWGlM36Pi9
HWwG7W9CsQcq2juUqt1g/Ui/7C1F+Frz9y0ofmy3pOGkG0irKUE=
=Kd+G
-----END PGP SIGNATURE-----

--Apple-Mail=_0A2AC55E-C672-4E48-973E-0DE56BB09E8C--
