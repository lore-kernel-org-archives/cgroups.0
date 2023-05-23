From: Hou Tao <houtao-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v4] blk-ioprio: Introduce promote-to-rt policy
Date: Tue, 23 May 2023 14:48:20 +0800
Message-ID: <bff92f4c-0f21-9cf2-7135-812a184716b3@huaweicloud.com>
References: <20230428074404.280532-1-houtao@huaweicloud.com>
 <1db53a95-46d3-c906-31a1-0be4992a4b8d@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1db53a95-46d3-c906-31a1-0be4992a4b8d-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chaitanya Kulkarni <kch-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "houtao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <houtao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

ping ?

On 5/8/2023 8:08 PM, Hou Tao wrote:
> ping ?
>
> On 4/28/2023 3:44 PM, Hou Tao wrote:
>> From: Hou Tao <houtao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> Since commit a78418e6a04c ("block: Always initialize bio IO priority on
>> submit"), bio->bi_ioprio will never be IOPRIO_CLASS_NONE when calling
>> blkcg_set_ioprio(), so there will be no way to promote the io-priority
>> of one cgroup to IOPRIO_CLASS_RT, because bi_ioprio will always be
>> greater than or equals to IOPRIO_CLASS_RT.
>>
>> It seems possible to call blkcg_set_ioprio() first then try to
>> initialize bi_ioprio later in bio_set_ioprio(), but this doesn't work
>> for bio in which bi_ioprio is already initialized (e.g., direct-io), so
>> introduce a new promote-to-rt policy to promote the iopriority of bio to
>> IOPRIO_CLASS_RT if the ioprio is not already RT.
>>
>> For none-to-rt policy, although it doesn't work now, but considering
>> that its purpose was also to override the io-priority to RT and allowing
>> for a smoother transition, just keep it and treat it as an alias of
>> the promote-to-rt policy.
>>
>> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Reviewed-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
>> Reviewed-by: Chaitanya Kulkarni <kch-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
>> Signed-off-by: Hou Tao <houtao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>> v4:
>>  * rebased on 33afd4b76393
>>  * Add Reviewed-by from Jan Kara
>>
>> v3: https://lore.kernel.org/linux-block/20230223135154.3749088-1-houtao-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org
>>  * Use 'non-RT' instead of 'no-RT' in document (from Bagas)
>>  * Remove repeated sentence in commit message
>>  * Add Reviewed-by and Acked-by tags
>>  
>> v2: https://lore.kernel.org/linux-block/20230220135428.2632906-1-houtao-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org
>>
>>  * Simplify the implementation of promote-to-rt (from Bart)
>>  * Make none-to-rt to work again by treating it as an alias of
>>    the promote-to-rt policy (from Bart & Jan)
>>  * fix the style of new content in cgroup-v2.rst (from Bagas)
>>  * set the default priority level to 4 instead of 0 for promote-to-rt
>>
>> v1: https://lore.kernel.org/linux-block/20230201045227.2203123-1-houtao-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org
>>
>>  Documentation/admin-guide/cgroup-v2.rst | 42 ++++++++++++++-----------
>>  block/blk-ioprio.c                      | 23 ++++++++++++--
>>  2 files changed, 44 insertions(+), 21 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index f67c0829350b..7544ce00e0cb 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -2024,31 +2024,33 @@ that attribute:
>>    no-change
>>  	Do not modify the I/O priority class.
>>  
>> -  none-to-rt
>> -	For requests that do not have an I/O priority class (NONE),
>> -	change the I/O priority class into RT. Do not modify
>> -	the I/O priority class of other requests.
>> +  promote-to-rt
>> +	For requests that have a non-RT I/O priority class, change it into RT.
>> +	Also change the priority level of these requests to 4. Do not modify
>> +	the I/O priority of requests that have priority class RT.
>>  
>>    restrict-to-be
>>  	For requests that do not have an I/O priority class or that have I/O
>> -	priority class RT, change it into BE. Do not modify the I/O priority
>> -	class of requests that have priority class IDLE.
>> +	priority class RT, change it into BE. Also change the priority level
>> +	of these requests to 0. Do not modify the I/O priority class of
>> +	requests that have priority class IDLE.
>>  
>>    idle
>>  	Change the I/O priority class of all requests into IDLE, the lowest
>>  	I/O priority class.
>>  
>> +  none-to-rt
>> +	Deprecated. Just an alias for promote-to-rt.
>> +
>>  The following numerical values are associated with the I/O priority policies:
>>  
>> -+-------------+---+
>> -| no-change   | 0 |
>> -+-------------+---+
>> -| none-to-rt  | 1 |
>> -+-------------+---+
>> -| rt-to-be    | 2 |
>> -+-------------+---+
>> -| all-to-idle | 3 |
>> -+-------------+---+
>> ++----------------+---+
>> +| no-change      | 0 |
>> ++----------------+---+
>> +| rt-to-be       | 2 |
>> ++----------------+---+
>> +| all-to-idle    | 3 |
>> ++----------------+---+
>>  
>>  The numerical value that corresponds to each I/O priority class is as follows:
>>  
>> @@ -2064,9 +2066,13 @@ The numerical value that corresponds to each I/O priority class is as follows:
>>  
>>  The algorithm to set the I/O priority class for a request is as follows:
>>  
>> -- Translate the I/O priority class policy into a number.
>> -- Change the request I/O priority class into the maximum of the I/O priority
>> -  class policy number and the numerical I/O priority class.
>> +- If I/O priority class policy is promote-to-rt, change the request I/O
>> +  priority class to IOPRIO_CLASS_RT and change the request I/O priority
>> +  level to 4.
>> +- If I/O priorityt class is not promote-to-rt, translate the I/O priority
>> +  class policy into a number, then change the request I/O priority class
>> +  into the maximum of the I/O priority class policy number and the numerical
>> +  I/O priority class.
>>  
>>  PID
>>  ---
>> diff --git a/block/blk-ioprio.c b/block/blk-ioprio.c
>> index 055529b9b92b..4051fada01f1 100644
>> --- a/block/blk-ioprio.c
>> +++ b/block/blk-ioprio.c
>> @@ -23,25 +23,28 @@
>>  /**
>>   * enum prio_policy - I/O priority class policy.
>>   * @POLICY_NO_CHANGE: (default) do not modify the I/O priority class.
>> - * @POLICY_NONE_TO_RT: modify IOPRIO_CLASS_NONE into IOPRIO_CLASS_RT.
>> + * @POLICY_PROMOTE_TO_RT: modify no-IOPRIO_CLASS_RT to IOPRIO_CLASS_RT.
>>   * @POLICY_RESTRICT_TO_BE: modify IOPRIO_CLASS_NONE and IOPRIO_CLASS_RT into
>>   *		IOPRIO_CLASS_BE.
>>   * @POLICY_ALL_TO_IDLE: change the I/O priority class into IOPRIO_CLASS_IDLE.
>> + * @POLICY_NONE_TO_RT: an alias for POLICY_PROMOTE_TO_RT.
>>   *
>>   * See also <linux/ioprio.h>.
>>   */
>>  enum prio_policy {
>>  	POLICY_NO_CHANGE	= 0,
>> -	POLICY_NONE_TO_RT	= 1,
>> +	POLICY_PROMOTE_TO_RT	= 1,
>>  	POLICY_RESTRICT_TO_BE	= 2,
>>  	POLICY_ALL_TO_IDLE	= 3,
>> +	POLICY_NONE_TO_RT	= 4,
>>  };
>>  
>>  static const char *policy_name[] = {
>>  	[POLICY_NO_CHANGE]	= "no-change",
>> -	[POLICY_NONE_TO_RT]	= "none-to-rt",
>> +	[POLICY_PROMOTE_TO_RT]	= "promote-to-rt",
>>  	[POLICY_RESTRICT_TO_BE]	= "restrict-to-be",
>>  	[POLICY_ALL_TO_IDLE]	= "idle",
>> +	[POLICY_NONE_TO_RT]	= "none-to-rt",
>>  };
>>  
>>  static struct blkcg_policy ioprio_policy;
>> @@ -189,6 +192,20 @@ void blkcg_set_ioprio(struct bio *bio)
>>  	if (!blkcg || blkcg->prio_policy == POLICY_NO_CHANGE)
>>  		return;
>>  
>> +	if (blkcg->prio_policy == POLICY_PROMOTE_TO_RT ||
>> +	    blkcg->prio_policy == POLICY_NONE_TO_RT) {
>> +		/*
>> +		 * For RT threads, the default priority level is 4 because
>> +		 * task_nice is 0. By promoting non-RT io-priority to RT-class
>> +		 * and default level 4, those requests that are already
>> +		 * RT-class but need a higher io-priority can use ioprio_set()
>> +		 * to achieve this.
>> +		 */
>> +		if (IOPRIO_PRIO_CLASS(bio->bi_ioprio) != IOPRIO_CLASS_RT)
>> +			bio->bi_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 4);
>> +		return;
>> +	}
>> +
>>  	/*
>>  	 * Except for IOPRIO_CLASS_NONE, higher I/O priority numbers
>>  	 * correspond to a lower priority. Hence, the max_t() below selects
> .

