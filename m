From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Tue, 2 Jan 2018 08:16:56 -0800
Message-ID: <20180102161656.GD3668920@devbig577.frc2.facebook.com>
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
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6WNYtPL8WMwPi+DGhBRmor9zRMGz7zGE/qk/IuKbxRo=;
        b=VHdU0g6a6ddFVKZ7s/1wrQiA2XgzUX4VHr5OfIzGyPT1owKFU7m8PtJJRMUyNc8dE9
         ayQyJYewQKI/J90ar8UOF8SKsEnDflA+xOcQeUpw2wzPBx6x++MDRTCJ0+Z7O36qRTlr
         0T7Heo2i4xcM8RSBXFZKLXz1AbeTcONzP+7MY8S5WJofZ+2PSUR9JaTsfYkgP/Njsa9y
         6gnNvUTOAjOaqynb/n4xcvyk/yMLIwYxS7gmofR/hvk8+AE72D+BLjzosLPo98hhN5Ml
         UQTWMiwzGfBTFWzQxY13xCWAP9EIZETl3Wj+9gWyw4y/elXlunlrOLL+YSZCIe8TOviG
         sxRw==
Content-Disposition: inline
In-Reply-To: <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood@codeaurora.org>
Cc: Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Hello,

On Fri, Dec 29, 2017 at 02:07:16AM +0530, Prateek Sood wrote:
> task T is waiting for cpuset_mutex acquired
> by kworker/2:1
> 
> sh ==> cpuhp/2 ==> kworker/2:1 ==> sh 
> 
> kworker/2:3 ==> kthreadd ==> Task T ==> kworker/2:1
> 
> It seems that my earlier patch set should fix this scenario:
> 1) Inverting locking order of cpuset_mutex and cpu_hotplug_lock.
> 2) Make cpuset hotplug work synchronous.
>
> Could you please share your feedback.

Hmm... this can also be resolved by adding WQ_MEM_RECLAIM to the
synchronize rcu workqueue, right?  Given the wide-spread usages of
synchronize_rcu and friends, maybe that's the right solution, or at
least something we also need to do, for this particular deadlock?

Again, I don't have anything against making the domain rebuliding part
of cpuset operations synchronous and these tricky deadlock scenarios
do indicate that doing so would probably be beneficial.  That said,
tho, these scenarios seem more of manifestations of other problems
exposed through kthreadd dependency than anything else.

Thanks.

-- 
tejun
