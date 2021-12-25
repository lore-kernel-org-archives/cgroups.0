From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] block, bfq: update pos_root for idle bfq_queue in
 bfq_bfqq_move()
Date: Sat, 25 Dec 2021 15:44:54 +0800
Message-ID: <5b42943f-4a8e-c4ec-05da-57e36cc14113@huawei.com>
References: <20211221032135.878550-1-yukuai3@huawei.com>
 <20211221032135.878550-5-yukuai3@huawei.com>
 <20211221115001.GD24748@quack2.suse.cz>
 <6ca1e924-47fa-b94e-598c-69a9549eb68e@huawei.com>
 <20211222141722.GC685@quack2.suse.cz>
 <9743fc5a-f3f0-a23a-5d21-0c04c90e90e1@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9743fc5a-f3f0-a23a-5d21-0c04c90e90e1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2021/12/25 9:19, yukuai (C) 写道:
> 在 2021/12/22 22:17, Jan Kara 写道:
>> On Wed 22-12-21 11:12:45, yukuai (C) wrote:
>>> 在 2021/12/21 19:50, Jan Kara 写道:
>>>> On Tue 21-12-21 11:21:35, Yu Kuai wrote:
>>>>> During code review, we found that if bfqq is not busy in
>>>>> bfq_bfqq_move(), bfq_pos_tree_add_move() won't be called for the bfqq,
>>>>> thus bfqq->pos_root still points to the old bfqg. However, the ref
>>>>> that bfqq hold for the old bfqg will be released, so it's possible
>>>>> that the old bfqg can be freed. This is problematic because the freed
>>>>> bfqg can still be accessed by bfqq->pos_root.
>>>>>
>>>>> Fix the problem by calling bfq_pos_tree_add_move() for idle bfqq
>>>>> as well.
>>>>>
>>>>> Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling 
>>>>> and cgroups support")
>>>>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>>
>>>> I'm just wondering, how can it happen that !bfq_bfqq_busy() queue is in
>>>> pos_tree? Because bfq_remove_request() takes care to remove bfqq 
>>>> from the
>>>> pos_tree...
>>>
>>> Hi,
>>>
>>> It's right this is not a problem in common case. The problem seems to
>>> relate to queue merging and task migration. Because I once reporduced
>>> it with the same reporducer for the problem that offlined bfqg can be
>>> inserted into service tree. The uaf is exactly in
>>> bfq_remove_request->rb_rease(). However I didn't save the stack...
>>>
>>> I guess this is because bfq_del_bfqq_busy() is called from
>>> bfq_release_process_ref(), and queue merging prevert sunch bfqq to be
>>> freed, thus such bfqq is not in service tree, and it's pos_root can
>>> point to the old bfqg after bfq_bic_update_cgroup->bfq_bfqq_move.
>>>
>>> I haven't confirmed this, however, this patch itself only cleared
>>> bfqq->pos_root for idle bfqq, there should be no harm.
>>
>> Well, I agree this patch does no harm but in my opinion it is just 
>> papering
>> over the real problem which is that we leave bfqq without any request in
>> the pos_tree which can have also other unexpected consequences. I don't
>> think your scenario with bfq_release_process_ref() calling
>> bfq_del_bfqq_busy() really answers my question because we call
>> bfq_del_bfqq_busy() only if RB_EMPTY_ROOT(&bfqq->sort_list) (i.e., 
>> bfqq has
>> no requests) and when sort_list was becoming empty, bfq_remove_request()
>> should have removed bfqq from the pos_tree. So I think proper fix lies
>> elsewhere and I would not merge this patch until we better understand 
>> what
>> is happening in this case.
>>
> 
> Hi,
> 
> I reporduced this problem on v4.19, here is the stack:
> 
> [34094.992162] 
> ==================================================================
> [34094.993121] BUG: KASAN: use-after-free in rb_erase+0x4e0/0x8c0
> [34094.993121] Write of size 8 at addr ffff888126528258 by task 
> kworker/3:1H/554
> [34094.993121]
> [34094.993121] CPU: 3 PID: 554 Comm: kworker/3:1H Not tainted 4.19.90+ #2
> [34094.993121] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
> BIOS ?-20190727_073836-4
> [34094.993121] Workqueue: kblockd blk_mq_run_work_fn
> [34094.993121] Call Trace:
> [34094.993121]  dump_stack+0x76/0xa0
> [34094.993121]  print_address_description+0x6c/0x237
> [34094.993121]  ? rb_erase+0x4e0/0x8c0
> [34094.993121]  kasan_report.cold+0x88/0x2a0
> [34094.993121]  rb_erase+0x4e0/0x8c0
> [34094.993121]  bfq_remove_request+0x239/0x4c0
> [34094.993121]  bfq_dispatch_request+0x658/0x17b0
> [34094.993121]  blk_mq_do_dispatch_sched+0x183/0x220
> [34094.993121]  ? blk_mq_sched_free_hctx_data+0xe0/0xe0
> [34094.993121]  ? __switch_to+0x3b2/0x6c0
> [34094.993121]  blk_mq_sched_dispatch_requests+0x2ac/0x310
> [34094.993121]  ? finish_task_switch+0xa4/0x370
> [34094.993121]  ? dequeue_task_fair+0x216/0x360
> [34094.993121]  ? blk_mq_sched_restart+0x40/0x40
> [34094.993121]  ? __schedule+0x588/0xc10
> [34094.993121]  __blk_mq_run_hw_queue+0x82/0x140
> [34094.993121]  process_one_work+0x39d/0x770
> [34094.993121]  worker_thread+0x78/0x5c0
> [34094.993121]  ? process_one_work+0x770/0x770
> [34094.993121]  kthread+0x1af/0x1d0
> [34094.993121]  ? kthread_create_worker_on_cpu+0xd0/0xd0
> [34094.993121]  ret_from_fork+0x1f/0x30
> [34094.993121]
> [34094.993121] Allocated by task 19184:
> [34094.993121]  kasan_kmalloc+0xc2/0xe0
> [34094.993121]  kmem_cache_alloc_node_trace+0xf9/0x220
> [34094.993121]  bfq_pd_alloc+0x4c/0x510
> [34094.993121]  blkg_alloc+0x237/0x310
> [34094.993121]  blkg_create+0x499/0x5f0
> [34094.993121]  blkg_lookup_create+0x140/0x1b0
> [34094.993121]  generic_make_request_checks+0x5ce/0xad0
> [34094.993121]  generic_make_request+0xd9/0x6b0
> [34094.993121]  submit_bio+0xa6/0x240
> [34094.993121]  mpage_readpages+0x29e/0x3b0
> [34094.993121]  read_pages+0xdf/0x3a0
> [34094.993121]  __do_page_cache_readahead+0x278/0x290
> [34094.993121]  ondemand_readahead+0x275/0x460
> [34094.993121]  generic_file_read_iter+0xc4a/0x1790
> [34094.993121]  blkdev_read_iter+0x8c/0xc0
> [34094.993121]  aio_read+0x174/0x260
> [34094.993121]  io_submit_one+0x7d3/0x14b0
> [34094.993121]  __x64_sys_io_submit+0xfe/0x230
> [34094.993121]  do_syscall_64+0x6f/0x280
> [34094.993121]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [34094.993121]
> [34094.993121] Freed by task 9:
> [34094.993121]  __kasan_slab_free+0x12f/0x180
> [34094.993121]  kfree+0x92/0x1b0
> [34094.993121]  blkg_free.part.0+0x4a/0xe0
> [34094.993121]  rcu_process_callbacks+0x420/0x6c0
> [34094.993121]  __do_softirq+0x109/0x36c
> [34094.993121]
> [34094.993121] The buggy address belongs to the object at ffff888126528000
> [34094.993121]  which belongs to the cache kmalloc-2048 of size 2048
> [34094.993121] The buggy address is located 600 bytes inside of
> [34094.993121]  2048-byte region [ffff888126528000, ffff888126528800)
> [34094.993121] The buggy address belongs to the page:
> [34094.993121] page:ffffea0004994a00 count:1 mapcount:0 
> mapping:ffff88810000e800 index:0xffff0
> [34094.993121] flags: 0x17ffffc0008100(slab|head)
> [34094.993121] raw: 0017ffffc0008100 dead000000000100 dead000000000200 
> ffff88810000e800
> [34094.993121] raw: ffff88812652c400 00000000800f0009 00000001ffffffff 
> 0000000000000000
> [34094.993121] page dumped because: kasan: bad access detected
> [34094.993121]
> [34094.993121] Memory state around the buggy address:
> [34094.993121]  ffff888126528100: fb fb fb fb fb fb fb fb fb fb fb fb fb 
> fb fb fb
> [34094.993121]  ffff888126528180: fb fb fb fb fb fb fb fb fb fb fb fb fb 
> fb fb fb
> [34094.993121] >ffff888126528200: fb fb fb fb fb fb fb fb fb fb fb fb fb 
> fb fb fb
> [34094.993121]                                                     ^
> [34094.993121]  ffff888126528280: fb fb fb fb fb fb fb fb fb fb fb fb fb 
> fb fb fb
> [34094.993121]  ffff888126528300: fb fb fb fb fb fb fb fb fb fb fb fb fb 
> fb fb fb
> [34094.993121] 
> ==================================================================
> 
> I'll try to figure out the root cause, in the meantime, feel free to
> kick around if you have any througts.
> 
> Thansk,
> Kuai
>>                                 Honza
>>

