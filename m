From: Joseph Qi <jiangqi903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] distinguish foreground and background IOs in block throttle
Date: Thu, 28 Dec 2017 09:51:09 +0800
Message-ID: <02a6f8ff-2f13-9590-93ac-002240f00815@gmail.com>
References: <1fa623a6-e374-de5e-477e-e604cb760f82@gmail.com>
 <A491ADB3-5487-4161-A526-E0C3AF416437@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RehtXE2aIMH0Qs7EgNv3pyaa0xXa9KjE1i6V8NQJ+QE=;
        b=uhzEKmGNuR0qkU/D3ez6kvT1I3/OnnNpKj2ZiwiSPt+22STa/NaQMlx2Xw9uj0TTSb
         Nn/JvyHFW6tZDlCvId3cT/ffvDta/NlNbvhjU4Z/kV3/Q2Q2Smo0ec6owmb+P/H/gWyI
         NFRs7NLOxfTH97iraiVje9KUP0V1KJjFByvF9UUfT/qMhiTCitxddWwRtuIcltybTlm7
         G8jFiEQo17sDDJ6OX/ZdHPsGtf2c/fzSYszlXIBAjgBT3TKDqAmjZ95BtgLI986mEOxX
         R4psSvZALFuUh9WJg/1j1BkODoUnnZsu4DbE7gzaFxYO7z8BGQ8AWIeE5DHTOBNQ89cu
         nWvg==
In-Reply-To: <A491ADB3-5487-4161-A526-E0C3AF416437-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, xuejiufei <xuejiufei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulf Hansson <ulf.hansson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Hi Paolo,

On 17/12/27 20:36, Paolo Valente wrote:
> 
> 
>> Il giorno 25 dic 2017, alle ore 03:44, xuejiufei <xuejiufei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> ha scritto:
>>
>> Hi all,
>>
>> Cgroup writeback is supported since v4.2. I found there exists a
>> problem in the following case.
>>
>> A cgroup may send both buffer and direct/sync IOs. The foreground
>> thread will be stalled when periodic writeback IOs is flushed because
>> the service queue already has a plenty of writeback IOs, then
>> foreground IOs should be enqueued with its FIFO policy.
>>
>> I wonder if we can distinguish foreground and background IOs in block
>> throttle to fix the above problem.
>>
>> Any suggestion are always appreciated.
>>
> 
> Hi,
> to address similar issues, I have just sent a patch [1] for the BFQ
> I/O scheduler.  If you want to give it a try, it might solve, or at
> least mitigate, your problem (the patch does not involve groups,
> though, at least for the moment).
> 
> There are still pending patches related to the low_latency mode of
> BFQ, so I suggest you to try with low_latency disabled, i.e., as root:
> echo bfq > /sys/block/<your-device>/queue/scheduler
> echo 0 > /sys/block/<your-device>/queue/iosched/low_latency 
> 
> For your possible convenience, I have attached the patch, gzipped, to
> this email too.
> > Thanks,
> Paolo
> 
> [1] https://www.spinics.net/lists/kernel/msg2684463.html
> 
I don't get why the issue Jiufei described has relations with scheduler.

IMO, the core reason is current we only have read/write queues in block
throttle. That means all sync/async writes will go into the same queue.
Once writeback IOs flush out and throttle happens, sync write will also
have to be queued up. Since there are more async writes ahead of sync
writes in the queue, and the current policy is dispatching 6 reads and 2
writes during each round, sync writes will get significantly delay,
which we don't expect.

So like read/write queue design, we may add another queue in block
throttle to distinguish sync/async writes, and then we can dispatch more
sync writes than async writes.

Thanks,
Joseph
