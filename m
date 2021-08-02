From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] blk-throtl: optimize IOPS throttle for large IO
 scenarios
Date: Mon, 2 Aug 2021 09:30:29 +0800
Message-ID: <c40d1fbf-30de-2325-a662-8fd08aa1b774@gmail.com>
References: <40915233274d31bb0659ff9f3be8900a5a0e81ba.1627462548.git.brookxu@tencent.com>
 <YQLhRrkZrmKTzfbP@mtj.duckdns.org>
 <1ce9bcbb-8eea-f51f-f80a-22caf5f2e0d8@gmail.com>
 <YQQjpQEBbdAgMUM7@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u4+MOjnojz3+/+7/XlAa+2lsmVmxt23PCyNNCzzoHqU=;
        b=PZvnds9W8ZafmGzDHBzMjB7paCr1nbUI3ppOFf7WVrfZB20/0F/sfiuY3drYdUMazs
         JQPTN4iaFD3Sn4Qa4vu7DJEpl0mESfDJ9M/qV8CZ2NaOcpyvISlKPaxOHjw7VKkRZ8Ck
         bLnm8d2ogQFaYeEyvXCkivWxtYUTQUjKB+JjN00ZyB3q8hJD56MYjCfaDKHvPFZjPT5z
         S4d1J2bnfdVTLhj4QH78AXcubwXjUQIdhxqQ2K4+iA9mO/OG2t0ZIHWGDSuj4JIXJYUN
         Bv8965hDlj8R3JV5jNZSLLrA32zyGnbKNmD9DCEVD6YVVvDYOjYtOjbjymhRvHuYfpqy
         dw5Q==
In-Reply-To: <YQQjpQEBbdAgMUM7-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



Tejun Heo wrote on 2021/7/31 12:07 上午:
> On Fri, Jul 30, 2021 at 10:09:34AM +0800, brookxu wrote:
>>>> @@ -877,10 +900,19 @@ static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
>>>>  	else
>>>>  		tg->bytes_disp[rw] = 0;
>>>>  
>>>> -	if (tg->io_disp[rw] >= io_trim)
>>>> +	if (tg_io_disp(tg, rw) >= io_trim) {
>>>
>>> Instead of checking this in multiple places, would it be simpler to transfer
>>> the atomic counters to the existing counters whenever we enter blk-throtl
>>> and leave the rest of the code as-is?
>>
>> If we do this, we need to do similar processing on the bio submission path and the bio
>> resubmission path in pending_timer. It seems that the code is more complicated?
> 
> Yeah, basically whenever we enter blk-throtl. Factored to a function,
> calling it on entry should be fairly clean, right? I wonder whether it'd be
> better to consolidate all atomic counter handling in a single location and
> all it does is transferring whatever's accumulated to the usual counters.
> Also, when you're reading & resetting the atomic counters, can you use a
> pattern like the following?
> 
>   main_counter += atomic_xchg(counter, 0);
> 
> Right now, there's a race window between reading and resetting.

Yeah, thanks for your suggestion, I will submit the next version later.

> Thanks.
> 
