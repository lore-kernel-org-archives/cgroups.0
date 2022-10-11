From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] blk-cgroup: correct comment for blk_alloc_queue and
 blk_exit_queue
Date: Tue, 11 Oct 2022 09:07:20 +0800
Message-ID: <da6d7a9a-49a8-0116-2507-f5c8057eaf42@huawei.com>
References: <20221010023859.11896-1-shikemeng@huawei.com>
 <20221010023859.11896-3-shikemeng@huawei.com>
 <Y0SACpAv4+ETrS6Z@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y0SACpAv4+ETrS6Z-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



on 10/11/2022 4:26 AM, Tejun Heo wrote:
> On Mon, Oct 10, 2022 at 10:38:57AM +0800, Kemeng Shi wrote:
>> Since commit 1059699f87eb("block: move blkcg initialization/destroy into
>> disk allocation/release handler"), blk_alloc_queue and blk_exit_queue is
>> called directly from gendisk. Update the corresponding comment.
>>
>> Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  block/blk-cgroup.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index bc4dec705572..463c568d3e86 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -1259,7 +1259,7 @@ static int blkcg_css_online(struct cgroup_subsys_state *css)
>>   * blkcg_init_queue - initialize blkcg part of request queue
>>   * @q: request_queue to initialize
>>   *
>> - * Called from blk_alloc_queue(). Responsible for initializing blkcg
>> + * Called from gendisk. Responsible for initializing blkcg
> 
> Maybe be a bit more specific and say blk_alloc_disk()?
Thanks for review. I will update this in next version.
> 
>>   * part of new request_queue @q.
>>   *
>>   * RETURNS:
>> @@ -1321,7 +1321,7 @@ int blkcg_init_queue(struct request_queue *q)
>>   * blkcg_exit_queue - exit and release blkcg part of request_queue
>>   * @q: request_queue being released
>>   *
>> - * Called from blk_exit_queue().  Responsible for exiting blkcg part.
>> + * Called from gendisk.  Responsible for exiting blkcg part.
> 
> Ditto.
> 

-- 
Best wishes
Kemeng Shi
