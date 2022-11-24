From: Kemeng Shi <shikemeng@huawei.com>
Subject: Re: [PATCH 05/11] blk-throttle: simpfy low limit reached check in
 throtl_tg_can_upgrade
Date: Thu, 24 Nov 2022 20:52:50 +0800
Message-ID: <64e54286-2c77-7162-4d50-1c644d1f0caf@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-6-shikemeng@huawei.com>
 <Y35l3cRfYNgCzBgC@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Y35l3cRfYNgCzBgC@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



on 11/24/2022 2:26 AM, Tejun Heo wrote:
> On Wed, Nov 23, 2022 at 02:03:55PM +0800, Kemeng Shi wrote:
>> -static bool throtl_tg_can_upgrade(struct throtl_grp *tg)
>> +static bool throtl_tg_reach_low_limit(struct throtl_grp *tg, int rw)
>>  {
>>  	struct throtl_service_queue *sq = &tg->service_queue;
>> -	bool read_limit, write_limit;
>> +	bool limit = tg->bps[rw][LIMIT_LOW] || tg->iops[rw][LIMIT_LOW];
>>  
>>  	/*
>>  	 * if cgroup reaches low limit (if low limit is 0, the cgroup always
>>  	 * reaches), it's ok to upgrade to next limit
>>  	 */
>> -	read_limit = tg->bps[READ][LIMIT_LOW] || tg->iops[READ][LIMIT_LOW];
>> -	write_limit = tg->bps[WRITE][LIMIT_LOW] || tg->iops[WRITE][LIMIT_LOW];
>> -	if (!read_limit && !write_limit)
>> -		return true;
>> -	if (read_limit && sq->nr_queued[READ] &&
>> -	    (!write_limit || sq->nr_queued[WRITE]))
>> -		return true;
>> -	if (write_limit && sq->nr_queued[WRITE] &&
>> -	    (!read_limit || sq->nr_queued[READ]))
>> +	return !limit || sq->nr_queued[rw].
>> +}
>> +
>> +static bool throtl_tg_can_upgrade(struct throtl_grp *tg)
>> +{
>> +	if (throtl_tg_reach_low_limit(tg, READ) &&
>> +	    throtl_tg_reach_low_limit(tg, WRITE))
> 
> Are the conditions being checked actually equivalent? If so, can you
> explicitly explain that these are equivalent conditions? If not, what are we
> changing exactly?All replaced conditions to return true are as following:
condition 1
(!read_limit && !write_limit)
condition 2
read_limit && sq->nr_queued[READ] && (!write_limit || sq->nr_queued[WRITE])
condition 3
write_limit && sq->nr_queued[WRITE] && (!read_limit || sq->nr_queued[READ])

Transfering condition 2 as following:
read_limit && sq->nr_queued[READ] && (!write_limit || sq->nr_queued[WRITE])
is equivalent to
(read_limit && sq->nr_queued[READ]) &&
(!write_limit || (write_limit && sq->nr_queued[WRITE]))
is equivalent to
(read_limit && sq->nr_queued[READ] && !write_limit) ||
((read_limit && sq->nr_queued[READ] && (write_limit && sq->nr_queued[WRITE]))

Transfering condition 3 as following:
write_limit && sq->nr_queued[WRITE] && (!read_limit || sq->nr_queued[READ])
is equivalent to
(write_limit && sq->nr_queued[WRITE]) &&
(!read_limit || (read_limit && sq->nr_queued[READ]))
is equivalent to
((write_limit && sq->nr_queued[WRITE]) && !read_limit) ||
((write_limit && sq->nr_queued[WRITE]) && (read_limit && sq->nr_queued[READ]))

All replaced conditions to return true are collected as folloing:
condition 1.1
(!read_limit && !write_limit)
condition 1.2
(read_limit && sq->nr_queued[READ] && !write_limit)
condition 1.3
((read_limit && sq->nr_queued[READ] && (write_limit && sq->nr_queued[WRITE]))
condition 1.4
(write_limit && sq->nr_queued[WRITE]) && !read_limit)
condition 1.5 (the same as 1.3, can be ingored)
(write_limit && sq->nr_queued[WRITE]) && (read_limit && sq->nr_queued[READ]))

Condtions to return true in this patch is:
(!read_limit || (read_limit && sq->nr_queued[READ])) &&
(!write_limit || (write_limit && sq->nr_queued[WRITE]))
As "(a || b) && (c || d)" can be extracted to
(a && c) or (a && d) or (b && c) or (b && d ). So we can extract condtions to
condition 2.1
!read_limit && !write_limit
condition 2.2
!read_limit && (write_limit && sq->nr_queued[WRITE])
condition 2.3
(read_limit && sq->nr_queued[READ]) && !write_limit
condition 2.4
(read_limit && sq->nr_queued[READ]) && (write_limit && sq->nr_queued[WRITE])

Conditions match as following:
condition 1.1 = condition 2.1
condition 1.2 = condition 2.3
condition 1.3 = condition 2.4
condition 1.4 = condition 2.2

-- 
Best wishes
Kemeng Shi
