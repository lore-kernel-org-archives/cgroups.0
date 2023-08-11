From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v3] block: remove init_mutex and open-code
 blk_iolatency_try_init
Date: Fri, 11 Aug 2023 17:23:03 +0800
Message-ID: <b3409889-bb8a-d664-a495-c8cd34e501f3@huaweicloud.com>
References: <20230810035111.2236335-1-lilingfeng@huaweicloud.com>
 <6637e6cd-20aa-110a-40ae-53ecd6eb4184@huaweicloud.com>
 <d4050f7e-d491-c111-3e26-160e7d5a4208@huaweicloud.com>
 <dtobag743cbzb3rxzldu36wszqtnbayz2grpyj2cctptfybtt3@66ico6n2clrr>
 <60dbff4b-d823-5dc9-ff8e-36648ddf7207@huaweicloud.com>
 <fwzsn3wyqpthfkegnlq7obl3uy6hhodobvcswena2z42ndzmzp@izv4k6wy6opt>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fwzsn3wyqpthfkegnlq7obl3uy6hhodobvcswena2z42ndzmzp@izv4k6wy6opt>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Li Lingfeng <lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lilingfeng3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Michal

在 2023/08/11 17:17, Michal Koutný 写道:
> On Fri, Aug 11, 2023 at 04:53:44PM +0800, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org> wrote:
>> Yes, it'm implemented in the upper layer that rq_qos_add() and
>> blkcg_activate_policy() should be atmoic, and currently there is no
>> comments for that.
> 
> The check (iolat_rq_qos()) and use (activating the policy) should be the
> atomic pair.
> 
>> Perhaps it's better to add some comments like following in rq_qos_add()
>> instead?
> 
> Honestly, I find the current variant (v3) good as it is -- closest to
> the pair of the operations.
> 
> (But it's merely a comment so ¯\_(ツ)_/¯)

Yes, it's just a comment.

Lingfeng, can you resend this patch with the following fixed?

 > lockdep_assert_held(ctx.bdev->bd_queue->rq_qos_mutex);

should be:
lockdep_assert_held(&ctx.bdev->bd_queue->rq_qos_mutex);

And you can keep my review tag.

Thanks,
Kuai

> 
> Michal
> 

