From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: Re: [PATCH v3 1/9] blk-throttle: correct stale comment in
 throtl_pd_init
Date: Tue, 6 Dec 2022 09:17:58 +0800
Message-ID: <dbec0c06-c1e0-5ee7-3b57-24a1d239026f@huaweicloud.com>
References: <20221205115709.251489-1-shikemeng@huaweicloud.com>
 <20221205115709.251489-2-shikemeng@huaweicloud.com>
 <be8563d8-1992-f9bc-928f-e9e5f3227c1c@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <be8563d8-1992-f9bc-928f-e9e5f3227c1c@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, tj@kernel.org, josef@toxicpanda.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com, linfeilong@huawei.com, liuzhiqiang26@huawei.com



on 12/6/2022 4:43 AM, Jens Axboe wrote:
> On 12/5/22 4:57?AM, Kemeng Shi wrote:
>> From: Kemeng Shi <shikemeng@huawei.com>
>>
>> On the default hierarchy (cgroup2), the throttle interface files don't
>> exist in the root cgroup, so the ablity to limit the whole system
>> by configuring root group is not existing anymore. In general, cgroup
>> doesn't wanna be in the business of restricting resources at the
>> system level, so correct the stale comment that we can limit whole
>> system to we can only limit subtree.
>>
>> Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
>> Acked-by: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
> 
> Which one should be used? You have duplicate SOBs in each of the
> commits. It's marked as being from Kemeng Shi <shikemeng@huawei.com> so
> that is what I'll use.

Either one is great, thanks.

-- 
Best wishes
Kemeng Shi

