From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v3 0/3] blk-cgroup: make sure pd_free_fn() is called
 in order
Date: Sun, 29 Jan 2023 14:06:11 +0800
Message-ID: <0ddce9e4-d027-0bb0-d260-093ccc4c2d4d@huaweicloud.com>
References: <20230119110350.2287325-1-yukuai1@huaweicloud.com>
 <bd1c347b-cbf8-3917-401a-ed85c6ccb956@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bd1c347b-cbf8-3917-401a-ed85c6ccb956-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Jens

在 2023/01/20 2:54, Jens Axboe 写道:
> On 1/19/23 4:03 AM, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> Changes in v3:
>>   - add ack tag from Tejun for patch 1,2
>>   - as suggested by Tejun, update commit message and comments in patch 3
>>
>> The problem was found in iocost orignally([1]) that ioc can be freed in
>> ioc_pd_free(). And later we found that there are more problem in
>> iocost([2]).
>>
>> After some discussion, as suggested by Tejun([3]), we decide to fix the
>> problem that parent pd can be freed before child pd in cgroup layer
>> first. And the problem in [1] will be fixed later if this patchset is
>> applied.
> 
> Doesn't apply against for-6.3/block (or linux-next or my for-next, for
> that matter). Can you resend a tested one against for-6.3/block?
> 

This is weird, I just test latest linux-next, and I can apply this
patchset on the top of following commit:

For latest for-6.3/block, this patch 2 can't be applied because
following commit is not here:

e3ff8887e7db blk-cgroup: fix missing pd_online_fn() while activating policy

But this patch is already merged into 6.2-rc5.

Thanks,
Kuai

