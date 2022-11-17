From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v10 0/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed, 16 Nov 2022 19:45:54 -0500
Message-ID: <26c4e6ab-52ca-e258-bf8d-d4beb86e9c9a@redhat.com>
References: <20221105005902.407297-1-longman@redhat.com>
 <166864313668.13217.6182708630212912209.b4-ty@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668645962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dLyYTR0vgDLPN4t0KFfB1sbFaXYNr5zBEhazg8jRdTg=;
        b=YA5/PL0RJD7i5zxLdjyCOd2T2cAFrXdjB3cBkrJip9/QIOL+0yAchnz34oUx1U7m8aIljL
        ZpX1NBzO1/ruWwCP0nxCsFIl3zS8lcyx0YTANVI2VxBtv1IvJG69HCruOEOmmPFswjn+0D
        3THPtBE8P/mOMpfOEZj+8k9alL7+dL0=
Content-Language: en-US
In-Reply-To: <166864313668.13217.6182708630212912209.b4-ty@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hillf Danton <hdanton@sina.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Ming Lei <ming.lei@redhat.com>

On 11/16/22 18:58, Jens Axboe wrote:
> On Fri, 4 Nov 2022 20:58:59 -0400, Waiman Long wrote:
>>   v10:
>>    - Update patch 3 to rename the rstat function to
>>      cgroup_rstat_css_cpu_flush().
>>
>>   v9:
>>    - Remove patch "llist: Allow optional sentinel node terminated lockless
>>      list" for now. This will be done as a follow-up patch.
>>    - Add a new lqueued field to blkg_iostat_set to store the status of
>>      whether lnode is in a lockless list.
>>    - Add a new patch 3 to speed up the freeing of blkcg by flushing out
>>      the rstat lockless lists at blkcg offline time.
>>
>> [...]
> Applied, thanks!
>
> [1/3] blk-cgroup: Return -ENOMEM directly in blkcg_css_alloc() error path
>        commit: b5a9adcbd5dc95d34d1f5fc84eff9af6fc60d284
> [2/3] blk-cgroup: Optimize blkcg_rstat_flush()
>        commit: 3b8cc6298724021da845f2f9fd7dd4b6829a6817
> [3/3] blk-cgroup: Flush stats at blkgs destruction path
>        commit: dae590a6c96c799434e0ff8156ef29b88c257e60
>
> Best regards,

Thanks a lot!

Cheers,
Longman

