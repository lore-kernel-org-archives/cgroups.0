From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH v2 0/3] Implement BFQ per-device weight interface
Date: Mon, 5 Aug 2019 17:08:36 +0200
Message-ID: <A6E36505-16B1-4E6D-BCA8-53E5FD4AEE98@linaro.org>
References: <20190805063807.9494-1-zhengfeiran@bytedance.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=CfGlMJlJq1yx6eSWof1+4yQXKTkrtm+XZNLVyiuuYPc=;
        b=jbxxzFHHvusryD5w8vzHeuPeqU/d3yLi9SHaw+kphMYUNZbQHKRDzd0wOyUR/cmUgM
         iMB55vlb/E8GPsyr5ucRPmimQH23RpGgdFiQBLzrxFXoq1sqDkFlGV+7etEF2y6fKRcg
         mc5VTGedBcNbRLHK58Op9xwxSGRqTW4NNy2ZXqz4/zNBv9SNY0VBWz5gJVC1blrGH3jF
         vNnmQ7gxzsoLn1ExYyoQuw5LWo9CH554+vbq0kfDJVdyCK4eq5LocjSQ4KunVUAkwDaG
         7q2NuNsw16RVT8AZxS87xuORXknHwk+nYviQ763BWAYD5i9CYfsX2MjrExgAgGrwLfWf
         gQXA==
In-Reply-To: <20190805063807.9494-1-zhengfeiran@bytedance.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Fam Zheng <zhengfeiran@bytedance.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Fam Zheng <fam@euphon.net>, duanxiongchun@bytedance.com, linux-block <linux-block@vger.kernel.org>, tj@kernel.org, cgroups@vger.kernel.org, zhangjiachen.jc@bytedance.com

Thank you very much, Fam, for this extension.

Reviewed-by: Paolo Valente <paolo.valente@linaro.org>

> Il giorno 5 ago 2019, alle ore 08:38, Fam Zheng =
<zhengfeiran@bytedance.com> ha scritto:
>=20
> (Revision starting from v2 since v1 was used off-list)
>=20
> Hi Paolo and others,
>=20
> This adds to BFQ the missing per-device weight interfaces:
> blkio.bfq.weight_device on legacy and io.bfq.weight on unified. The
> implementation pretty closely resembles what we had in CFQ and the =
parsing code
> is basically reused.
>=20
> Tests
> =3D=3D=3D=3D=3D
>=20
> Using two cgroups and three block devices, having weights setup as:
>=20
> Cgroup          test1           test2
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> default         100             500
> sda             500             100
> sdb             default         default
> sdc             200             200
>=20
> cgroup v1 runs
> --------------
>=20
>    sda.test1.out:   READ: bw=3D913MiB/s
>    sda.test2.out:   READ: bw=3D183MiB/s
>=20
>    sdb.test1.out:   READ: bw=3D213MiB/s
>    sdb.test2.out:   READ: bw=3D1054MiB/s
>=20
>    sdc.test1.out:   READ: bw=3D650MiB/s
>    sdc.test2.out:   READ: bw=3D650MiB/s
>=20
> cgroup v2 runs
> --------------
>=20
>    sda.test1.out:   READ: bw=3D915MiB/s
>    sda.test2.out:   READ: bw=3D184MiB/s
>=20
>    sdb.test1.out:   READ: bw=3D216MiB/s
>    sdb.test2.out:   READ: bw=3D1069MiB/s
>=20
>    sdc.test1.out:   READ: bw=3D621MiB/s
>    sdc.test2.out:   READ: bw=3D622MiB/s
>=20
> Fam Zheng (3):
>  bfq: Fix the missing barrier in __bfq_entity_update_weight_prio
>  bfq: Extract bfq_group_set_weight from bfq_io_set_weight_legacy
>  bfq: Add per-device weight
>=20
> block/bfq-cgroup.c  | 151 =
+++++++++++++++++++++++++++++++++++++++-------------
> block/bfq-iosched.h |   3 ++
> block/bfq-wf2q.c    |   2 +
> 3 files changed, 119 insertions(+), 37 deletions(-)
>=20
> --=20
> 2.11.0
>=20