Hi,

I finally figure out the root cause... This is introduced by a temporary
fix of the problem that offlined bfqg is reinserted into service tree.

The temporary fix is as follow:

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 24a5c5329bcd..ee1933cd9a43 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -935,6 +935,7 @@ static void bfq_pd_offline(struct blkg_policy_data *pd)

  put_async_queues:
         bfq_put_async_queues(bfqd, bfqg);
+       pd->plid = BLKCG_MAX_POLS;

         spin_unlock_irqrestore(&bfqd->lock, flags);
         /*
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index b74cc0da118e..fa2062244805 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1692,6 +1692,15 @@ void bfq_del_bfqq_busy(struct bfq_data *bfqd, 
struct bfq_queue *bfqq,
   */
  void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq)
  {
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+       /* If parent group is offlined, move the bfqq to root group */
+       if (bfqq->entity.parent) {
+               struct bfq_group *bfqg = bfq_bfqq_to_bfqg(bfqq);
+
+               if (bfqg->pd.plid >= BLKCG_MAX_POLS)
+                       bfq_bfqq_move(bfqd, bfqq, bfqd->root_group);
+       }
+#endif
         bfq_log_bfqq(bfqd, bfqq, "add to busy");

I add bfq_bfqq_move() here before bfq_mark_bfqq_busy(), which cause
the problem...

Thanks,
Kuai
