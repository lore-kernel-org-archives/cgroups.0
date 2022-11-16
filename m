From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v10 0/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed, 16 Nov 2022 16:58:34 -0700
Message-ID: <5e885fce-a0b4-559f-5498-4402080f6a2e@kernel.dk>
References: <20221105005902.407297-1-longman@redhat.com>
 <4b5142be-6a47-9dfd-a238-5b9d29b296b8@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kojRkknuzQaruikj1Bw1AgCPwluH/lc+Fu21L+WOJJc=;
        b=RwvO8tezPJW+rHCmdRbQ+mADp1YnOCxf4exyMImXeZ746yvzytYOZgond8mRARU4tL
         pQ0qeYVAciS4yBF7nk1nbOofVyL4B0d4vDYyWLrCKCqfEo7QbjYmVUIae6tmOGUCGZRX
         fBpiXhZ1Dwi9HbTy3EYf8cIC4PNO85VbxGM3vhCGU8/Ag91kGCbRgGflI5IITZxfo1/2
         ZJMk2wHlXJVUeD46A9eZFQaUKXVCSIiP4XB44lA7MDEobMur/ZeYiUenuLAulsMFYKz3
         RbUnHNs3xlJr6g0xMtTRbBgwgAl36Yar5dWjaYRwWoPQqagB5508qtDcaTqP1yrdGiQQ
         E9lw==
Content-Language: en-US
In-Reply-To: <4b5142be-6a47-9dfd-a238-5b9d29b296b8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 11/16/22 4:06 PM, Waiman Long wrote:
> On 11/4/22 20:58, Waiman Long wrote:
>> ? v10:
>> ?? - Update patch 3 to rename the rstat function to
>> ???? cgroup_rstat_css_cpu_flush().
>>
>> ? v9:
>> ?? - Remove patch "llist: Allow optional sentinel node terminated lockless
>> ???? list" for now. This will be done as a follow-up patch.
>> ?? - Add a new lqueued field to blkg_iostat_set to store the status of
>> ???? whether lnode is in a lockless list.
>> ?? - Add a new patch 3 to speed up the freeing of blkcg by flushing out
>> ???? the rstat lockless lists at blkcg offline time.
>>
>> ? v8:
>> ?? - Update the llist patch to make existing llist functions and macros
>> ???? work for both NULL and sentinel terminated lockless list as much
>> ???? as possible and leave only the initialization and removal functions
>> ???? to have a sentinel terminated llist variants.
>>
>> This patch series improves blkcg_rstat_flush() performance by eliminating
>> unnecessary blkg enumeration and flush operations for those blkg's and
>> blkg_iostat_set's that haven't been updated since the last flush.
>>
>> Waiman Long (3):
>> ?? blk-cgroup: Return -ENOMEM directly in blkcg_css_alloc() error path
>> ?? blk-cgroup: Optimize blkcg_rstat_flush()
>> ?? blk-cgroup: Flush stats at blkgs destruction path
>>
>> ? block/blk-cgroup.c???? | 103 +++++++++++++++++++++++++++++++++++------
>> ? block/blk-cgroup.h???? |? 10 ++++
>> ? include/linux/cgroup.h |?? 1 +
>> ? kernel/cgroup/rstat.c? |? 20 ++++++++
>> ? 4 files changed, 119 insertions(+), 15 deletions(-)
> 
> Jens, do you have any further comment on this patchset? Is it possible
> to queue it for the next Linux version?

Looks good to me, I'll queue it up.

-- 
Jens Axboe
