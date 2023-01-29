From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH 01/15] blk-cgroup: don't defer blkg_free to a workqueue
Date: Sun, 29 Jan 2023 14:09:33 +0800
Message-ID: <16b095a1-49d3-e9a5-239b-0cb14d650706@huaweicloud.com>
References: <20230124065716.152286-1-hch@lst.de>
 <20230124065716.152286-2-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230124065716.152286-2-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Christoph,

=D4=DA 2023/01/24 14:57, Christoph Hellwig =D0=B4=B5=C0:
> Now that blk_put_queue can be called from process context, there is no
> need for the asynchronous execution.
>=20
> This effectively reverts commit d578c770c85233af592e54537f93f3831bde7e9a.

blkg_free() can be called from rcu callback, and my patch

blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and=20
blkcg_deactivate_policy()

will hold a mutex in blkg_free_workfn(), I think it's better not do such
thing in rcu callback, right?

Thanks,
Kuai

