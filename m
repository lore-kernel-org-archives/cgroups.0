From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH] blk-cgroup: fix missing pd_online_fn() while activating
 policy
Date: Thu, 5 Jan 2023 09:43:02 +0800
Message-ID: <4b559d1d-31e4-6049-4548-451bf7afb4f4@huaweicloud.com>
References: <20230103112833.2013432-1-yukuai1@huaweicloud.com>
 <20230104151241.GA13268@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20230104151241.GA13268@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi, Michal

在 2023/01/04 23:12, Michal Koutný 写道:
> Hello.
> 
> On Tue, Jan 03, 2023 at 07:28:33PM +0800, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>> If the policy defines pd_online_fn(), it should be called after
>> pd_init_fn(), like blkg_create().
> 
> Is this based only on code review or has it some negative effects?

This is based only on code review, currently the only negative effects
is that root blkg from blk-throtl won't call pd_online_fn().
> 
> I assume this would affect hot-plugged (read after cgroup creation) devices.
> 
> I took a cursory look at:
> 
> 	blkcg_init_disk
> 	  blkg_create
> 	    pol->pd_init_fn(blkg->pd[i]);
> 	    pol->pd_online_fn(blkg->pd[i]);
> 	  blk_throtl_init
> 	    blkcg_activate_policy
> 	      pol->pd_init_fn(blkg->pd[i]);
> 	      ?? pol->pd_online_fn(blkg->pd[i]);
> 
> I.e. the pd_online_fn is already called and pd_init_fn is called 2nd
> time?

No, this is not true, before blkcg_activate_policy() is called,
blkg_create() won't see this policy, hence pd_init_fn/pd_online_fn won't
be called from blkg_create().

Thanks,
Kuai
> 
> Thanks,
> Michal
> 

