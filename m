From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [RFC PATCH] mm: memcontrol: don't account swap failures not due
 to cgroup limits
Date: Fri, 3 Feb 2023 11:00:00 -0800
Message-ID: <Y91ZsDSIr2oFHu3E@P9FQF9L96D.corp.robot.car>
References: <20230202155626.1829121-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675450805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bDlRD3fwCPL14p6e6ddJjSrpAo4LDvSi2XC5vgn8kU0=;
        b=BS2eVBXFzFjNVBl+LWymBljXHRNVObqwCrs6RSCuaozAoNgSBBHI+URK67rTHSm37kcZnB
        xuu7iZbEKt34nkdtPU1rIcyM+rsn4lX0QtnZ4Dx0YQ1iiKeeUZIFXwH106L0PWu3sXHBWo
        CcnuqqZpr6oOUA9uxQraLv13i7vqCi8=
Content-Disposition: inline
In-Reply-To: <20230202155626.1829121-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, Feb 02, 2023 at 10:56:26AM -0500, Johannes Weiner wrote:
> Christian reports the following situation in a cgroup that doesn't
> have memory.swap.max configured:
> 
>   $ cat memory.swap.events
>   high 0
>   max 0
>   fail 6218
> 
> Upon closer examination, this is an ARM64 machine that doesn't support
> swapping out THPs.

Do we expect it to be added any time soon or it's caused by some system
limitations?

> In that case, the first get_swap_page() fails, and
> the kernel falls back to splitting the THP and swapping the 4k
> constituents one by one. /proc/vmstat confirms this with a high rate
> of thp_swpout_fallback events.
> 
> While the behavior can ultimately be explained, it's unexpected and
> confusing. I see three choices how to address this:
> 
> a) Specifically exlude THP fallbacks from being counted, as the
>    failure is transient and the memory is ultimately swapped.
> 
>    Arguably, though, the user would like to know if their cgroup's
>    swap limit is causing high rates of THP splitting during swapout.

I agree, but it's probably better to reflect it in a form of a per-memcg
thp split failure counter (e.g. in memory.stat), not as swap out failures.
Overall option a) looks preferable to me. Especially if in the long run
the arm64 limitation will be fixed.

> 
> b) Only count cgroup swap events when they are actually due to a
>    cgroup's own limit. Exclude failures that are due to physical swap
>    shortage or other system-level conditions (like !THP_SWAP). Also
>    count them at the level where the limit is configured, which may be
>    above the local cgroup that holds the page-to-be-swapped.
> 
>    This is in line with how memory.swap.high, memory.high and
>    memory.max events are counted.
> 
>    However, it's a change in documented behavior.

I'm not sure about this option: I can easily imagine a setup with a
memcg-specific swap space, which would require setting an artificial
memory.swap.max to get the fail counter working. On the other side not a deal
breaker.

Thanks!
