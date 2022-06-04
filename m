From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v6 1/3] blk-cgroup: Correctly free percpu iostat_cpu in
 blkg on error exit
Date: Fri, 3 Jun 2022 22:47:48 -0400
Message-ID: <9fe80bd8-7733-066e-d8eb-5e5bab221e45@redhat.com>
References: <20220602192020.166940-1-longman@redhat.com>
 <20220602192020.166940-2-longman@redhat.com> <Ypq+sPnh6J14PvIZ@T590>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654310871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cqh4lNnb8LUprz/k7VVRsZMriLZ9YvGxKq09h6b6YYk=;
        b=Zf+QEeWfXLxS/vSJlzrKJtdHkrfBSIF/gs4eYGyZhbPk7UBvRmYvtasUKIa0qd6+CgzNqT
        nVV1UhFOG8ELLrO6lY+WMRalHs8Dimac3iR/jQvs5Z0bujsktF2CZNBWJPHRc2VqvIrnfJ
        0x2XX+5fvWMurUnosRDnhkwovJbwCgc=
Content-Language: en-US
In-Reply-To: <Ypq+sPnh6J14PvIZ@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ming Lei <ming.lei@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On 6/3/22 22:08, Ming Lei wrote:
> On Thu, Jun 02, 2022 at 03:20:18PM -0400, Waiman Long wrote:
>> Commit f73316482977 ("blk-cgroup: reimplement basic IO stats using cgroup
>> rstat") changes block cgroup IO stats to use the rstat APIs. It added
>> a new percpu iostat_cpu field into blkg. The blkg_alloc() was modified
>> to allocate the new percpu iostat_cpu but didn't free it when an error
>> happened. Fix this by freeing the percpu iostat_cpu on error exit.
>>
>> Fixes: f73316482977 ("blk-cgroup: reimplement basic IO stats using cgroup rstat")
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> Acked-by: Tejun Heo <tj@kernel.org>
>> ---
>>   block/blk-cgroup.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index 40161a3f68d0..acd9b0aa8dc8 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -219,11 +219,11 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
>>   		return NULL;
>>   
>>   	if (percpu_ref_init(&blkg->refcnt, blkg_release, 0, gfp_mask))
>> -		goto err_free;
>> +		goto err_free_blkg;
>>   
>>   	blkg->iostat_cpu = alloc_percpu_gfp(struct blkg_iostat_set, gfp_mask);
>>   	if (!blkg->iostat_cpu)
>> -		goto err_free;
>> +		goto err_free_blkg;
>>   
>>   	if (!blk_get_queue(q))
>>   		goto err_free;
>> @@ -259,6 +259,9 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
>>   	return blkg;
>>   
>>   err_free:
>> +	free_percpu(blkg->iostat_cpu);
>> +
>> +err_free_blkg:
>>   	blkg_free(blkg);
> Hi Waiman,
>
> But blkg_free() frees blkg->iostat_cpu via blkg_free_workfn(), so I am
> confused where the leak is in failure path?

Yes, you are right. I have overlooked that. So this patch isn't really 
necessary. Thanks for correcting me.

Cheers,
Longman

