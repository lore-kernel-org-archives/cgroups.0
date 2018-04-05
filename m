From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mm: memcg: make sure memory.events is uptodate when
 waking pollers
Date: Thu, 5 Apr 2018 12:45:12 -0700
Message-ID: <20180405194512.GD3126663@devbig577.frc2.facebook.com>
References: <20180324160901.512135-1-tj@kernel.org>
 <20180324160901.512135-2-tj@kernel.org>
 <20180404140855.GA28966@cmpxchg.org>
 <20180404141850.GC28966@cmpxchg.org>
 <20180404143447.GJ6312@dhcp22.suse.cz>
 <20180404165829.GA3126663@devbig577.frc2.facebook.com>
 <20180405175507.GA24817@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Lu84HhAZLrxfZ7APj9U2wL/V2z1LAEgNQc4VQ9m3ue8=;
        b=ItMgZJIerwheaw+bM0d63QykEV57Dybf7syBVk0rcJWIAiFY5VcTToyOSo0rzJm8ZJ
         0IHGy/n3lzQR+vcv2GHeqSNmbV6O4sj/pdLlS8oYgFmXdUVvp1peOxeXrLFuZ7G3y41g
         4WSvs9AI9OabljiPK0d6U/TiFzy9e3kIC7SqEICGPeI8K2MKaEywAiikr1e77NLn7Kyx
         Wda7G/rhWht2BUmi8Kk274WeUIvzctYDuyrqr6zh1P6JfLcTBVk1A+KekZK3df774n07
         leg8FlAwdiRa749UOp6ibs5eshZnP0J+lO9F5JNx/8Ie0Uc030+UHAgzGgFUF736L/KS
         G2tA==
Content-Disposition: inline
In-Reply-To: <20180405175507.GA24817@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, vdavydov.dev@gmail.com, guro@fb.com, riel@surriel.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu, Apr 05, 2018 at 01:55:16PM -0400, Johannes Weiner wrote:
> From 4369ce161a9085aa408f2eca54f9de72909ee1b1 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Thu, 5 Apr 2018 11:53:55 -0400
> Subject: [PATCH] mm: memcg: make sure memory.events is uptodate when waking
>  pollers
> 
> a983b5ebee57 ("mm: memcontrol: fix excessive complexity in memory.stat
> reporting") added per-cpu drift to all memory cgroup stats and events
> shown in memory.stat and memory.events.
> 
> For memory.stat this is acceptable. But memory.events issues file
> notifications, and somebody polling the file for changes will be
> confused when the counters in it are unchanged after a wakeup.
> 
> Luckily, the events in memory.events - MEMCG_LOW, MEMCG_HIGH,
> MEMCG_MAX, MEMCG_OOM - are sufficiently rare and high-level that we
> don't need per-cpu buffering for them: MEMCG_HIGH and MEMCG_MAX would
> be the most frequent, but they're counting invocations of reclaim,
> which is a complex operation that touches many shared cachelines.
> 
> This splits memory.events from the generic VM events and tracks them
> in their own, unbuffered atomic counters. That's also cleaner, as it
> eliminates the ugly enum nesting of VM and cgroup events.
> 
> Fixes: a983b5ebee57 ("mm: memcontrol: fix excessive complexity in memory.stat reporting")
> Reported-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Yeah, that works.  FWIW,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
