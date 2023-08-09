From: Li Lingfeng <lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next] block: remove init_mutex in blk_iolatency_try_init
Date: Wed, 9 Aug 2023 18:57:52 +0800
Message-ID: <c8b09f3b-b8c2-4973-255a-ab63bd6cf771@huaweicloud.com>
References: <20230804113659.3816877-1-lilingfeng@huaweicloud.com>
 <o6nnp6jwzpchlqsiusbioqsyaml2fonxzmzi46yrycjgtq6hyb@ixqiysu6lmpe>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <o6nnp6jwzpchlqsiusbioqsyaml2fonxzmzi46yrycjgtq6hyb@ixqiysu6lmpe>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lilingfeng3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Thanks for your advice, I will send a new patch soon.

在 2023/8/8 0:05, Michal Koutný 写道:
> Hello.
>
> On Fri, Aug 04, 2023 at 07:36:59PM +0800, Li Lingfeng <lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org> wrote:
>> From: Li Lingfeng <lilingfeng3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> Commit a13696b83da4 ("blk-iolatency: Make initialization lazy") adds
>> a mutex named "init_mutex" in blk_iolatency_try_init for the race
>> condition of initializing RQ_QOS_LATENCY.
>> Now a new lock has been add to struct request_queue by commit a13bd91be223
>> ("block/rq_qos: protect rq_qos apis with a new lock"). And it has been
>> held in blkg_conf_open_bdev before calling blk_iolatency_init.
>> So it's not necessary to keep init_mutex in blk_iolatency_try_init, just
>> remove it.
> I'm looking at ioc_cost_model_write() or ioc_qos_write() where is
> a similar pattern.
> Could the check+init be open-coded back to iolatency_set_limit() to make
> code more regular?
>
> Michal

