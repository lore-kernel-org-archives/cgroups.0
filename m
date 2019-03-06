From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH] sched/core: check format and overflows in cgroup2 cpu.max
Date: Wed, 6 Mar 2019 20:21:40 +0300
Message-ID: <7c418d64-734e-000c-052a-f6fc59fdcf8e@yandex-team.ru>
References: <155125520155.293746.7017401430432481979.stgit@buzz>
 <20190305155741.GD50184@devbig004.ftw2.facebook.com>
 <4c0f1d90-b147-e1cd-20c1-0cdd869f4f15@yandex-team.ru>
 <20190306161154.GF50184@devbig004.ftw2.facebook.com>
 <20190306164825.GY32477@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1551892901; bh=svhR2/tX9+r+vH6MDX+JmfKjG9q28BbX70lOscStCEg=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=XbZJbzsUScdF1Bru+p5YH3fAQqaUh3dopdNAc45dKqWZt+9eVJwYi0IhrHGbIDIJT
         +oCud92s/7dxdlYTWWXoxUJao4sJTQ0OKwQd7y80lK38X+ygxfJ2lxyhv1kYAzFbPg
         EBkYNDHG6mq7U1fdQNr5pfaJy0lxq3Y4IpzmD0FI=
In-Reply-To: <20190306164825.GY32477@hirez.programming.kicks-ass.net>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>

On 06.03.2019 19:48, Peter Zijlstra wrote:
> On Wed, Mar 06, 2019 at 08:11:54AM -0800, Tejun Heo wrote:
>> Hello, Konstantin.
>>
>> On Tue, Mar 05, 2019 at 08:03:24PM +0300, Konstantin Khlebnikov wrote:
>>>> Ditto as the blkio patch.  Unless there is a correctness problem, my
>>>> preference is towards keeping the parsing functions simple and I don't
>>>> think the kernel needs to play the role of strict input verifier here
>>>> as long as the only foot getting shot is the user's own.
>>>
>>> IMHO non-strict interface more likely hides bugs and could cause
>>> problems for future changes.
>>>
>>> Here is only only one fatal bug - buffer overflow in sscanf because
>>> %s has no limit.
>>
>> Ah, indeed.  Can you please post a patch to fix that problem first?

Done.
Please see [PATCH] sched/core: fix buffer overflow in cgroup2 property cpu.max

>>
>>> Strict validation could be done as more strict sscanf variant or
>>> some kind of extension for format string.
>>
>> I don't necessarily disagree with you; however, what often ends up
>> with these manually crafted parsing approach are 1. code which is
>> unnecessarily difficult to follow 2. different subset of validations
>> and parsing bugs (of course) everywhere.
>>
>> Given the above, I tend to lean towards dump sscanf() parsing.  If we
>> wanna improve the situation, I think the right thing to do is either
>> improving sscanf or introducing new helpers to parse these things
>> rather than hand-crafting each site.  It is really error-prone.

I'm playing with sscanf right now.

Both problems (integer overflows and matching end of string)
are relatively easy to fix without breaking sane compatibility.

> 
> Always use a field width specifier with %s.  Which is exactly what the
> proposed patch did IIRC.
> 
> Maybe that's something checkpatch could warn about.
> 

This could be done mandatory.
In-kernel sscanf always requires width for "%[...]".
