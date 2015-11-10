From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH] cgroup_pids: add fork limit
Date: Tue, 10 Nov 2015 21:49:11 +0530
Message-ID: <CAG53R5XfNjuBcwNZW4pB_bhq2+vLoo1UKQ7Rqhx=TdLMa5abuw@mail.gmail.com>
References: <144716440621.20175.1000688899886388119.stgit@rabbit.intern.cm-ag>
	<CAOviyaiXSCztjv0d99G-t-yo1wtGzXZr0qpuqcKDBdV=wnMinw@mail.gmail.com>
	<5642142F.2090302@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Ij9RilGWCucDYh8K3Qh9810cV2nTs+WPR93PxBY9q9w=;
        b=iuRioFAYMZDKCogeXDdmxNDVk9MSCVzj/LWv46Hswm8sQUm/iT0QctTp+0svFRiV+Z
         dKuA3J/ulCdLIBrDH2s+KuLoSqYq2cwgNyYaASbOHZsqM4DpplcpPY5Md7ldQ2LHODAu
         A8QajjByIx0ZUnCn4YKSkcpIft5820Dkycf2jyZ7G3RPQQ2wSxvxYFeEodlYFQBWS5Vm
         3KX+L8cQjlVTaW6ntpiPMSG+A5SJQ/7hTUgCZD0vusthchZiFDQQI1IHCvrPbw7NB6gP
         8Kv2Dg0T+mA4tpSDL1hGDhnh3d/3BuRMySRAL72Oez01M0aOVImSHHiM5amolfFxufxs
         UxZw==
In-Reply-To: <5642142F.2090302@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Max Kellermann <mk@cm4all.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, max@duempel.org, linux-kernel@vger.kernel.org

On Tue, Nov 10, 2015 at 9:28 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-11-10 10:25, Aleksa Sarai wrote:
>>
>> Processes don't "use up resources" after they've died and been freed
>> (which is dealt with inside PIDs). Yes, lots of small processes that
>> die quickly could (in principle) make hard work for the scheduler, but
>> I don't see how "time spent scheduling in general" is a resource...
>> Fork bombs aren't bad because they cause a lot of fork()s, they're bad
>> because the *create a bunch of processes that use up memory*, which
>> happens because they call fork() a bunch of times and **don't
>> exit()**.
>
> While I'm indifferent about the patch, I would like to point out that
> fork-bombs are also bad because they eat _a lot_ of processor time, and I've
> seen ones designed to bring a system to it's knees just by saturating the
> processor with calls to fork() (which is as slow as or slower than stat() on
> many commodity systems, setting up the various structures for a new process
> is an expensive operation) and clogging up the scheduler.

Isn't cpu cgroup helpful there to limit it?
Are you saying time spent by scheduler is more that actually affects
the scheduling of processes of other threads?
If so, could you share little more insight on how that time measure
outside of the cpu's cgroup cycles? Just so that its helpful to wider
audience.

> This isn't as
> evident of course when you run a fork-bomb on a laptop or similar system,
> because you run out of memory and PID's before the latency from scheduling
> and so many processes calling fork really starts to become noticeable, but
> when you start to look at really big systems (on the order of hundreds of GB
> of RAM), it does become much more noticeable.
>
