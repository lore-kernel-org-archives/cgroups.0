From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH] blk-cgroup: fix missing pd_online_fn() while activating
 policy
Date: Thu, 5 Jan 2023 21:52:29 +0800
Message-ID: <6f54c858-be91-0fd3-d377-1aabb8a70c6f@huaweicloud.com>
References: <20230103112833.2013432-1-yukuai1@huaweicloud.com>
 <20230104151241.GA13268@blackbody.suse.cz>
 <4b559d1d-31e4-6049-4548-451bf7afb4f4@huaweicloud.com>
 <20230105104241.GA16920@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20230105104241.GA16920@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

在 2023/01/05 18:45, Michal Koutný 写道:
> On Thu, Jan 05, 2023 at 09:43:02AM +0800, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>> This is based only on code review, currently the only negative effects
>> is that root blkg from blk-throtl won't call pd_online_fn().
> 
> Good, that's a NOP and there are no other uses of pd_online_fn.
> 
> I wonder are the separate pd_init_fn and pd_online_fn callbacks
> necessary today?

I think online can combine to init, consider that only blk-throttle
implement pd_online_fn(), but I'm not sure...

It seems to me the policies(bfq, iocost...) seem don't honor how pd
apis works: alloc->init->online->offline->free, bfq combines online to
init, iocost combines offline to free, ...

Thanks,
Kuai

