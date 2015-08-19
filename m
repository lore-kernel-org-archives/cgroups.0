From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Wed, 19 Aug 2015 09:23:23 -0700
Message-ID: <20150819162323.GA20716@mtj.duckdns.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-4-git-send-email-tj@kernel.org>
 <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org>
 <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org>
 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
 <55D3C23F.702@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RuglzHpZgxwYvU4+FZ1vd48XUYbziH4KP3kNtFk1seM=;
        b=Ba4VwqAVKi8zy80L2ogoANIHsCJIlAcxQdgigBgQ79wV4j+5si3AkK6gUbO2UOGUSA
         tJ4ubrZKVSvP6ghyUDlwtLwxnqEMCzmeJutBHvIEKpBxPhirAv9EOGBQRrFsqsjzVdeX
         2ot8FVGKVmSMnOaRxlmebxSrCvA2MP+GJNK3LJBpKrsM6KSqWLd26GLnmxp4bymb6Wfp
         ZNtr4NXTG7H5h5p7Edqy64UFRCOiKyNUzEQ+WfPRuokxekHdKqsH3EuOG6e5olIkMvBr
         6Wxdn07Z0tPfK6UBYSQVdamekdE8U76ylp2HapT7XiW2Uy2SIWylMGMEL3MZZ6qKJ5kz
         Y0zw==
Content-Disposition: inline
In-Reply-To: <55D3C23F.702@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

Hello, Kame.

On Wed, Aug 19, 2015 at 08:39:43AM +0900, Kamezawa Hiroyuki wrote:
> An actual per-thread use case in our customers is qemu-kvm + cpuset.
> customers pin each vcpus and qemu-kvm's worker threads to cpus.
> For example, pinning 4 vcpus to cpu 2-6 and pinning qemu main thread and
> others(vhost) to cpu 0-1.

taskset and/or teach qemu how to confiure its worker threads?

> This is an actual kvm tuning on our customers for performance guarantee.
> 
> In another case, cpu cgroup's throttling feature is used per vcpu for vm cpu sizing.

Yeap, this is something we likely want to implement in an accessible
way.  For kvm, per-thread throttling configuration is enough, right?

Thanks.

-- 
tejun
