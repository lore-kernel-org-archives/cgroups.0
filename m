From: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v2] blk-throtl: Introduce sync and async
 queues for blk-throtl
Date: Thu, 22 Dec 2022 23:38:35 +0800
Message-ID: <8c25e591-34d6-7c42-b3a8-dcde86643fe7@bytedance.com>
References: <20221218111314.55525-1-hanjinke.666@bytedance.com>
 <20221221104246.37714-1-hanjinke.666@bytedance.com>
 <20221222133912.GA20830@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+pOD6qK21JMmHtZu4DKvodAq25Aw2OJGG1BCa4STcTM=;
        b=S8hUijCrZmz9w4BtoqIFcausqra1NaLhcNe6XM0w/SlphSKuE4EJO5T/eUeE49HZv1
         SeEj0wpgcKkvbM0XZrs348Utuun9If7AP0hrXdRM2HoyUoz+Htu5KoNvHGDbBbGqIq6G
         98dlnuF+RVoRzmx7lY70fKWKyZMKcpxQvw1N68m+H0ipwVJS3G9brjZroZqpck0oCT5P
         EnDIIs+rEBFZ/P15LXtHOzB9scSEXEnvBwIhhAnaqlwGR9oBAXKOY0qTBtYuGSXL0Xlz
         5+4+6hIIF1v4EnFCeJxSnT9USAbP0KEDC5TyTqmy+8NqQdTUPhE84lgGv+oCaSugCQxo
         12Pg==
In-Reply-To: <20221222133912.GA20830-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org



在 2022/12/22 下午9:39, Michal Koutný 写道:
> Hello Jinke.
> 
> On Wed, Dec 21, 2022 at 06:42:46PM +0800, Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>> In our test, fio writes a 100g file in sequential 4k blocksize in
>> a container with low bps limit configured (wbps=10M). More than 1200
>> ios were throttled in blk-throtl queue and the avarage throtle time
>> of each io is 140s. At the same time, the operation of saving a small
>> file by vim will be blocked amolst 140s. As a fsync will be send by vim,
>> the sync ios of fsync will be blocked by a huge amount of buffer write
>> ios ahead. This is also a priority inversion problem within one cgroup.
>> In the database scene, things got really bad with blk-throtle enabled
>> as fsync is called very often.
> 
> I'm trying to make sense of the numbers:
> - at 10 MB/s, it's 0.4 ms per 4k block
> - there are 1.2k throttled bios that gives waiting time of roughly 0.5s
>    ~ 0.4ms * 1200
> - you say that you observe 280 times longer throttling time,
> - that'd mean there should be 340k queued bios
>    - or cummulative dispatch of ~1400 MB of data
> 
Hi
Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s 
%rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdb              0.00   11.00      0.00      8.01     0.00     0.00 
0.00   0.00    0.00    7.18   0.08     0.00   745.45   3.27   3.60

Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s 
%rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdb              0.00    8.00      0.00      9.14     0.00     0.00 
0.00   0.00    0.00    7.38   0.06     0.00  1170.00   2.62   2.10

Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s 
%rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdb              0.00   16.00      0.00     12.02     0.00    12.00 
0.00  42.86    0.00    7.25   0.12     0.00   769.25   2.06   3.30

Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s 
%rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdb              0.00   11.00      0.00     10.91     0.00     1.00 
0.00   8.33    0.00    6.82   0.07     0.00  1015.64   2.36   2.60

Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s 
%rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdb              0.00   11.00      0.00      9.14     0.00     1.00 
0.00   8.33    0.00    6.27   0.07     0.00   850.91   2.55   2.80

I used bcc to trace the time of bio form submit_bio to blk_mq_submit_bio
and found the avarage time was nearly 140s(use bcc trace fsync duration 
also get the same result).
The iostat above seem the avaerage of each io nearly 1M, so I have rough 
estimate the num of the bio queued is 140s * 10 m / 1m.


> So what are the queued quantities? Are there more than 1200 bios or are
> they bigger than the 4k you mention?
> 
"fio writes a 100g file in sequential 4k blocksize"
Bios may be more than 1M as ext4 will merged continuously logic blocks 
when physical block also continuously.
> Thanks for clarification.
> 
> (I acknowledge the possible problem with a large population of async
> writes delaying scarce sync writes.)
> 
> Michal

If the 0.4ms oberved by iostat, the way to estimate the throtle time of 
the bio by 0.4ms * 1200 may not work as the 0.4 is duration of the 
request from alloc to done.

If the average size of bio is 1m, dispatch one bio should cost 1m/ 10M = 
100ms. The queue is fifo, so the average throtle time 100ms * 1400.

Thanks.
