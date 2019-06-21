From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] BT scheduling class
Date: Fri, 21 Jun 2019 14:36:25 +0200
Message-ID: <20190621123625.GJ3436@hirez.programming.kicks-ass.net>
References: <1561103157-11246-1-git-send-email-xiaoggchen@tencent.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7d0AOZocI1Q8mX1LNBJNSJm0RkC99Q9KWsCv6Fj3D2U=; b=QqilS2cTBLO5CxZgnbs9vg0AZ
        Fw+7J7SF13LrD1619BXFTIM5UIvwH4y6SUicD1rJb09/2Dl0DbdaWDiHspbwMtiJtDCRSoJt2Q3jU
        uqpkRNSpjtzBiPF0iDIoY99ViCz0W5OEmCrGolSJCE3SGXsSN9j+/Ja9zMkc0Mg84HZO1rZ3WL+zb
        t9jbe1HQRgc3aJSRZIaDsR86V8mPZ2ag7k87LFOLm62b6Kt+FJMyk8A0sWMKoSEkj4FY5Ybvj7K3b
        5PUC8nOFttIt//Y1WnBxZudT1nUZWBnuwS8NiaBI9UHrNM5X8D7q+OkJcOczv6Ob7SzL4N6B04IcS
Content-Disposition: inline
In-Reply-To: <1561103157-11246-1-git-send-email-xiaoggchen@tencent.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: xiaoggchen@tencent.com
Cc: jasperwang@tencent.com, heddchen@tencent.com, mingo@redhat.com, linux-kernel@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org

On Fri, Jun 21, 2019 at 03:45:52PM +0800, xiaoggchen@tencent.com wrote:
> From: chen xiaoguang <xiaoggchen@tencent.com>
> 
> This patch set introduces a new scheduler, we name it BT scheduler
> for the moment.

> The BT scheduler is similar with the CFS scheduler. We also use the
> rb-tree as the run queue to save the runnable tasks. And the vruntime 
> concept is also used in the BT scheduler. And the priority of BT scheduler
> is from 140 to 179. So now the schedulers in the kernel are as follows:
> deadline, RT, CFS, BT and idle.

NAK; it has no forward progress guarantees. This is also the reason why
SCHED_IDLE is not a true idle time scheduler but a very low weight CFS
tasks.

It also has some very 'interesting' starvation cases, consider one of
your BT tasks owns a mutex, but then there are there are runnable CFS
tasks. The BT task will never get runtime and release the mutex.

Also; NAK at all the duplication.
