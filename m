From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [RFC] distinguish foreground and background IOs in block throttle
Date: Thu, 28 Dec 2017 09:48:43 +0100
Message-ID: <D3E04C58-031C-4BDE-99B1-5F9EF680A533@linaro.org>
References: <1fa623a6-e374-de5e-477e-e604cb760f82@gmail.com>
 <A491ADB3-5487-4161-A526-E0C3AF416437@linaro.org>
 <02a6f8ff-2f13-9590-93ac-002240f00815@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=No8o7f5J8Q8RbR6JiFQg6pLgnLMOkUQoXW8DW7A2o80=;
        b=Fxacn4DFUMv8GH+q9SRAFNdU2rhU3CWJT9QurWSCrksgezlBAU6Qwq4Bpuf47d2peU
         eoITv/zhUyBq4teooK6qr6JCN2nJo40zNp4wSyiJfurwnZR7znPPSJk8mqtOS9yAvKgN
         yTrBSlEw5rAKZWOxN8S5wjihLsFyMQpFYnVio=
In-Reply-To: <02a6f8ff-2f13-9590-93ac-002240f00815@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joseph Qi <jiangqi903@gmail.com>
Cc: xuejiufei <xuejiufei@gmail.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@fb.com>, Shaohua Li <shli@kernel.org>, linux-block <linux-block@vger.kernel.org>, cgroups@vger.kernel.org, Mark Brown <broonie@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>



> Il giorno 28 dic 2017, alle ore 02:51, Joseph Qi =
<jiangqi903@gmail.com> ha scritto:
>=20
> Hi Paolo,
>=20
> On 17/12/27 20:36, Paolo Valente wrote:
>>=20
>>=20
>>> Il giorno 25 dic 2017, alle ore 03:44, xuejiufei =
<xuejiufei@gmail.com> ha scritto:
>>>=20
>>> Hi all,
>>>=20
>>> Cgroup writeback is supported since v4.2. I found there exists a
>>> problem in the following case.
>>>=20
>>> A cgroup may send both buffer and direct/sync IOs. The foreground
>>> thread will be stalled when periodic writeback IOs is flushed =
because
>>> the service queue already has a plenty of writeback IOs, then
>>> foreground IOs should be enqueued with its FIFO policy.
>>>=20
>>> I wonder if we can distinguish foreground and background IOs in =
block
>>> throttle to fix the above problem.
>>>=20
>>> Any suggestion are always appreciated.
>>>=20
>>=20
>> Hi,
>> to address similar issues, I have just sent a patch [1] for the BFQ
>> I/O scheduler.  If you want to give it a try, it might solve, or at
>> least mitigate, your problem (the patch does not involve groups,
>> though, at least for the moment).
>>=20
>> There are still pending patches related to the low_latency mode of
>> BFQ, so I suggest you to try with low_latency disabled, i.e., as =
root:
>> echo bfq > /sys/block/<your-device>/queue/scheduler
>> echo 0 > /sys/block/<your-device>/queue/iosched/low_latency=20
>>=20
>> For your possible convenience, I have attached the patch, gzipped, to
>> this email too.
>>> Thanks,
>> Paolo
>>=20
>> [1] https://www.spinics.net/lists/kernel/msg2684463.html
>>=20
> I don't get why the issue Jiufei described has relations with =
scheduler.
>=20
> IMO, the core reason is current we only have read/write queues in =
block
> throttle. That means all sync/async writes will go into the same =
queue.
> Once writeback IOs flush out and throttle happens, sync write will =
also
> have to be queued up. Since there are more async writes ahead of sync
> writes in the queue, and the current policy is dispatching 6 reads and =
2
> writes during each round, sync writes will get significantly delay,
> which we don't expect.
>=20
> So like read/write queue design, we may add another queue in block
> throttle to distinguish sync/async writes, and then we can dispatch =
more
> sync writes than async writes.
>=20

Hi Joseph,
your description of the problem would be complete *if* sync write
requests were issued as expected.  But the problem I have seen, and
tried to solve with my patch, is that async requests easily eat all
request tags (I'm referring to blk-mq of course).  So sync I/O has a
hard time finding free tags for its requests, and is then throttled
upstream.  Differentiating throttling downstream may not solve this
problem, because async requests will accumulate upstream as before.
The problem may even get worse, because downstream throttling may
increase the duration of upstream congestion.

My patch tries to solve this upstream problem.  BFQ then does the
rest, downstream, for me.  Things may change in your scenario, though:
you may not have this upstream problem at all, or you may have both
the upstream and the downstream problems.

Thanks,
Paolo

> Thanks,
> Joseph

