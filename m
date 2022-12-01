From: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v2 0/5] A few cleanup and bugfix patches for blk-iocost
Date: Thu, 1 Dec 2022 10:20:30 +0800
Message-ID: <8d9c98e5-0433-e025-ccec-4144102e91c5@huaweicloud.com>
References: <20221018121932.10792-1-shikemeng@huawei.com>
 <93f9093b-abec-db7e-a945-263cd9355c08@huaweicloud.com>
 <bd008582-1509-69f3-1812-2b9caa390c05@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bd008582-1509-69f3-1812-2b9caa390c05-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



on 12/1/2022 9:46 AM, Jens Axboe wrote:
> On 11/30/22 6:45?PM, Kemeng Shi wrote:
>>
>> Hi jens,
>> on 10/18/2022 8:19 PM, Kemeng Shi wrote:
>>> This series contain a few patch to correct comment, correct trace of
>>> vtime_rate and so on. More detail can be found in the respective
>>> changelogs.
>>>
>>> ---
>>> v2:
>>>  Thanks Tejun for review and comment!
>>>  Add Acked-by tag from Tejun.
>>>  Correct description in patch 3/5 and 4/5.
>>>  Drop "blk-iocost: Avoid to call current_hweight_max if iocg->inuse
>>> == iocg->active"
>>>  Drop "blk-iocost: Remove redundant initialization of struct ioc_gq"
>>>  Drop "blk-iocost: Get ioc_now inside weight_updated"
>>> ---
>>>
>>> Kemeng Shi (5):
>>>   blk-iocost: Fix typo in comment
>>>   blk-iocost: Reset vtime_base_rate in ioc_refresh_params
>>>   blk-iocost: Trace vtime_base_rate instead of vtime_rate
>>>   blk-iocost: Remove vrate member in struct ioc_now
>>>   blk-iocost: Correct comment in blk_iocost_init
>>>
>>>  block/blk-iocost.c            | 16 +++++++++-------
>>>  include/trace/events/iocost.h |  4 ++--
>>>  2 files changed, 11 insertions(+), 9 deletions(-)
>> Could you apply this patchset?
>> By the way, my apply for an cloud variant of email was just passed
>> a few days ago. Is this mail still in spam?
> 
> This one wasn't, but I've seen the huaweicloud.com emails fail
> the same origination checks in the past.
I'm not sure if was there any fix to huaweicloud.com email. I will
use this huaweicloud emails to minimize the trouble before any
better solution is found. Sorry for the inconvenience.

-- 
Best wishes
Kemeng Shi

