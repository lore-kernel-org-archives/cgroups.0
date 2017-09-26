From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH cgroup/for-4.15] sched/cputime: Add dummy
 cputime_adjust() implementation for CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
Date: Tue, 26 Sep 2017 11:10:03 +0200
Message-ID: <20170926091003.3kpfdrero6hi262c@hirez.programming.kicks-ass.net>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170925213421.GC560070@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VKt/FLPocmkzWyIZAiPS1ckYt1OWtbkxgfF/RPeIPDo=; b=T8E/PWXuT2SVxu7b4xqWG5Ic3r
        jybhI/YahJFQ4A/pENWY6oxPYEO8lleEKEa4cKQz3GahcXwECby6bPIrAWLVco1ZOVrb+o2p4oRr6
        0WKNyfw6BafM8I6R9X6A6osrgTpAfQRd/wNzpeMnbh+vL0DdulEyL/j+FYjuQ1cwYh8r/q3oMliU6
        rf+yms4w7TDOB8NWKnKKw+riTr9offI5pACTwJV9yro7oq0t3t7TF/v2uC2A6nFYYtBNwVvXDleVd
        8KD1ELF0NM726g41pvM/cYhIIoiECcM8G5z832DD1cTNBuu9Jufnq1Td23S0QNkcbDPXJq6qT8f68
    
Content-Disposition: inline
In-Reply-To: <20170925213421.GC560070@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On Mon, Sep 25, 2017 at 02:34:21PM -0700, Tejun Heo wrote:
> Hello,
> 
> Another follow-up fix.  I missed a dummy implementation leading to
> bulid failure on s390.  Because the bug and fix are trivial, I
> directly applied the patch to cgroup/for-4.15.  Please let me know if
> it should be routed differently.
> 
> Thanks.
> ------ 8< ------
> From 8157a7faf94135386bf04b1cf94e6efd3fb94702 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Mon, 25 Sep 2017 14:27:54 -0700
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> cfb766da54d9 ("sched/cputime: Expose cputime_adjust()") made
> cputime_adjust() public for cgroup basic cpu stat support; however,
> the commit forgot to add a dummy implementaiton for
> CONFIG_VIRT_CPU_ACCOUNTING_NATIVE leading to compiler errors on some
> s390 configurations.
> 
> Fix it by adding the missing dummy implementation.
> 
> Reported-by: “kbuild-all@01.org” <kbuild-all@01.org>
> Fixes: cfb766da54d9 ("sched/cputime: Expose cputime_adjust()")
> Signed-off-by: Tejun Heo <tj@kernel.org>

Seems fine,

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
