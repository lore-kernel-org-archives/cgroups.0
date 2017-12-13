From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Wed, 13 Dec 2017 08:06:17 -0800
Message-ID: <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <20171211152059.GH2421075@devbig577.frc2.facebook.com>
 <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x2MrNLOpirbHrA/wrNjREHDSVOPYAKGCopoUwF4gILQ=;
        b=Bpsh/GoYa0YRc4y1XpsFEkOtacpXzoro+FLgyUSL996nCajlspKLzphI0pBk5rddi7
         c96EH1UhtrS4yGk3bCOJfzPnXKXjvF92qt8bnI5j1aGzfR3BiPI62ns5N4sUoAVB8Qr2
         Ydn5huFKsQuqI9uZ+iY6/047q9jt34BnZmb7v+8QCYdg5E8ow6TBdoeUZLt6S15wJtbv
         SaMIieqmOkO796NQUifzDlouom4RuSoglAi8b7bRu3o0ouwQECcWP9zpq3d/TzdniPuo
         EApfyN5YPb/7pRcgB/gVCnRJw1+aDEwSVqNiPElpwaqavEI1v/yGC/bXGprLb2y1v8zr
         5wQg==
Content-Disposition: inline
In-Reply-To: <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood@codeaurora.org>
Cc: Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

Hello, Prateek.

On Wed, Dec 13, 2017 at 01:20:46PM +0530, Prateek Sood wrote:
> This change makes the usage of cpuset_hotplug_workfn() from cpu
> hotplug path synchronous. For memory hotplug it still remains
> asynchronous.

Ah, right.

> Memory migration happening from cpuset_hotplug_workfn() is
> already asynchronous by queuing cpuset_migrate_mm_workfn() in
> cpuset_migrate_mm_wq.
>
> cpuset_hotplug_workfn()
>    cpuset_hotplug_workfn(()
>       cpuset_migrate_mm()
>          queue_work(cpuset_migrate_mm_wq)
> 
> It seems that memory migration latency might not have
> impact with this change.
> 
> Please let me know if you meant something else by cpuset
> migration taking time when memory migration is turned on.

No, I didn't.  I was just confused about which part became
synchronous.  So, I don't have anything against making the cpu part
synchronous, but let's not do that as the fix to the deadlocks cuz,
while we can avoid them by changing cpuset, I don't think cpuset is
the root cause for them.  If there are benefits to making cpuset cpu
migration synchronous, let's do that for those benefits.

Thanks.

-- 
tejun
