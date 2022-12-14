From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH 0/2] block, bfq: minor cleanups
Date: Wed, 14 Dec 2022 11:14:49 +0800
Message-ID: <79d587ef-66c3-e84d-0904-41da2c8e7146@huaweicloud.com>
References: <20221214033155.3455754-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221214033155.3455754-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Jan

Sorry that I forgot to cc you.

Thanks,
Kuai

=D4=DA 2022/12/14 11:31, Yu Kuai =D0=B4=B5=C0:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Yu Kuai (2):
>    block, bfq: don't return bfqg from __bfq_bic_change_cgroup()
>    block, bfq: replace 0/1 with false/true in bic apis
>=20
>   block/bfq-cgroup.c  | 16 +++++++---------
>   block/bfq-iosched.c |  4 ++--
>   2 files changed, 9 insertions(+), 11 deletions(-)
>=20

