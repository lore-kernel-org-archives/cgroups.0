From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] block, bfq: minor cleanup and fix
Date: Mon, 24 Jan 2022 11:46:03 +0800
Message-ID: <a461cdbd-e1f3-0083-cd96-b69837334b19@huawei.com>
References: <20211231032354.793092-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20211231032354.793092-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2021/12/31 11:23, Yu Kuai =D0=B4=B5=C0:
> Chagnes in v2:
>   - add comment in patch 2
>   - remove patch 4, since the problem do not exist.
>=20
> Yu Kuai (3):
>    block, bfq: cleanup bfq_bfqq_to_bfqg()
>    block, bfq: avoid moving bfqq to it's parent bfqg
>    block, bfq: don't move oom_bfqq
>=20
>   block/bfq-cgroup.c  | 16 +++++++++++++++-
>   block/bfq-iosched.c |  4 ++--
>   block/bfq-iosched.h |  1 -
>   block/bfq-wf2q.c    | 15 ---------------
>   4 files changed, 17 insertions(+), 19 deletions(-)
>=20
Hi, jens

Now that with acked-by Paolo, can you please applied this pathset?

Thanks,
Kuai
