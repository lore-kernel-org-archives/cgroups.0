From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH-block] blk-cgroup: Use css_tryget() in
 blkcg_destroy_blkgs()
Date: Mon, 28 Nov 2022 10:53:32 -0500
Message-ID: <e89e94b6-6bc8-8d1e-0f6f-ad1ea6c60e0f@redhat.com>
References: <20221128033057.1279383-1-longman@redhat.com>
 <427068db-6695-a1e2-4aa2-033220680eb9@kernel.dk>
 <b9018641-d39f-ff74-8cfb-ba597f5ee0c2@redhat.com>
 <786aacda-b25d-67f6-bad3-0030b0e2637e@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669650817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/AJ0l8IgalwuHi6aQkbaTJH6CSV9/VHsYq9E6VyGE4U=;
        b=eSVRIpgMN4qnDtw6UyLGWp50zUGr667hJajlIZKEyCGApdax7Il/2A8tL1LDwduq8nWYv3
        soV9XutBzerXB7jZ4YYVFbO1lWoF0iRSrHn+r0D30DhA9vV27kjPsH4XZ1RnJYIfVgWKV+
        js1Kt7/VCa/jVTYNIMS1+Bu3edCZBnk=
Content-Language: en-US
In-Reply-To: <786aacda-b25d-67f6-bad3-0030b0e2637e-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 11/28/22 10:42, Jens Axboe wrote:
> On 11/28/22 8:38?AM, Waiman Long wrote:
>> On 11/28/22 09:14, Jens Axboe wrote:
>>> On 11/27/22 8:30?PM, Waiman Long wrote:
>>>> Commit 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction
>>>> path") incorrectly assumes that css_get() will always succeed. That may
>>>> not be true if there is no blkg associated with the blkcg. If css_get()
>>>> fails, the subsequent css_put() call may lead to data corruption as
>>>> was illustrated in a test system that it crashed on bootup when that
>>>> commit was included. Also blkcg may be freed at any time leading to
>>>> use-after-free. Fix it by using css_tryget() instead and bail out if
>>>> the tryget fails.
>>>>
>>>> Fixes: 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction path")
>>>> Reported-by: Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>> ? block/blk-cgroup.c | 7 ++++++-
>>>> ? 1 file changed, 6 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>>>> index 57941d2a8ba3..74fefc8cbcdf 100644
>>>> --- a/block/blk-cgroup.c
>>>> +++ b/block/blk-cgroup.c
>>>> @@ -1088,7 +1088,12 @@ static void blkcg_destroy_blkgs(struct blkcg *blkcg)
>>>> ? ????? might_sleep();
>>>> ? -??? css_get(&blkcg->css);
>>>> +??? /*
>>>> +???? * If css_tryget() fails, there is no blkg to destroy.
>>>> +???? */
>>>> +??? if (!css_tryget(&blkcg->css))
>>>> +??????? return;
>>>> +
>>>> ????? spin_lock_irq(&blkcg->lock);
>>>> ????? while (!hlist_empty(&blkcg->blkg_list)) {
>>>> ????????? struct blkcg_gq *blkg = hlist_entry(blkcg->blkg_list.first,
>>> This doesn't seem safe to me, but maybe I'm missing something. A tryget
>>> operation can be fine if we're under RCU lock and the entity is freed
>>> appropriately, but what makes it safe here? Could blkcg already be gone
>>> at this point?
>> The actual freeing of the blkcg structure is under RCU protection. So
>> the structure won't be freed immediately even if css_tryget() fails. I
>> suspect what Michal found may be the root cause of this problem. If
>> so, this is an existing bug which gets exposed by my patch.
> But what prevents it from going away here since you're not under RCU
> lock for the tryget? Doesn't help that the freeing side is done in an
> RCU safe manner, if the ref attempt is not.

You are right. blkcg_destroy_blkgs() shouldn't be called with all the 
blkcg references gone. Will work on a revised patch.

Cheers,
Longman

