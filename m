From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Mon, 15 Jan 2018 17:32:18 +0530
Message-ID: <3c9b2a2d-ede4-1242-418a-353ec9f78db3@codeaurora.org>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <20171211152059.GH2421075@devbig577.frc2.facebook.com>
 <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
 <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
 <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
 <20180102161656.GD3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1516017750;
        bh=hXGYw+S8KV/ije3jPwkkB2mbYJvz86ixoWjjx70XCXQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VJY0xDgBRwcat0JwvPsJH+usEPK6L+P3GX1j02zlq4vCBg/OCCGRUE9e3y3c4Gehn
         mICFZk69cxC0m0LvYaM5ZTukzY8b9DXD6rex8L0ddabd4nvo5Kq+MvcBGDFlW3tegd
         k6mpSpLqX0X/6T3DnOZ3E+q/+Lt2ALzqjs81haL8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1516017749;
        bh=hXGYw+S8KV/ije3jPwkkB2mbYJvz86ixoWjjx70XCXQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Ii3BgR1YHIswTbHG2MPdfM2ippXTDcyUwjj4HjDHpzDWo132u8kd+bvXL8mB6TzZ7
         EooZODuyTLqDwZ81QEMaa9cblX1NSt8BbFlHqh5Mo3f3jxKee7nsyKfqjdVHl2KEdX
         1ZC3SJsF3Qs/iuDUPViDZWUkvF9gBjS6+1Nk1fy4=
In-Reply-To: <20180102161656.GD3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

On 01/02/2018 09:46 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Dec 29, 2017 at 02:07:16AM +0530, Prateek Sood wrote:
>> task T is waiting for cpuset_mutex acquired
>> by kworker/2:1
>>
>> sh ==> cpuhp/2 ==> kworker/2:1 ==> sh 
>>
>> kworker/2:3 ==> kthreadd ==> Task T ==> kworker/2:1
>>
>> It seems that my earlier patch set should fix this scenario:
>> 1) Inverting locking order of cpuset_mutex and cpu_hotplug_lock.
>> 2) Make cpuset hotplug work synchronous.
>>
>> Could you please share your feedback.
> 
> Hmm... this can also be resolved by adding WQ_MEM_RECLAIM to the
> synchronize rcu workqueue, right?  Given the wide-spread usages of
> synchronize_rcu and friends, maybe that's the right solution, or at
> least something we also need to do, for this particular deadlock?
> 
> Again, I don't have anything against making the domain rebuliding part
> of cpuset operations synchronous and these tricky deadlock scenarios
> do indicate that doing so would probably be beneficial.  That said,
> tho, these scenarios seem more of manifestations of other problems
> exposed through kthreadd dependency than anything else.
> 
> Thanks.
> 

Hi TJ,

Thanks for suggesting WQ_MEM_RECLAIM solution.

My understanding of WQ_MEM_RECLAIM was that it needs to be used for
cases where memory pressure could cause deadlocks.

In this case it does not seem to be a memory pressure issue.
Overloading WQ_MEM_RECLAIM usage for solution to another problem
is the correct approach?

This scenario can be resolved by using WQ_MEM_RECLAIM and a separate
workqueue for rcu. But there seems to be a possibility in future if
any cpu hotplug callbacks use other predefined workqueues which do not
have WQ_MEM_RECLAIM option.

Please let me know your feedback on this.


Thanks


-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
