From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH linux-next] cgroup: fix suspicious
 rcu_dereference_check() usage warning
Date: Sat, 12 Mar 2022 13:19:13 +0100
Message-ID: <20220312121913.GA28057@worktop.programming.kicks-ass.net>
References: <20220305034103.57123-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eRnc6vlsmRO1Y1RmkkGHlXz1PK19hiSpeYsvyREcC+Y=; b=N4F02rcgKJXU3K6baufAPA18s8
        cY9MWsekOHh8nU5Og60K8SmZ2I4zD/aAc5sWGjc/MpHo/zzvT5B2n+xQci/A+nwWlvAVOb5/984t6
        D//Kne/vH2JHuKIyyPFR0QTDI8I1NZ4nVgmn+XFt1iYEm3fGzfBY8Rywz1ben3QSef9Ht7y2FBHP3
        H2vqsRPUdmH124JJD6QoZ8BF+USZ3IcMEsTgtKOY7ESVTCW+/XlkCR0s8H4/TxIeXsAkSLZABiTO5
        78SuXQ8OayCXjIIC52np5NRdcI1KQTP6UiFCfRS2kAp4C/JOkl56gllTEofivplmrDHxXxY9Raryf
        6mMYnbUg==;
Content-Disposition: inline
In-Reply-To: <20220305034103.57123-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, Linux Kernel Functional Testing <lkft@linaro.org>, syzbot+16e3f2c77e7c5a0113f9@syzkaller.appspotmail.com, Zhouyi Zhou <zhouzhouyi@gmail.com>

On Sat, Mar 05, 2022 at 11:41:03AM +0800, Chengming Zhou wrote:
> task_css_set_check() will use rcu_dereference_check() to check for
> rcu_read_lock_held() on the read-side, which is not true after commit
> dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock"). This
> commit drop explicit rcu_read_lock(), change to RCU-sched read-side
> critical section. So fix the RCU warning by adding check for
> rcu_read_lock_sched_held().
> 
> Fixes: dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock")
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Reported-by: syzbot+16e3f2c77e7c5a0113f9@syzkaller.appspotmail.com
> Tested-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>

Thanks, I'll go stick this in sched/core so it's in the same branch that
caused the problem.

