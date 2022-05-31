From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Tue, 31 May 2022 15:03:08 -0400
Message-ID: <70a2763a-f7c4-e161-23e4-33815e76380c@redhat.com>
References: <20220531181821.187834-1-longman@redhat.com>
 <YpZdWNGW1bTGnApp@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654023790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cL2SGtd/DsycKVQbAXVtuQFVW3sDNR72Qll7mqMvf/Y=;
        b=Lf4P5Cgax08huI/Zph/LRGF+GuV+I0o5UYaB7xSgObIuAq8CfRznGqB9YkDu7EAl+bdhe0
        yCFY2VJsMTyOqlmT/MvKlw0kjqCI2oh3EzvSpN+LRQx8qgempPhq0DJc3mYqtJcnuMq9x+
        fAB3HC9Cty1PL4xyP7pPVc3PWUst0U4=
Content-Language: en-US
In-Reply-To: <YpZdWNGW1bTGnApp@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On 5/31/22 14:24, Tejun Heo wrote:
> Hello, Waiman.
>
> On Tue, May 31, 2022 at 02:18:21PM -0400, Waiman Long wrote:
>> For a system with many CPUs and block devices, the time to do
>> blkcg_rstat_flush() from cgroup_rstat_flush() can be rather long. It
>> can be especially problematic as interrupt is disabled during the flush.
>> It was reported that it might take seconds in some extreme cases leading
>> to hard lockup messages.
>>
>> As it is likely that not all the percpu blkg_iostat_set's has been
>> updated since the last flush, those stale blkg_iostat_set's don't need
>> to be flushed in this case. This patch optimizes blkcg_rstat_flush()
>> by checking the current sequence number against the one recorded since
>> the last flush and skip the blkg_iostat_set if the sequence number
>> hasn't changed. There is a slight chance that it may miss an update
>> that is being done in parallel, the new update will just have to wait
>> until the next flush.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   block/blk-cgroup.c | 18 +++++++++++++++---
>>   block/blk-cgroup.h |  1 +
>>   2 files changed, 16 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index 40161a3f68d0..79b89af61ef2 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -864,11 +864,23 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
>>   		unsigned long flags;
>>   		unsigned int seq;
>>   
>> +		seq = u64_stats_fetch_begin(&bisc->sync);
>> +		/*
>> +		 * If the sequence number hasn't been updated since the last
>> +		 * flush, we can skip this blkg_iostat_set though we may miss
>> +		 * an update that is happening in parallel.
>> +		 */
>> +		if (seq == bisc->last_seq)
>> +			continue;
> Is this a sufficient solution? The code assumes that there aren't too many
> blkgs for the cgroup, which can be wrong in some cases. Wouldn't it be
> better to create a list of updated blkg's per blkcg so that we don't walk
> all the dormant ones?

It is probably not a sufficient solution, but it is simple. The problem 
with keeping a list of recently updated blkg's is that sequence lock 
does not provide enough synchronization on the read side to guarantee a 
race free reset of the list. It may be doable, but I need to think 
harder on the best way to do it without too much overhead.

Thanks,
Longman

