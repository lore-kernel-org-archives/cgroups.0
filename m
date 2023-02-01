From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH] blk-ioprio: Introduce promote-to-rt policy
Date: Wed, 1 Feb 2023 16:07:48 +0700
Message-ID: <Y9or5PkdXj/D94fR@debian.me>
References: <20230201045227.2203123-1-houtao@huaweicloud.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OS7Ho6/EPKDu6yfb"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VyDJoRO+eavlOXGc4Q5SqoZUyZeya7RZ/BUKNVX/+dM=;
        b=n2kJU8RU6IvD/ch8vvXg1MhGLeamnUTDDdUpFRbfmE/2i6Ns4J1BaSL67JvbV163yV
         WLDUX8LreB1zUVzjU5huvP/DhUdx0OlMmaXyLeIqjQ20kONQkXYsh0nT6objM+1J9L9p
         TsXk8BbhOP4NR7MvpmjdH/b7f/HZLcE3nSk5xD196RrOLQcd9SoYhGIZQQ/PRx6gdqv+
         0JYWD1DjJul12kanXB2l9mLvaSkxRdWlMHuy6g5+8EfbeVNCEJVz9KpaScfTG6zbLTd+
         J8xEigI1i6MGnIcts/aAzTCezN5DIBtI1pbH7OcvOgofhi3tK4yNrr6W0Gh1TYgnTjTu
         WB+w==
Content-Disposition: inline
In-Reply-To: <20230201045227.2203123-1-houtao@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
To: Hou Tao <houtao@huaweicloud.com>, linux-block@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com


--OS7Ho6/EPKDu6yfb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 01, 2023 at 12:52:27PM +0800, Hou Tao wrote:
>  The following numerical values are associated with the I/O priority poli=
cies:
> =20
> -+-------------+---+
> -| no-change   | 0 |
> -+-------------+---+
> -| none-to-rt  | 1 |
> -+-------------+---+
> -| rt-to-be    | 2 |
> -+-------------+---+
> -| all-to-idle | 3 |
> -+-------------+---+
> +
> ++---------------+---------+-----+
> +| policy        | inst    | num |
> ++---------------+---------+-----+
> +| no-change     | demote  | 0   |
> ++---------------+---------+-----+
> +| none-to-rt    | demote  | 1   |
> ++---------------+---------+-----+
> +| rt-to-be      | demote  | 2   |
> ++---------------+---------+-----+
> +| idle          | demote  | 3   |
> ++---------------+---------+-----+
> +| promote-to-rt | promote | 1   |
> ++---------------+---------+-----+
> =20

The first row should have been header row:

---- >8 ----
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-=
guide/cgroup-v2.rst
index e0b9f73ef62a9e..55f9b579716564 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2048,7 +2048,7 @@ The following numerical values are associated with th=
e I/O priority policies:
=20
 +---------------+---------+-----+
 | policy        | inst    | num |
-+---------------+---------+-----+
++=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
+=3D=3D=3D=3D=3D+
 | no-change     | demote  | 0   |
 +---------------+---------+-----+
 | none-to-rt    | demote  | 1   |

> @@ -2064,9 +2074,13 @@ The numerical value that corresponds to each I/O p=
riority class is as follows:
> =20
>  The algorithm to set the I/O priority class for a request is as follows:
> =20
> -- Translate the I/O priority class policy into a number.
> -- Change the request I/O priority class into the maximum of the I/O prio=
rity
> -  class policy number and the numerical I/O priority class.
> +-- Translate the I/O priority class policy into an instruction and a num=
ber
> +-- If the instruction is demotion, change the request I/O priority class
> +-  into the maximum of the I/O priority class policy number and the nume=
rical
> +-  I/O priority class.
> +-- If the instruction is promotion, change the request I/O priority class
> +-  into the minimum of the I/O priority class policy number and the nume=
rical
> +-  I/O priority class.
> =20

Remove the excessive bullet list marker or the list above become paragraph
instead:

---- >8 ----
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-=
guide/cgroup-v2.rst
index 55f9b579716564..c3f16386c47bdf 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2074,12 +2074,12 @@ The numerical value that corresponds to each I/O pr=
iority class is as follows:
=20
 The algorithm to set the I/O priority class for a request is as follows:
=20
--- Translate the I/O priority class policy into an instruction and a number
--- If the instruction is demotion, change the request I/O priority class
--  into the maximum of the I/O priority class policy number and the numeri=
cal
--  I/O priority class.
--- If the instruction is promotion, change the request I/O priority class
--  into the minimum of the I/O priority class policy number and the numeri=
cal
+- Translate the I/O priority class policy into an instruction-number pair.
+- If the instruction is demotion, change the request I/O priority class
+  into the maximum of the I/O priority class policy number and the numeric=
al
+  I/O priority class.
+- If the instruction is promotion, change the request I/O priority class
+  into the minimum of the I/O priority class policy number and the numeric=
al
 -  I/O priority class.
=20
 PID

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--OS7Ho6/EPKDu6yfb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY9or3wAKCRD2uYlJVVFO
o58vAQD9CxSaIpA4AdTyvw0fuMNPOIuLSy4uqbVbnlwCHskJ8AD+IKwJnyzxD6Z5
kesBn69iDFNMECytC+QbcW0GkzPXZw0=
=iRGq
-----END PGP SIGNATURE-----

--OS7Ho6/EPKDu6yfb--
