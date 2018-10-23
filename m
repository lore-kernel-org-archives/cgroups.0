From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH] rdmacg: fix a typo in rdmacg documentation
Date: Tue, 23 Oct 2018 16:13:33 +0000
Message-ID: <VI1PR0501MB2271192C00D2E25E0AB6950DD1F50@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20181023150106.7332-1-ramirose@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QtKVwKm1RytM3kwFLau/gSZVIzzMvQodGqzgmYKAwLA=;
 b=bGsTPBBW8WHhNW5qWW+9+rRCqHBwFGldEv3Zes5/d/sazUIA9CWhXPlIxxz+6mjioQpjpXuaJJn7vvFQ9NrFRDnKVClglnNbPVKNOnf3bRQP2mLtuXJ+xkx5Ay3kxznqDHemtmr9I5eE2OPyPsIxBlTeEjkeYXrd65taPGYzADU=
In-Reply-To: <20181023150106.7332-1-ramirose@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Rami Rosen <ramirose@gmail.com>, "pandit.parav@gmail.com" <pandit.parav@gmail.com>
Cc: "tj@kernel.org" <tj@kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Rami Rosen
> Sent: Tuesday, October 23, 2018 8:31 PM
> To: pandit.parav@gmail.com
> Cc: tj@kernel.org; linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.o=
rg;
> cgroups@vger.kernel.org; Rami Rosen <ramirose@gmail.com>
> Subject: [PATCH] rdmacg: fix a typo in rdmacg documentation
>=20
> This patch fixes a typo in RDMA cgroup documentation.
>=20
> Signed-off-by: Rami Rosen <ramirose@gmail.com>
> ---
>  Documentation/cgroup-v1/rdma.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Documentation/cgroup-v1/rdma.txt b/Documentation/cgroup-
> v1/rdma.txt
> index af618171e0eb..9bdb7fd03f83 100644
> --- a/Documentation/cgroup-v1/rdma.txt
> +++ b/Documentation/cgroup-v1/rdma.txt
> @@ -27,7 +27,7 @@ cgroup.
>  Currently user space applications can easily take away all the rdma verb
> specific resources such as AH, CQ, QP, MR etc. Due to which other
> applications  in other cgroup or kernel space ULPs may not even get chanc=
e
> to allocate any -rdma resources. This can leads to service unavailability=
.
> +rdma resources. This can lead to service unavailability.
>=20
>  Therefore RDMA controller is needed through which resource consumption
> of processes can be limited. Through this controller different rdma
> --
> 2.17.1

Thanks Rami for the correction.
For sake of process correctness, below fixes tag is good to have.

Fixes: 9c1e67f94101 ("rdmacg: Added documentation for rdmacg")

Reviewed-by: Parav Pandit <parav@mellanox.com>
