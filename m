From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [External] Re: [PATCH linux-next] cgroup: fix suspicious
 rcu_dereference_check() usage warning
Date: Sat, 12 Mar 2022 23:54:28 +0800
Message-ID: <bde81f0b-4b30-1b10-aa2c-bed969675c42@bytedance.com>
References: <20220305034103.57123-1-zhouchengming@bytedance.com>
 <20220312121913.GA28057@worktop.programming.kicks-ass.net>
 <20220312133445.GA28086@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=t5hRVqsCZQix2UY1u0pXX2LoR2L7u3LZkbnGzh3aN1w=;
        b=x0vGbkjA4ZMve+h8aOuwoEFFDAiZeBsbsA3hLtcw48KN9IQYfrMOTSjVdXlMrQnKBS
         8Pwra4IFKSvVJ7Zt9WOkyAxXekH5VxgwAbUiGPnQts8mijCZPi32wSr4q+z4bd/D8bA3
         +vkG0ULgFnefCGx4rC/cP48IvQxQRNbEkqmrBeos2QSV9kv1DjRNrDWfiy+wFQajqd21
         ZCK7Fxtj8+vRYo1YPEUJIDkk/RxafJVAtcSR1YvG7fjOHDwBMYLzdjLJJ1wqoTGoEet7
         eA/6JG+NFqYfX+sFUwTBd9AxJlkC6fcFE/qJnPfOxThHvA/g0LZLKsJ8zLLl5LnlXFZb
         LEBQ==
Content-Language: en-US
In-Reply-To: <20220312133445.GA28086@worktop.programming.kicks-ass.net>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Peter Zijlstra <peterz@infradead.org>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, Linux Kernel Functional Testing <lkft@linaro.org>, syzbot+16e3f2c77e7c5a0113f9@syzkaller.appspotmail.com, Zhouyi Zhou <zhouzhouyi@gmail.com>

On 2022/3/12 9:34 下午, Peter Zijlstra wrote:
> On Sat, Mar 12, 2022 at 01:19:13PM +0100, Peter Zijlstra wrote:
>> On Sat, Mar 05, 2022 at 11:41:03AM +0800, Chengming Zhou wrote:
>>> task_css_set_check() will use rcu_dereference_check() to check for
>>> rcu_read_lock_held() on the read-side, which is not true after commit
>>> dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock"). This
>>> commit drop explicit rcu_read_lock(), change to RCU-sched read-side
>>> critical section. So fix the RCU warning by adding check for
>>> rcu_read_lock_sched_held().
>>>
>>> Fixes: dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock")
>>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>>> Reported-by: syzbot+16e3f2c77e7c5a0113f9@syzkaller.appspotmail.com
>>> Tested-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
>>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
>>
>> Thanks, I'll go stick this in sched/core so it's in the same branch that
>> caused the problem.
> 
> FWIW I never saw this patch because it doesn't instantly look like a
> patch I should be interested in. It's classified as 'for-next' and I
> don't run -next, sfr does that. Then it's tagged as cgroup, which I also
> don't do.

Oh, sorry for this.. I should've add "cpuacct" in the subject. The
"linux-next" prefix was added because I thought any patch based on
the linux-next branch should add this prefix.

> 
> Nowhere does that look like a patch that wants to go in sched/core and
> fixes a cpuacct issue.
> 
> On top of that, I still don't agree with this, I really think
> rcu_dereference_check() itself should be changed.

Yes, I think so too. This patch is workaround to fix the warning to
follow the usage in RCU Documentation.

Maybe changes should be made in RCU code to make rcu_dereference_check()
more flexible as you expressed in the conversation with Paul.

Thanks.
