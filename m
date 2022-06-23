From: Yu Kuai <yukuai3@huawei.com>
Subject: Re: [PATCH -next v5 4/8] blk-throttle: fix io hung due to config
 updates
Date: Thu, 23 Jun 2022 20:27:11 +0800
Message-ID: <f5165488-2461-8946-593f-14154e404850@huawei.com>
References: <20220528064330.3471000-1-yukuai3@huawei.com>
 <20220528064330.3471000-5-yukuai3@huawei.com>
 <20220622172621.GA28246@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220622172621.GA28246@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: tj@kernel.org, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

Hi,

在 2022/06/23 1:26, Michal Koutný 写道:
> (Apologies for taking so long before answering.)
> 
> On Sat, May 28, 2022 at 02:43:26PM +0800, Yu Kuai <yukuai3@huawei.com> wrote:
>> Some simple test:
>> 1)
>> cd /sys/fs/cgroup/blkio/
>> echo $$ > cgroup.procs
>> echo "8:0 2048" > blkio.throttle.write_bps_device
>> {
>>          sleep 2
>>          echo "8:0 1024" > blkio.throttle.write_bps_device
>> } &
>> dd if=/dev/zero of=/dev/sda bs=8k count=1 oflag=direct
>>
>> 2)
>> cd /sys/fs/cgroup/blkio/
>> echo $$ > cgroup.procs
>> echo "8:0 1024" > blkio.throttle.write_bps_device
>> {
>>          sleep 4
>>          echo "8:0 2048" > blkio.throttle.write_bps_device
>> } &
>> dd if=/dev/zero of=/dev/sda bs=8k count=1 oflag=direct
>>
>> test results: io finish time
>> 	before this patch	with this patch
>> 1)	10s			6s
>> 2)	8s			6s
> 
> I agree these are consistent and correct times.
> 
> And the new implementation won't make it worse (in terms of delaying a
> bio) than configuring minimal limits from the beginning, AFACT.
> 
>> @@ -801,7 +836,8 @@ static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
>>   
>>   	/* Round up to the next throttle slice, wait time must be nonzero */
>>   	jiffy_elapsed_rnd = roundup(jiffy_elapsed + 1, tg->td->throtl_slice);
>> -	io_allowed = calculate_io_allowed(iops_limit, jiffy_elapsed_rnd);
>> +	io_allowed = calculate_io_allowed(iops_limit, jiffy_elapsed_rnd) +
>> +		     tg->io_skipped[rw];
>>   	if (tg->io_disp[rw] + 1 <= io_allowed) {
>>   		if (wait)
>>   			*wait = 0;
>> @@ -838,7 +874,8 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
>>   		jiffy_elapsed_rnd = tg->td->throtl_slice;
>>   
>>   	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
>> -	bytes_allowed = calculate_bytes_allowed(bps_limit, jiffy_elapsed_rnd);
>> +	bytes_allowed = calculate_bytes_allowed(bps_limit, jiffy_elapsed_rnd) +
>> +			tg->bytes_skipped[rw];
>>   	if (tg->bytes_disp[rw] + bio_size <= bytes_allowed) {
>>   		if (wait)
>>   			*wait = 0;
>>
> 
> Here we may allow to dispatch a bio above current slice's
> calculate_bytes_allowed() if bytes_skipped is already >0.

Hi, I don't expect that to happen. For example, if a bio is still
throttled, then old slice is keeped with proper 'bytes_skipped',
then new wait time is caculated based on (bio_size - bytes_skipped).

After the bio is dispatched(I assum that other bios can't preempt),
if new slice is started, then 'bytes_skipped' is cleared, there should
be no problem; If old slice is extended, note that we only wait
for 'bio_size - bytes_skipped' bytes, while 'bio_size' bytes is added
to 'tg->bytes_disp'. I think this will make sure new bio won't be
dispatched above slice.

What do you think?
> 
> bytes_disp + bio_size <= calculate_bytes_allowed() + bytes_skipped
> 
> Then on the next update
> 
>> [shuffle]
>> +static void __tg_update_skipped(struct throtl_grp *tg, bool rw)
>> +{
>> +	unsigned long jiffy_elapsed = jiffies - tg->slice_start[rw];
>> +	u64 bps_limit = tg_bps_limit(tg, rw);
>> +	u32 iops_limit = tg_iops_limit(tg, rw);
>> +
>> +	if (bps_limit != U64_MAX)
>> +		tg->bytes_skipped[rw] +=
>> +			calculate_bytes_allowed(bps_limit, jiffy_elapsed) -
>> +			tg->bytes_disp[rw];
>> +	if (iops_limit != UINT_MAX)
>> +		tg->io_skipped[rw] +=
>> +			calculate_io_allowed(iops_limit, jiffy_elapsed) -
>> +			tg->io_disp[rw];
>> +}
> 
> the difference(s) here could be negative. bytes_skipped should be
> reduced to account for the additionally dispatched bio.
> This is all unsigned so negative numbers underflow, however, we add them
> again to the unsigned, so thanks to modular arithmetics the result is
> correctly updated bytes_skipped.
> 
> Maybe add a comment about this (unsigned) intention?

Of course I can do that.
> 
> (But can this happen? The discussed bio would have to outrun another bio
> (the one which defined the current slice_end) but since blk-throttle
> uses queues (FIFO) everywhere this shouldn't really happen. But it's
> good to know this works as intended.)
I can also mention that in comment.
> 
> This patch can have
> Reviewed-by: Michal Koutný <mkoutny@suse.com>
> 

Thanks for the review!
Kuai
