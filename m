From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 1/2] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Mon, 13 Jul 2020 07:50:51 -0700
Message-ID: <CALvZod5BKXs52A2R-d=aOsjB7idBejsMDgQUKc1H_6y=PuBsew@mail.gmail.com>
References: <cover.1594640214.git.chris@chrisdown.name> <a4e23b59e9ef499b575ae73a8120ee089b7d3373.1594640214.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xUKZlCYinai0Luu2hOdm2qnhIZ2lqYBnLnpnyrbTn3I=;
        b=qu2t9/SUqzkLaYFEwlQpODBK/nnlgLwz7l2VJYTrR/DC+v3zsZaCKn56tElzWPtcHn
         /Q0rjazMjk+yHC1rwE1i8nQL9hhJXzlcyXtEAtlmk9i3HxETJsnHiDlivYKSIbc56wK/
         8vm0kqjPm0gBZH2MdJQMaQ5byy/UHj4ypCn6Iu2V1CFGE83BYFlgkmJS557gdfQUsRz3
         YCMy6tBmB+wtWOtLsa5DPlxcueem/ZeE7vP6YDeQQ//bYUkOA57A027j5wKUEAQ6LZem
         gCLVAA+bEN8QBxtkQksQwh1Z7ionO2BfUakJra1klkKve+16G5WCJ3i2xVXyCdXj5tKF
         OcBg==
In-Reply-To: <a4e23b59e9ef499b575ae73a8120ee089b7d3373.1594640214.git.chris@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Mon, Jul 13, 2020 at 4:42 AM Chris Down <chris@chrisdown.name> wrote:
>
> In Facebook production, we've seen cases where cgroups have been put
> into allocator throttling even when they appear to have a lot of slack
> file caches which should be trivially reclaimable.
>
> Looking more closely, the problem is that we only try a single cgroup
> reclaim walk for each return to usermode before calculating whether or
> not we should throttle. This single attempt doesn't produce enough
> pressure to shrink for cgroups with a rapidly growing amount of file
> caches prior to entering allocator throttling.
>
> As an example, we see that threads in an affected cgroup are stuck in
> allocator throttling:
>
>     # for i in $(cat cgroup.threads); do
>     >     grep over_high "/proc/$i/stack"
>     > done
>     [<0>] mem_cgroup_handle_over_high+0x10b/0x150
>     [<0>] mem_cgroup_handle_over_high+0x10b/0x150
>     [<0>] mem_cgroup_handle_over_high+0x10b/0x150
>
> ...however, there is no I/O pressure reported by PSI, despite a lot of
> slack file pages:
>
>     # cat memory.pressure
>     some avg10=78.50 avg60=84.99 avg300=84.53 total=5702440903
>     full avg10=78.50 avg60=84.99 avg300=84.53 total=5702116959
>     # cat io.pressure
>     some avg10=0.00 avg60=0.00 avg300=0.00 total=78051391
>     full avg10=0.00 avg60=0.00 avg300=0.00 total=78049640
>     # grep _file memory.stat
>     inactive_file 1370939392
>     active_file 661635072
>
> This patch changes the behaviour to retry reclaim either until the
> current task goes below the 10ms grace period, or we are making no
> reclaim progress at all. In the latter case, we enter reclaim throttling
> as before.
>
> To a user, there's no intuitive reason for the reclaim behaviour to
> differ from hitting memory.high as part of a new allocation, as opposed
> to hitting memory.high because someone lowered its value. As such this
> also brings an added benefit: it unifies the reclaim behaviour between
> the two.
>
> There's precedent for this behaviour: we already do reclaim retries when
> writing to memory.{high,max}, in max reclaim, and in the page allocator
> itself.
>
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Michal Hocko <mhocko@kernel.org>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
