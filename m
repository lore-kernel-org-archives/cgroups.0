From: Prateek Sood <prsood@codeaurora.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Fri, 8 Dec 2017 15:10:05 +0530
Message-ID: <4e63b5e9-1696-910f-16ac-4d4d7eb98725@codeaurora.org>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1512726012;
        bh=uPtRgI5eeQ5qP3SnQCUafgjoamdVfhb1Whv0YfAn4vM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=QXzjDJN1/u7/GxTvD1w7gzJeTIKLbNlDOvALrCVn3GumLLW1asAQz17jzCcDQRB7w
         aiAr2Q6bmu44cUMWgxX3i1pqQE803k5cz9a+Cn7K9wGj+lQVdnC7h3yYsDfricd9f2
         UljIyZf1hjoXii3+UFmoWTwgIFPPb/yJKCH4XPi4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1512726010;
        bh=uPtRgI5eeQ5qP3SnQCUafgjoamdVfhb1Whv0YfAn4vM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HQeWSn6j/T+rjaHFMmCtaKUBypiewUUeiD8ztin8Ist3hFyIQi7bKK7uOBY069U8F
         QF66Q6vE+eWxPHgS51Ji6ELpn2qcs7TzqreouY7H9zmKtAACAtRNmjkLrODueNBAfE
         15XwI8IPxdpp+o3qwIDGAXeZY3IseehCVUUm4NHI=
In-Reply-To: <20171204230117.GF20227@worktop.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Cc: avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

On 12/05/2017 04:31 AM, Peter Zijlstra wrote:
> On Mon, Dec 04, 2017 at 02:58:25PM -0800, Tejun Heo wrote:
>> Hello, again.
>>
>> On Mon, Dec 04, 2017 at 12:22:19PM -0800, Tejun Heo wrote:
>>> Hello,
>>>
>>> On Mon, Dec 04, 2017 at 10:44:49AM +0530, Prateek Sood wrote:
>>>> Any feedback/suggestion for this patch?
>>>
>>> Sorry about the delay.  I'm a bit worried because it feels like we're
>>> chasing a squirrel.  I'll think through the recent changes and this
>>> one and get back to you.
>>
>> Can you please take a look at the following pending commit?
>>
>>   https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git/commit/?h=for-4.15-fixes&id=e8b3f8db7aad99fcc5234fc5b89984ff6620de3d
>>
>> AFAICS, this should remove the circular dependency you originally
>> reported.  I'll revert the two cpuset commits for now.
> 
> So I liked his patches in that we would be able to go back to
> synchronous sched_domain building.
> 
https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git/commit/?h=for-4.15-fixes&id=e8b3f8db7aad99fcc5234fc5b89984ff6620de3d

This will fix the original circular locking dependency issue.
I will let you both (Peter & TJ) to decide on which one to
pick.



-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
