From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v3 4/5] mm: memcg: charge memcg percpu memory to the
 parent cgroup
Date: Fri, 14 Aug 2020 09:27:02 +1000
Message-ID: <20200814092702.137f588e@canb.auug.org.au>
References: <20200623184515.4132564-1-guro@fb.com>
        <20200623184515.4132564-5-guro@fb.com>
        <20200811152737.GB650506@cmpxchg.org>
        <20200811170611.GB1507044@carbon.DHCP.thefacebook.com>
        <CA+G9fYuTsjEpDpODGcYf5hnGwzxj__tVdCMpWeC+ojg5pkYCzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/DSdzwDUNizsWTg7P5FTg3NX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1597361224;
        bh=b0sp0GqxeJRJwCzNQOrqlW7VXOG8F0YZwALL4eEoD5M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UnU1wME2TLmgYlebvh6Kha7r7BnHE0z+WwPnEBZM+GehgUImQrlr+goSrJVOrqH+w
         59MZzU1BVgn87fdCzbPZnnukEOad5yyX7sF5PCB+E4dZbetS76Z6JnizvqjYLvrUUS
         5FdWQnO4wFF4XlSscVKa+uv8WWfwc8JC2vk4AUD8TJjTPXmy5Kx6WUjl77cNsZfO62
         zVL+qWdKCAkYuQCLrzgu7D80cSr6Q5TElNNXEioruHtMSCU38ulmsKmRY7AUnyPs9r
         X2/uxCeuPia/YdUbRxOtptGi4/GYSYzW0QQSX/yXnDTAXwHnvheHY9iEYJadirtsLo
         ocQZ/5dJ2LKZQ==
In-Reply-To: <CA+G9fYuTsjEpDpODGcYf5hnGwzxj__tVdCMpWeC+ojg5pkYCzw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Roman Gushchin <guro@fb.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Kernel Team <kernel-team@fb.com>, lkft-triage@lists.linaro.org

--Sig_/DSdzwDUNizsWTg7P5FTg3NX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Naresh,

On Thu, 13 Aug 2020 14:46:51 +0530 Naresh Kamboju <naresh.kamboju@linaro.or=
g> wrote:
>
> The kernel warnings  were noticed on linux next 20200813 while booting
> on arm64, arm, x86_64 and i386.
>=20
> metadata:
>   git branch: master
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-ne=
xt.git
>   git commit: e6d113aca646fb6a92b237340109237fd7a9c770
>   git describe: next-20200813
>   make_kernelversion: 5.8.0
>   kernel-config:
> https://builds.tuxbuild.com/YQHc_PpEV-DF8rU7N9tlIQ/kernel.config

Actually in Linus' tree.

It has been fixed today.  Thanks for reporting.

--=20
Cheers,
Stephen Rothwell

--Sig_/DSdzwDUNizsWTg7P5FTg3NX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl81zEYACgkQAVBC80lX
0Gw2LggAoyJQ8D8AoMUEbVoc+URfocM9YXpIdJ3mVvqsndDMp87mLPzO5YrOO+X8
ZTgKq1ws0W0X7eRoCL/GOFSiF890ifP4kxrz2bmT2/azN44dUUtDmon6jfiu907u
nGpoMMBgKnubh2e+xQ7LUJKsVrHKvHm/fWAfhEFw7LyGEhbdlbOaTPxWg34j6qdY
ROzwCtJ52x9m/jkHYqcqJophYIB41HDXmxHGW2UrITHCl6dQBJ29xrQsLAfNDmZA
oGVIiM453gmdPekBMkJTMM8FMT01uLwfM4WWZ+y0/1aoq/4J31LqNX6iFVxzVpub
OXIOLoyxuhFJJW4yuDPJ53tKVqonpQ==
=Bk2z
-----END PGP SIGNATURE-----

--Sig_/DSdzwDUNizsWTg7P5FTg3NX--
