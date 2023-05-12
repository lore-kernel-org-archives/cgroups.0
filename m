From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next 5/6] blk-wbt: cleanup rwb_enabled() and
 wbt_disabled()
Date: Fri, 12 May 2023 15:07:56 +0800
Message-ID: <3108fa29-1b22-a0f1-a7b0-7aa2bd0f1569@huaweicloud.com>
References: <20230511014509.679482-1-yukuai1@huaweicloud.com>
 <20230511014509.679482-6-yukuai1@huaweicloud.com>
 <20230511152327.GE7880@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230511152327.GE7880-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2023/05/11 23:23, Christoph Hellwig =D0=B4=B5=C0:
> On Thu, May 11, 2023 at 09:45:08AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> The code is redundant, reuse rwb_enabled() for wbt_disabled().
>=20
> This also changes how rwb_enabled is implemented.
>=20

'rwb->wb_normal =3D=3D 0' should be the same as 'rwb->enable_state =3D=3D
WBT_STATE_OFF_MANUAL', I'll explain in detail in v2.

Thanks,
Kuai

