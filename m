From: Hong zhi guo <honkiko@gmail.com>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Date: Wed, 16 Oct 2013 14:09:40 +0800
Message-ID: <CAA7+ByWjdYTi5uXT6apLYkON1RnrFEGjHU318OD1VMen2YHKOA@mail.gmail.com>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
	<1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
	<20131015173252.GM31215@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=auVH/mDXE0dnKj+67zjPEOuqzR57HiNynrKa7GmHf9k=;
        b=JvLIKyqO4HjJ4VrKuL4Sze6gbbYvLr6s9NInDItHNpmx1MxoEnIDOdDA2w77c39+xi
         3au2pe9UcILUcPvRIFsbxYAbsk6wTjf0yqeriXSruE11rXmLH5TWTDo9RZx+CwaH5Dso
         7awYr9QU2bYkAJb5UxtraO56TuAptR+065Y5iKOp3toNcleQS8ca4oTwUlnBpVaQlFdg
         S460DKYUhLzLtuzj93CJQlE5kYmDI/bAN1A02EayBAYAaLefhitWouDeea+ulM3YdCy9
         lK7WTkDvBl9+KJulsVrik4DSzIS4zN9wFCskS0R0T8SO06GNoC4+crFQF5+ghq7Bjxo1
         +DuA==
In-Reply-To: <20131015173252.GM31215@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>

Hi, Vivek,

Thanks for your careful review. I'll rename t_c to last_dispatch, it's
much better.

For the big burst issue, I've different opinion. Let's discuss it.

Any time a big IO means a big burst. Even if it's throttled at first
time, queued in
the service_queue, and then waited for a while, when it's delivered
out, it IS still
a big burst. So throttling the bio for another while makes no sense.

If a group has been idle for 5 minutes, then it owns the credit to
deliver a big IO
(within 300 * bps bytes). And the extra credit will be cut off after
the delivery.

Waiting for your comments.

Zhiguo


On Wed, Oct 16, 2013 at 1:32 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Oct 14, 2013 at 05:09:17PM +0800, Hong Zhiguo wrote:
>
> [..]
>
> Hi Hong,
>
> Thanks for the token based throttling implementation. In general it looks
> good and it simplies the logic. Couple of comments/concerns below.
>
>> @@ -133,14 +135,13 @@ struct throtl_grp {
>>       /* IOPS limits */
>>       unsigned int iops[2];
>>
>> -     /* Number of bytes disptached in current slice */
>> -     uint64_t bytes_disp[2];
>> -     /* Number of bio's dispatched in current slice */
>> -     unsigned int io_disp[2];
>> +     /* Token for throttling by bps */
>> +     uint64_t bytes_token[2];
>> +     /* Token for throttling by iops */
>> +     unsigned int io_token[2];
>>
>> -     /* When did we start a new slice */
>> -     unsigned long slice_start[2];
>> -     unsigned long slice_end[2];
>> +     /* Time check-point */
>> +     unsigned long t_c[2];
>
> Can we rename this variable to say last_dispatch[2].
>
> [..]
>>
>> @@ -852,41 +708,26 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
>>                                unsigned long *wait)
>>  {
>>       bool rw = bio_data_dir(bio);
>> -     u64 bytes_allowed, extra_bytes, tmp;
>> -     unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
>> -
>> -     jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
>> -
>> -     /* Slice has just started. Consider one slice interval */
>> -     if (!jiffy_elapsed)
>> -             jiffy_elapsed_rnd = throtl_slice;
>> -
>> -     jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, throtl_slice);
>> +     u64 extra_bytes, token;
>> +     unsigned long jiffy_wait;
>>
>> -     tmp = tg->bps[rw] * jiffy_elapsed_rnd;
>> -     do_div(tmp, HZ);
>> -     bytes_allowed = tmp;
>> +     token = (u64)tg->bps[rw] * (jiffies - tg->t_c[rw]);
>
> So here we seem to be calculating how many tokens a group is eligible
> for. This is done based on since last time check. And last time check
> was updated in last dispatch from the group.
>
> What happens if no IO happens in a group for some time, say for 5 minutes,
> and then one big IO comes in. IIUC, we will allow a big burst of IO for
> the first IO (tokens worth of full 5 minutes will be given to this group).
> I think we should have a mechanism where we don't allow too big a burst
> for the first IO. (Possibly limit the burst to THROTL_BURST_IO and
> THROTL_BURST_BYTES until and unless a bigger IO is already queued and
> we are waiting for it).
>
> In previous time slice logic, I took care of it by extend time slice
> by 100ms and if no IO happens in the group for 100ms, time slice will
> expire and next IO will get at max of 100ms of worth of credit (equivalent
> of burst limits).
>
> Thanks
> Vivek



-- 
best regards
Hong Zhiguo
