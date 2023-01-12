From: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v5] blk-throtl: Introduce sync and async
 queues for blk-throtl
Date: Thu, 12 Jan 2023 16:42:00 +0800
Message-ID: <7a348aec-0e5c-ec6a-36cd-30a844d276ad@bytedance.com>
References: <20230111162030.31094-1-hanjinke.666@bytedance.com>
 <Y77sVSbS6fIXh3jp@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEg4bQ6lpGrIUrq1T+gt3Ejj1Swr0qeWVL35vq5Po6U=;
        b=taeeV0OMcAkInTg8vAnOBHKivystFadZ28hvDI0CRtwa+zGUkmuuJu7s9CY8olfEfk
         qYZrKNb6EcrIunkCdUNwZOAq4VfeqVujcPa7tVQc8BA76qqjKZhZAhBzWc+jX2sqof7r
         ul7kG0Bjc5Tc10dUdtw0rTwQte2dYX1xBwWVBKzngl1A8MkFOwgTRwbnDYREbIb+YN4k
         6hOeggaxJLEhFqPiB2Pt7c7cFL+PaDDjC86ZHH2OgweCaxY+gCMRhjR3u7Lo0awYAExv
         3KMpqRcm6JSeIgk5HKR3aosi302Hjr+guXh7/sC/IeC0DvalkGby20ZNib2af+AOc5Fc
         AJsA==
In-Reply-To: <Y77sVSbS6fIXh3jp-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org



在 2023/1/12 上午1:05, Tejun Heo 写道:
> On Thu, Jan 12, 2023 at 12:20:30AM +0800, Jinke Han wrote:
>> From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>>
>> Now we don't distinguish sync write ios from normal buffer write ios
>> in blk-throtl. A bio with REQ_SYNC tagged always mean it will be wait
>> until write completion soon after it submit. So it's reasonable for sync
>> io to complete as soon as possible.
>>
>> In our test, fio writes a 100g file in sequential 4k blocksize in
>> a container with low bps limit configured (wbps=10M). More than 1200
>> ios were throttled in blk-throtl queue and the avarage throtle time
>> of each io is 140s. At the same time, the operation of saving a small
>> file by vim will be blocked amolst 140s. As a fsync will be send by vim,
>> the sync ios of fsync will be blocked by a huge amount of buffer write
>> ios ahead. This is also a priority inversion problem within one cgroup.
>> In the database scene, things got really bad with blk-throtle enabled
>> as fsync is called very often.
>>
>> This patch splits bio queue into sync and async queues for blk-throtl
>> and gives a huge priority to sync write ios. Sync queue only make sense
>> for write ios as we treat all read io as sync io. I think it's a nice
>> respond to the semantics of REQ_SYNC. Bios with REQ_META and REQ_PRIO
>> gains the same priority as they are important to fs. This may avoid
>> some potential priority inversion problems.
>>
>> With this patch, do the same test above, the duration of the fsync sent
>> by vim drops to several hundreds of milliseconds.
>>
>> Signed-off-by: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>> Signed-off-by: Xin Yin <yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> with some nits below:
> 
>> +/**
>> + * throtl_qnode_bio_peek - peek a bio from a qn
>> + * @qn: the qnode to peek from
>> + *
>> + * For read, always peek bio from the SYNC queue.
>> + *
>> + * For write, we always peek bio from next_to_disp. If it's NULL, a bio
>                      ^
>                      first
> 
>> + * will be popped from SYNC or ASYNC queue to fill it. The next_to_disp
>> + * is used to make sure that the peeked bio and the next popped bio are
>                                     ^
>                                     previously
> 
>> + * always the same even in case that the spinlock of queue was released
>> + * and re-holded.
>            ^
>            re-grabbed / re-acquired
>> + *
>> + * Without the next_to_disp, consider the following situation:
>        ^^^^^^^^^^^^^^^^^^^^^^^^^^
>        maybe drop this part and move the latter part to the end of the
>        previous para?
> 
>> + * Assumed that there are only bios queued in ASYNC queue and the SYNC
>        ^
>        Assume
> 
>> + * queue is empty and all ASYNC bios are 1M in size and the bps limit is
>> + * 1M/s. The throtl_slice is 100ms. The current slice is [jiffies1,
>> + * jiffies1+100] and the bytes_disp[w] is 0.
>> + *
>> + * The disp_sync_cnt is 0 as it was set 0 after each dispatching of a
>> + * ASYNC bio. A ASYNC bio wil be peeked to check in tg_may_dispatch.
>> + * Obviously, it can't be dispatched in current slice and the wait time
>> + * is 900ms. The slice will be extended to [jiffies1, jiffies1+1000] in
>> + * tg_may_dispatch. The spinlock of the queue will be released after the
>> + * process of dispatch giving up. A 4k size SYNC bio was queued in and
>> + * the SYNC queue becomes no-empty. After 900ms, it's time to dispatch
>> + * the tg, the SYNC bio will be popped to dispatched as the disp_sync_cnt
>> + * is 0 and the SYNC queue is no-empty. The slice will be extended to
>        ^
>   Maybe combine the previous several sentences like:
> 
>   The queue lock is released and a 4k SYNC bio gets queued during the 900ms
>   wait.
> 
>> + * [jiffies1, jiffies1+1100] in tg_may_dispatch. Then the slice will be
>> + * trimed to [jiffies1+1000, jiffies1+1100] after the SYNC bio was
>> + * dispatched. Then the former 1M size ASYNC bio will be peeked to be
>> + * checked and still can't be dispatched because of overlimit within
>> + * the current slice. The same thing may happen DISPACH_SYNC_FACTOR times
>> + * if always there is a SYNC bio be queued in the SYNC queue when the
>> + * ASYNC bio is waiting. This means that in nearly 5s, we have dispathed
>> + * four 4k SYNC bios and one  1M ASYNC bio. It is hard to fill up the
>> + * bandwidth considering that the bps limit is 1M/s.
> 
> Simiarly I think the information can be conveyed in a more compact form.
> 
> Thanks.
> 
The comment will be further adjusted based on your suggestions and the
v6 with your Acked-by will be send.

Thanks
Jinke
