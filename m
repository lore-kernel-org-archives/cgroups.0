From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH] sched/core: check format and overflows in cgroup2 cpu.max
Date: Tue, 5 Mar 2019 20:03:24 +0300
Message-ID: <4c0f1d90-b147-e1cd-20c1-0cdd869f4f15@yandex-team.ru>
References: <155125520155.293746.7017401430432481979.stgit@buzz>
 <20190305155741.GD50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1551805405; bh=Efq7zsOnvkFWdyEnDBSMbThgQ/W7bl+NeEp+4pmYK2w=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=WGrJxuXJcHLd8tFO6odNGkuNhRXbe41D44BFr6nUhZ9GLD6Cw6RgcV1OsCNrObs6k
         SOrDZ1TW0p9GCBjIiQm53jQZ7/C4BcPC/9F5sWs2JoBcWoK7q8nYJRJWBEITowPnMF
         oZuzT4/nrgK2Xf6rTqXAcwQGZZBK2/zyCj6aiSR0=
In-Reply-To: <20190305155741.GD50184@devbig004.ftw2.facebook.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>

On 05.03.2019 18:57, Tejun Heo wrote:
> Hello,
> 
> On Wed, Feb 27, 2019 at 11:13:21AM +0300, Konstantin Khlebnikov wrote:
>> Cgroup2 interface for cpu bandwidth limit has some flaws:
>>
>> - on stack buffer overflow
>> - no checks for valid format or trailing garbage
>> - no checks for integer overflows
>>
>> This patch fixes all these flaws.
> 
> Ditto as the blkio patch.  Unless there is a correctness problem, my
> preference is towards keeping the parsing functions simple and I don't
> think the kernel needs to play the role of strict input verifier here
> as long as the only foot getting shot is the user's own.

IMHO non-strict interface more likely hides bugs and could cause problems for future changes.

Here is only only one fatal bug - buffer overflow in sscanf because %s has no limit.

Strict validation could be done as more strict sscanf variant or some kind of extension for format string.

> 
> Thanks.
> 
