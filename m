From: Angelo Ruocco <angelo.ruocco.90@gmail.com>
Subject: Re: [PATCH V2 00/10] unify the interface of the proportional-share
 policy in blkio/io
Date: Mon, 10 Dec 2018 14:45:47 +0100
Message-ID: <CADiTV-29TmkB5-k=TtQfoJqjP2Qv7GSsGLXAPBaTB6DoQ+6yyw@mail.gmail.com>
References: <20181119103424.3853-1-paolo.valente@linaro.org>
 <20181120162816.GV2509588@devbig004.ftw2.facebook.com> <25296DAE-73EC-46CC-9A98-A8B7E9017BB7@linaro.org>
 <7D7FAB43-5F62-4402-A9B3-E7C2E30AE680@linaro.org> <20181130184256.GI2509588@devbig004.ftw2.facebook.com>
 <5534B7D4-A5D9-4F44-9620-970A7F9EC140@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=zZyLLUhZXcYJ2LtJLGESHBqFDN04cjKgYPLf3lUGB3w=;
        b=NzDeZ9KudDpiXL9cdONJSrPvKBsw5xsCqlcR36gRoKo7fa3HU8xHnR7sDtDApmo7By
         78Yv7t8uaY0AVR2yAs/0NOq4fHbkiF3cdlS/NVfLC2XBKdJPs03wvHz5oGiEs1j2NgFa
         ZiZzDJh8lx/Y5U9BgFARDcjBu4wBhz9MSTOOQxK/Y4vw9OfRfHLzcyGO/98wx+cMjptz
         eiVzZ1tQ57KZFCyNkcugCAZL/+lB5o8wdR8V23hYlxMKJ082ob2+P3ZGL/ru9U7HQI75
         bXuBZahoJqwzfmM+IpO9vCHnKTNjeR7KLlTPBc2xt0KMkckofr/Et8CT3giTkJ5Yjwtt
         q27g==
In-Reply-To: <5534B7D4-A5D9-4F44-9620-970A7F9EC140@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>

2018-11-30 19:53 GMT+01:00, Paolo Valente <paolo.valente@linaro.org>:
>
>
>> Il giorno 30 nov 2018, alle ore 19:42, Tejun Heo <tj@kernel.org> ha
>> scritto:
>>
>> Hello, Paolo.
>>
>> On Fri, Nov 30, 2018 at 07:23:24PM +0100, Paolo Valente wrote:
>>>> Then we understood that exactly the same happens with throttling, in
>>>> case the latter is activated on different devices w.r.t. bfq.
>>>>
>>>> In addition, the same may happen, in the near future, with the
>>>> bandwidth controller Josef is working on.  If the controller can be
>>>> configured per device, as with throttling, then statistics may differ,
>>>> for the same interface files, between bfq, throttling and that
>>>> controller.
>>
>> So, regardless of how all these are implemented, what's presented to
>> user should be consistent and clear.  There's no other way around it.
>> Only what's relevant should be visible to userspace.
>>
>>> have you had time to look into this?  Any improvement to this
>>> interface is ok for us. We are only interested in finally solving this
>>> interface issue, as, for what concerns us directly, it has been
>>> preventing legacy code to use bfq for years.
>>
>> Unfortunately, I don't have any implementation proposal, but we can't
>> show things this way to userspace.
>>
>
> Well, this is not very helpful to move forward :)
>
> Let me try to repeat the problem, to try to help you help us unblock
> the situation.
>
> If we have multiple entities attached to the same interface output
> file, you don't find it clear that each entity shows the number it
> wants to show.  But you have no idea either of how that differentiated
> information should be shown.  Is this the situation, or is the problem
> somewhere 'above' this level?
>
> If the problem is as I described it, here are some proposal attempts:
> 1) Do you want file sharing to be allowed only if all entities will
> output the same number?  (this seems excessive, but maybe it makes
> sense)
> 2) Do you want only one number to be shown, equal to the sum of the
> numbers of each entity?  (in some cases, this may make sense)
> 3) Do you prefer an average?
> 4) Do you have any other idea, even if just germinal?

To further add to what Paolo said and better expose the problem, I'd like to
say that all those proposals have issues.
If we only allow "same output" cftypes to be shared then we lose all the
flexibility of this solution, and we need a way for an entity to know other
entities internal variables beforehand, which sounds at least very hard, and
maybe is not even an acceptable thing to do.
To put the average, sum or some other mathematical function in the file only
makes sense for certain cftypes, so also doesn't sound like a good idea. In
fact I can think of scenarios where only seeing the different values of the
entities makes sense for a user.

I understand that the problem is inconsistency: having a file that behaves
differently depending on the situation, and the only way to prevent this I can
think of is to *always* show the entity owner of a certain file (or part of the
output), even when the output would be the same among entities or when the
file is not currently shared but could be. Can this be an acceptable solution?

Angelo

>
> Looking forward to your feedback,
> Paolo
>
>
>> Thanks.
>>
>> --
>> tejun
>>
>> --
>> You received this message because you are subscribed to the Google Groups
>> "bfq-iosched" group.
>> To unsubscribe from this group and stop receiving emails from it, send an
>> email to bfq-iosched+unsubscribe@googlegroups.com.
>> For more options, visit https://groups.google.com/d/optout.
>
>
