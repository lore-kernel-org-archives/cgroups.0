From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v8 3/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Thu, 6 Oct 2022 17:34:30 -0400
Message-ID: <5125cfc1-7710-9145-bf42-1826a30514e9@redhat.com>
References: <20221004151748.293388-1-longman@redhat.com>
 <20221006101141.1832-1-hdanton@sina.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665092075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z5KDkZsZZPUp3zvan69x4fPFamZUOxTgDM1WYdBR6n4=;
        b=Y3SMvA28jy38zyRl7OqxkHxczXhorHiVMe1TUf9OsxVMww+xyeMJVAS88LkSNaRDW4NvCC
        XVmGHnnOlZIbuXqUkh7ejywAFkJX0asZOuDvWRvWSS7EsmvJCEgF6xQW2/ZNAxr/mgHDoF
        6VUm3wZR7Nh2+Qml2uU49H0yOFIGb7s=
Content-Language: en-US
In-Reply-To: <20221006101141.1832-1-hdanton@sina.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hillf Danton <hdanton@sina.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>

On 10/6/22 06:11, Hillf Danton wrote:
> On 4 Oct 2022 11:17:48 -0400 Waiman Long <longman@redhat.com>
>> For a system with many CPUs and block devices, the time to do
>> blkcg_rstat_flush() from cgroup_rstat_flush() can be rather long. It
>> can be especially problematic as interrupt is disabled during the flush.
>> It was reported that it might take seconds to complete in some extreme
>> cases leading to hard lockup messages.
>>
>> As it is likely that not all the percpu blkg_iostat_set's has been
>> updated since the last flush, those stale blkg_iostat_set's don't need
>> to be flushed in this case. This patch optimizes blkcg_rstat_flush()
>> by keeping a lockless list of recently updated blkg_iostat_set's in a
>> newly added percpu blkcg->lhead pointer.
>>
>> The blkg_iostat_set is added to a sentinel lockless list on the update
>> side in blk_cgroup_bio_start(). It is removed from the sentinel lockless
>> list when flushed in blkcg_rstat_flush(). Due to racing, it is possible
>> that blk_iostat_set's in the lockless list may have no new IO stats to
>> be flushed, but that is OK.
> So it is likely that another flag, updated when bis is added to/deleted
> from llist, can cut 1/3 off without raising the risk of getting your patch
> over complicated.
>
>>   
>>   struct blkg_iostat_set {
>>   	struct u64_stats_sync		sync;
>> +	struct llist_node		lnode;
>> +	struct blkcg_gq		       *blkg;
> +	atomic_t			queued;
>
>>   	struct blkg_iostat		cur;
>>   	struct blkg_iostat		last;
>>   };

Yes, by introducing a flag to record the lockless list state, it is 
possible to just use the current llist implementation. Maybe I can 
rework it for now without the sentinel variant and post a separate llist 
patch for that later on.

Cheers,
Longman

