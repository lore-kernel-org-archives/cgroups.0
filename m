From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH] block, bfq: fix uaf for bfqq in bic_set_bfqq()
Date: Sun, 29 Jan 2023 09:18:14 +0800
Message-ID: <38b5d9a6-bed6-c139-404b-94aca49f38c6@huaweicloud.com>
References: <20230113094410.2907223-1-yukuai3@huawei.com>
 <20230124000925.pfosl6pfuhjyggbp@shindev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230124000925.pfosl6pfuhjyggbp@shindev>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Shinichiro Kawasaki <shinichiro.kawasaki-Sjgp3cTcYWE@public.gmane.org>
Cc: "jack-AlSwsSmVLrQ@public.gmane.org" <jack-AlSwsSmVLrQ@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org" <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org" <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, "yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2023/01/24 8:09, Shinichiro Kawasaki =D0=B4=B5=C0:
>=20
> Yu, thanks for posting this fix, but it can not be applied to v6.2-rc5. T=
he
> hunk above looks different from the patch I tested. Could you take a look?
>=20

This patch was rebased with following patch that add a new param for
bic_set_bfqq():

51ec2387623a block, bfq: split sync bfq_queues on a per-actuator basis

Thanks,
Kuai

