From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/2] block: cancel all throttled bios in del_gendisk()
Date: Fri, 14 Jan 2022 16:21:04 +0800
Message-ID: <c5d1d7b5-b815-0dda-b7d3-8151189a8203@huawei.com>
References: <20220110134758.2233758-1-yukuai3@huawei.com>
 <20220110134758.2233758-3-yukuai3@huawei.com> <Yd5FkuhYX9YcgQkZ@T590>
 <2221953d-be40-3433-d46c-f40acd044482@huawei.com>
 <CAFj5m9KmHB6FtUZ3E42BMZo+=aNNfn2bLu=kNhBOsRdxbfT6nw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFj5m9KmHB6FtUZ3E42BMZo+=aNNfn2bLu=kNhBOsRdxbfT6nw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2022/01/14 11:05, Ming Lei 写道:
> On Thu, Jan 13, 2022 at 04:46:18PM +0800, yukuai (C) wrote:
>> 在 2022/01/12 11:05, Ming Lei 写道:
>>> Hello Yu Kuai,
>>>
>>> On Mon, Jan 10, 2022 at 09:47:58PM +0800, Yu Kuai wrote:
>>>> Throttled bios can't be issued after del_gendisk() is done, thus
>>>> it's better to cancel them immediately rather than waiting for
>>>> throttle is done.
>>>>
>>>> For example, if user thread is throttled with low bps while it's
>>>> issuing large io, and the device is deleted. The user thread will
>>>> wait for a long time for io to return.
>>>>
>>>> Noted this patch is mainly from revertion of commit 32e3374304c7
>>>> ("blk-throttle: remove tg_drain_bios") and commit b77412372b68
>>>> ("blk-throttle: remove blk_throtl_drain").
>>>>
>>>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>    block/blk-throttle.c | 77 ++++++++++++++++++++++++++++++++++++++++++++
>>>>    block/blk-throttle.h |  2 ++
>>>>    block/genhd.c        |  2 ++
>>>>    3 files changed, 81 insertions(+)
>>>
>>> Just wondering why not take the built-in way in throtl_upgrade_state() for
>>> canceling throttled bios? Something like the following, then we can avoid
>>> to re-invent the wheel.
>>>
>>>    block/blk-throttle.c | 38 +++++++++++++++++++++++++++++++-------
>>>    block/blk-throttle.h |  2 ++
>>>    block/genhd.c        |  3 +++
>>>    3 files changed, 36 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>>> index cf7e20804f1b..17e56b2e44c4 100644
>>> --- a/block/blk-throttle.c
>>> +++ b/block/blk-throttle.c
>>> @@ -1816,16 +1816,11 @@ static void throtl_upgrade_check(struct throtl_grp *tg)
>>>              throtl_upgrade_state(tg->td);
>>>    }
>>> -static void throtl_upgrade_state(struct throtl_data *td)
>>> +static void __throtl_cancel_bios(struct throtl_data *td)
>>>    {
>>>      struct cgroup_subsys_state *pos_css;
>>>      struct blkcg_gq *blkg;
>>> -   throtl_log(&td->service_queue, "upgrade to max");
>>> -   td->limit_index = LIMIT_MAX;
>>> -   td->low_upgrade_time = jiffies;
>>> -   td->scale = 0;
>>> -   rcu_read_lock();
>>>      blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg) {
>>>              struct throtl_grp *tg = blkg_to_tg(blkg);
>>>              struct throtl_service_queue *sq = &tg->service_queue;
>>> @@ -1834,12 +1829,41 @@ static void throtl_upgrade_state(struct throtl_data *td)
>>>              throtl_select_dispatch(sq);
>>>              throtl_schedule_next_dispatch(sq, true);
>> Hi, Ming Lei
>>
>> I'm confused that how can bios be canceled here?
>> tg->iops and tg->bps stay untouched, how can throttled bios
>> dispatch?
> 
> I thought that throttled bios will be canceled by 'tg->disptime = jiffies - 1;'
> and the following dispatch schedule.
> 
> But looks it isn't enough, since tg_update_disptime() updates
> ->disptime. However,
> this problem can be solved easily by not updating ->disptime in case that we are
> canceling.
> 
>>>      }
>>> -   rcu_read_unlock();
>>>      throtl_select_dispatch(&td->service_queue);
>>>      throtl_schedule_next_dispatch(&td->service_queue, true);
>>>      queue_work(kthrotld_workqueue, &td->dispatch_work);
>>>    }
>>> +void blk_throtl_cancel_bios(struct request_queue *q)
>>> +{
>>> +   struct cgroup_subsys_state *pos_css;
>>> +   struct blkcg_gq *blkg;
>>> +
>>> +   rcu_read_lock();
>>> +   spin_lock_irq(&q->queue_lock);
>>> +   __throtl_cancel_bios(q->td);
>>> +   spin_unlock_irq(&q->queue_lock);
>>> +   rcu_read_unlock();
>>> +
>>> +   blkg_for_each_descendant_post(blkg, pos_css, q->root_blkg)
>>> +           del_timer_sync(&blkg_to_tg(blkg)->service_queue.pending_timer);
>>> +   del_timer_sync(&q->td->service_queue.pending_timer);
>>
>> By the way, I think delete timer will end up io hung here if there are
>> some bios still be throttled.
> 
> Firstly ->queue_lock is held by blk_throtl_cancel_bios(), so no new bios
> will be throttled.
> 
> Also if we don't update ->disptime, any new bios throttled after releasing
> ->queue_lock will be dispatched soon.

Hi, Ming Lei

Just to be curiosity, I'm still trying to understand the logic here:

For example, if bps is set to 1k, and a io with size 16k is just
dispatched, then io throtle should wait for 16s untill new io can be 
dispatched. (details in tg_with_in_bps_limit）.

How does such mechanism bypassed here?

Thanks,
Kuai
