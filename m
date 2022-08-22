From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v7 1/9] blk-throttle: fix that io throttle can only work
 for single bio
Date: Mon, 22 Aug 2022 15:44:25 +0800
Message-ID: <8792d3f5-c07f-e080-ae29-b13d0f583f82@huaweicloud.com>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-2-yukuai1@huaweicloud.com>
 <Yvvx+/d2+OMROUOe@slm.duckdns.org>
 <712e0f29-94ba-d3d3-ce21-cba4d6092008@huaweicloud.com>
 <Yv0qbDR+cxKeZ3nD@slm.duckdns.org>
 <83c8b253-2ebb-5af6-8ce1-6dc3b84cf182@huaweicloud.com>
 <b1791e41-4945-a0d8-8067-3841ce10fddd@huaweicloud.com>
 <YwMvgN0YxNvkC1gm@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YwMvgN0YxNvkC1gm-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Tejun

=D4=DA 2022/08/22 15:25, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> On Mon, Aug 22, 2022 at 11:06:44AM +0800, Yu Kuai wrote:
>> While implementing the new method, I found that there seems to be a
>> misunderstanding here, the code seems to try to add flag to split bio
>> so that it won't be throttled again for bps limit, however:
>>
>> 1) for blk throttle, split bio is issued directly and will never be
>> throttled again, while orignal bio will go through throttle path again.
>> 2) if cloned bio is directed to a new disk, the flag is cleared anyway.
>=20
> Doesn't that make the current code correct then? But you were seeing
> incorrect behaviors, right?

According to the commit message in commit 111be8839817 ("block-throttle:
avoid double charge"):

If the bio is cloned/split, we copy the flag to new bio too to avoid a
double charge.

Which make me think the split bio will be resubmitted, and after
implementing the new solution, I found that test result is not as
expected. After spending sometime figuring out what is wrong, I found
that split bio will be dispatched directly from caller, while orignal
bio will be resubmitted.

I guess commit 111be8839817 made a mistake, however, there should be
no problem because orignal bio is flagged already, and it's handled
correctly.

Anyway, I removed the code in __bio_clone() and check flag in
__bio_split_to_limits in my patch:
--- a/block/bio.c
+++ b/block/bio.c
@@ -760,8 +760,6 @@ EXPORT_SYMBOL(bio_put);
  static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
  {
         bio_set_flag(bio, BIO_CLONED);
-       if (bio_flagged(bio_src, BIO_THROTTLED))
-               bio_set_flag(bio, BIO_THROTTLED);
         bio->bi_ioprio =3D bio_src->bi_ioprio;
         bio->bi_iter =3D bio_src->bi_iter;

diff --git a/block/blk-merge.c b/block/blk-merge.c
index ff04e9290715..10330bb038ca 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -358,6 +358,13 @@ struct bio *__bio_split_to_limits(struct bio *bio,=20
struct queue_limits *lim,
                 blkcg_bio_issue_init(split);
                 bio_chain(split, bio);
                 trace_block_split(split, bio->bi_iter.bi_sector);
+
+               /*
+                * original bio will be resubmited and throttled again,=20
clear
+                * the iops flag so that it can be count again for iops=20
limit.
+                */
+               if (bio_flagged(bio, BIO_IOPS_THROTTLED))
+                       bio_clear_flag(bio, BIO_IOPS_THROTTLED);
                 submit_bio_noacct(bio);
                 return split;
         }


>=20
> Thanks.
>=20

