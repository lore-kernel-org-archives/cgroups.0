From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/12] cgroup: rstat: Make cgroup_rstat_cpu_lock name
 readable
Date: Tue, 8 Feb 2022 08:46:43 -1000
Message-ID: <YgK6k4TXnRbm02dh@slm.duckdns.org>
References: <20220208184208.79303-1-namhyung@kernel.org>
 <20220208184208.79303-3-namhyung@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1liiLSuYIW9j6jQFc6OEJ1fextR2u28LmbY2MxPqeU4=;
        b=S4F32V8+CrxKsU7uCl/D8b+9z3GIEhP7EcY0HQyP6a4Hu1ugw4jLGnFWrpWzLRUaGF
         Tj4HjXVQvz8ks8LPynj0KVjdf5Tj0h5J61V+9uAFNbcQDmlWfP7jtXXQ1dwDXWkDMwLB
         iHzvT8dXNqLFszTi/YK6SCqTGJ5kiT90rTT5U5E0wlIXy141dM9iNa4WwYMzdxRgScUs
         JExdPpR3P2/2+b4bKe2FDui3LbPhAh16wU0RJyK8IwB9PW3/t3IJhUVT32PR4e7viY3d
         60XxmnbcPlNvyGToKFK1BXwHHV61S3/t/6BRgpSODpc3Y9pspU7+lz+6mjb69xSeIi8p
         ntUw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220208184208.79303-3-namhyung@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>, Byungchul Park <byungchul.park@lge.com>, "Paul E. McKenney" <paul.mckenney@linaro.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Radoslaw Burny <rburny@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

On Tue, Feb 08, 2022 at 10:41:58AM -0800, Namhyung Kim wrote:
> The raw_spin_lock_init() uses the argument to name its lockdep map.
> But passing per_cpu_ptr() macro directly makes it a very very long
> name as it expanded like below:
> 
>   ({ do { const void *__vpp_verify = (typeof((&cgroup_rstat_cpu_lock) ...
> 
> Let's fix it by passing a local variable instead.  With this change,
> the name now looks like:
> 
>   cgrp_rstat_cpu_lock
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Zefan Li <lizefan.x@bytedance.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: cgroups@vger.kernel.org
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

but maybe add a comment explaining what's going on?

Thanks.

-- 
tejun
