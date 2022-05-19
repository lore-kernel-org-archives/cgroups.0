From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH -next v3 2/2] blk-throttle: fix io hung due to
 configuration updates
Date: Thu, 19 May 2022 20:14:28 +0800
Message-ID: <a8953189-af42-0225-3031-daf61347524a@huawei.com>
References: <20220519085811.879097-1-yukuai3@huawei.com>
 <20220519085811.879097-3-yukuai3@huawei.com>
 <20220519095857.GE16096@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220519095857.GE16096@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: tj@kernel.org, axboe@kernel.dk, ming.lei@redhat.com, geert@linux-m68k.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

在 2022/05/19 17:58, Michal Koutný 写道:
> Hello Kuayi.
> 
> On Thu, May 19, 2022 at 04:58:11PM +0800, Yu Kuai <yukuai3@huawei.com> wrote:
>> If new configuration is submitted while a bio is throttled, then new
>> waiting time is recaculated regardless that the bio might aready wait
>> for some time:
>>
>> tg_conf_updated
>>   throtl_start_new_slice
>>    tg_update_disptime
>>    throtl_schedule_next_dispatch
>>
>> Then io hung can be triggered by always submmiting new configuration
>> before the throttled bio is dispatched.
> 
> O.K.
> 
>> -	/*
>> -	 * We're already holding queue_lock and know @tg is valid.  Let's
>> -	 * apply the new config directly.
>> -	 *
>> -	 * Restart the slices for both READ and WRITES. It might happen
>> -	 * that a group's limit are dropped suddenly and we don't want to
>> -	 * account recently dispatched IO with new low rate.
>> -	 */
>> -	throtl_start_new_slice(tg, READ);
>> -	throtl_start_new_slice(tg, WRITE);
>> +	throtl_update_slice(tg, old_limits);
> 
> throtl_start_new_slice zeroes *_disp fields.
Hi,

The problem is not just zeroes *_disp fields, in fact, the real problem
is that 'slice_start' is reset to jiffies.

> If for instance, new config allowed only 0.5 throughput, the *_disp
> fields would be scaled to 0.5.
> How that change helps (better) the previously throttled bio to be dispatched?
> 
tg_with_in_bps_limit() is caculating 'wait' based on 'slice_start'and
'bytes_disp':

tg_with_in_bps_limit:
  jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
  tmp = bps_limit * jiffy_elapsed_rnd;
  do_div(tmp, HZ);
  bytes_allowed = tmp; -> how many bytes are allowed in this slice,
		         incluing dispatched.
  if (tg->bytes_disp[rw] + bio_size <= bytes_allowed)
   *wait = 0 -> no need to wait if this bio is within limit

  extra_bytes = tg->bytes_disp[rw] + bio_size - bytes_allowed;
  -> extra_bytes is based on 'bytes_disp'

For example:

1) bps_limit is 2k, we issue two io, (1k and 9k)
2) the first io(1k) will be dispatched, bytes_disp = 1k, slice_start = 0
    the second io(9k) is waiting for (9 - (2 - 1)) / 2 = 4 s
3) after 3 s, we update bps_limit to 1k, then new waiting is caculated:

without this patch:  bytes_disp = 0, slict_start =3:
bytes_allowed = 1k
extra_bytes = 9k - 1k = 8k
wait = 8s

whth this patch: bytes_disp = 0.5k, slice_start =  0,
bytes_allowed = 1k * 3 + 1k = 4k
extra_bytes =  0.5k + 9k - 4k = 5.5k
wait = 5.5s

I hope I can expliain it clearly...

Thanks,
Kuai
> (Is it because you omit update of slice_{start,end}?)
> 
> Thanks,
> Michal
> 
> .
> 
