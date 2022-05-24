From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v4 4/4] blk-throttle: fix io hung due to config
 updates
Date: Tue, 24 May 2022 19:47:49 +0800
Message-ID: <9b3712a1-1f6d-9c9a-4133-a058fe3b111c@huawei.com>
References: <20220523082633.2324980-1-yukuai3@huawei.com>
 <20220523082633.2324980-5-yukuai3@huawei.com>
 <20220524095936.GB2434@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220524095936.GB2434-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2022/05/24 17:59, Michal Koutný 写道:
> On Mon, May 23, 2022 at 04:26:33PM +0800, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> Fix the problem by respecting the time that throttled bio aready waited.
>> In order to do that, add new fields to record how many bytes/io already
>> waited, and use it to calculate wait time for throttled bio under new
>> configuration.
> 
> This new approach is correctly conserving the bandwidth upon changes.
> (Looking and BPS paths.)
> 
>>
>> Some simple test:
>> 1)
>> cd /sys/fs/cgroup/blkio/
>> echo $$ > cgroup.procs
>> echo "8:0 2048" > blkio.throttle.write_bps_device
>> {
>>          sleep 3
>>          echo "8:0 1024" > blkio.throttle.write_bps_device
>> } &
>> sleep 1
>> dd if=/dev/zero of=/dev/sda bs=8k count=1 oflag=direct
>>
>> 2)
>> cd /sys/fs/cgroup/blkio/
>> echo $$ > cgroup.procs
>> echo "8:0 1024" > blkio.throttle.write_bps_device
>> {
>>          sleep 5
>>          echo "8:0 2048" > blkio.throttle.write_bps_device
>> } &
>> sleep 1
>> dd if=/dev/zero of=/dev/sda bs=8k count=1 oflag=direct
>>
> 
> It's interesting that you're getting these numbers (w/patch)
> 
>> test results: io finish time
>> 	before this patch	with this patch
>> 1)	10s			6s
>> 2)	8s			6s
> 
> wait := (disp + bio - Δt*l_old) / l_new
> 
> 1)
> wait = (0k + 8k - 3s*2k/s) / 1k/s = 2s -> i.e. 5s absolute
> 
> 2)
> wait = (0k + 8k - 5s*1k/s) / 2k/s = 2.5s -> i.e. 6.5s absolute
> 
> Are you numbers noisy+rounded or do I still mis anything?
Hi, Michal

The way of your caculation is right, however, it seems like you missed
that io is dispatched after 1s:

sleep 1  -> here
dd if=/dev/zero of=/dev/sda bs=8k count=1 oflag=direct
> 
> (Also isn't it worth having this more permanent in tools/testing/selftest?)
> 
>> +static void tg_update_skipped(struct throtl_grp *tg)
>> +{
>> +	if (tg->service_queue.nr_queued[READ])
>> +		__tg_update_skipped(tg, READ);
>> +	if (tg->service_queue.nr_queued[WRITE])
>> +		__tg_update_skipped(tg, WRITE);
> 
> On one hand, the callers of tg_update_skipped() know whether R/W limit
> is changed, so only the respective variant could be called.
> On the other hand, this conditions look implied by tg->flags &
> THROTL_TG_PENDING.
> (Just noting, it's likely still not possibly to pass the skipped value
> only via stack.)
> 
> 
>> @@ -115,6 +115,10 @@ struct throtl_grp {
>>   	uint64_t bytes_disp[2];
>>   	/* Number of bio's dispatched in current slice */
>>   	unsigned int io_disp[2];
>> +	/* Number of bytes will be skipped in current slice */
>> +	uint64_t bytes_skipped[2];
>> +	/* Number of bio's will be skipped in current slice */
>> +	unsigned int io_skipped[2];
> 
> Please add a comment these fields exists to facilitate config updates
> (the bytes to be skipped is sort of obvious from the name :-).
Ok, will do that in next iteration.

Thanks,
Kuai
