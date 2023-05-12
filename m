From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next 3/6] blk-wbt: don't enable wbt for bio based device
Date: Fri, 12 May 2023 15:06:07 +0800
Message-ID: <4d736700-6baa-4aab-2ff0-85752b543d81@huaweicloud.com>
References: <20230511014509.679482-1-yukuai1@huaweicloud.com>
 <20230511014509.679482-4-yukuai1@huaweicloud.com>
 <20230511152123.GC7880@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230511152123.GC7880-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2023/05/11 23:21, Christoph Hellwig =D0=B4=B5=C0:
> On Thu, May 11, 2023 at 09:45:06AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> Because rq_qos only make sense for rq based device. Instead of fail
>> from sysfs configuration, make wbt sysfs dentry invisible directly.
>=20
> This looks ok, bt I would be better to just have a separate attr
> group just for blk-mq based devices?
>=20

Sounds good, I'll add a new attr_group that is only visible for rq based
device, I think following attr can be moved to this new group:

nr_requests,
rq_affinity,
scheduler,
wbt_lat_usec

Thanks,
Kuai

