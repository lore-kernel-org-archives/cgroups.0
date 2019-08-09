From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [RFC PATCH] hugetlbfs: Add hugetlb_cgroup reservation limits
Date: Fri, 9 Aug 2019 13:27:39 +0200
Message-ID: <20190809112738.GB13061@blackbody.suse.cz>
References: <20190808194002.226688-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190808194002.226688-1-almasrymina@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: mike.kravetz@oracle.com, shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, khalid.aziz@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

(+CC cgroups@vger.kernel.org)

On Thu, Aug 08, 2019 at 12:40:02PM -0700, Mina Almasry <almasrymina@google.com> wrote:
> We have developers interested in using hugetlb_cgroups, and they have expressed
> dissatisfaction regarding this behavior.
I assume you still want to enforce a limit on a particular group and the
application must be able to handle resource scarcity (but better
notified than SIGBUS).

> Alternatives considered:
> [...]
(I did not try that but) have you considered:
3) MAP_POPULATE while you're making the reservation,
4) Using multple hugetlbfs mounts with respective limits.

> Caveats:
> 1. This support is implemented for cgroups-v1. I have not tried
>    hugetlb_cgroups with cgroups v2, and AFAICT it's not supported yet.
>    This is largely because we use cgroups-v1 for now.
Adding something new into v1 without v2 counterpart, is making migration
harder, that's one of the reasons why v1 API is rather frozen now. (I'm
not sure whether current hugetlb controller fits into v2 at all though.)

Michal

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl1NWKMACgkQia1+riC5
qSi2Sw/+M4XGujSB2JZaZ0/yi48MZThHdXWt5rWC6L/Nt7CW42/WhqltGcNl9c9F
O7Fegy17Qhgi0y/UUqUbQ2l27VD5AD5DZB+DIVmAIraiznhljDL24hTmSELtwOi9
Zn+c9dudCpUV4Z6LwBme2DSrsA9YAHwcjBSAhFu1YTTq07t+cT2RShx0ntKS5R9a
dYYh4JKFTsQ+qL/lWzl8aF4nYZGii7e+3i8E9+8ZYMLje6AYolAKJwQSmkWEJGGP
9asZ61GcnygJyxY4jEXo5xqUirK0c2knwT+41w1cwSto6+qdsYIYBuXueksUfMcv
LRKp/72MRdb7vHQdVQq/0uXj4QB5WAq8qFvhPbbTFgDRdMIyxUlltuLSCZ4oEKWK
TdDK/cfyowjrTbcqydWHLhX2R711IlpP2g1gGBa4nHHnXssOMTBrUthuSpX8EPUZ
YxDV4IQFEDCNxFsqsDJqd6mCZxm/Wdb+0LYz7Hi7Dqrs47bp+ggp3gYkVxFiZSsj
MzbjDYwrxdMgv6SS2P/IGUJI0Duzx3PjArGCAkYO5mjsi6HvfsF9l+pIRbb3uejC
EsWo/ReGFPTKmogjoAX4vxCRg1LpktYtzIzpqWqVTmWL70jiLnV4+FmeWBijlAJU
3TJwzTYrBbizqKm/PSjakNr9+3bBc+Tq2ZBcnq0bewC8hJZzdls=
=q8Ru
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
