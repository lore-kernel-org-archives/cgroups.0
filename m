From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 05/10] sched/psi: optimize task switch inside shared
 cgroups again
Date: Thu, 25 Aug 2022 13:16:07 -0400
Message-ID: <YweuV/+G0DGn3ECV@cmpxchg.org>
References: <20220825164111.29534-1-zhouchengming@bytedance.com>
 <20220825164111.29534-6-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=3kaoHrknD8P9F02t3vtvA1BMAXsONZRXU6MvhQ9cGm0=;
        b=Kx3Dht7p+xMwF8txIAf16o45Jbd5BarQhl+hTLnStlK+dnLu8CQHK2RcIzo9QNnbV0
         c4gNp7qmdE6YOchm2Gy+iMBaiQVOUufrpkH6vQ/g5W8LOb06aqEzTPQqYRVpm9jkNh1Q
         pKL1ofb86P3CBoNgi9kLOEAga5m+GZYCXEisz54+F706FD11ImkP96ot3klNK/RKOwDP
         g1Rp3pJ8PohBavZvYluu6a6WR2jA0Heg8yn0gy44KXBhLY5RlMCoFZxdnKx3/6Tgi3QF
         I52eXYKkogKjti2J+zLJZSiwMpBbRBET5warOvEzaVmiiMqQqz8dUTwQejSwcp+Pu6ji
         Z+8A==
Content-Disposition: inline
In-Reply-To: <20220825164111.29534-6-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Fri, Aug 26, 2022 at 12:41:06AM +0800, Chengming Zhou wrote:
> Way back when PSI_MEM_FULL was accounted from the timer tick, task
> switching could simply iterate next and prev to the common ancestor to
> update TSK_ONCPU and be done.
> 
> Then memstall ticks were replaced with checking curr->in_memstall
> directly in psi_group_change(). That meant that now if the task switch
> was between a memstall and a !memstall task, we had to iterate through
> the common ancestors at least ONCE to fix up their state_masks.
> 
> We added the identical_state filter to make sure the common ancestor
> elimination was skipped in that case. It seems that was always a
> little too eager, because it caused us to walk the common ancestors
> *twice* instead of the required once: the iteration for next could
> have stopped at the common ancestor; prev could have updated TSK_ONCPU
> up to the common ancestor, then finish to the root without changing
> any flags, just to get the new curr->in_memstall into the state_masks.
> 
> This patch recognizes this and makes it so that we walk to the root
> exactly once if state_mask needs updating, which is simply catching up
> on a missed optimization that could have been done in commit 7fae6c8171d2
> ("psi: Use ONCPU state tracking machinery to detect reclaim") directly.
> 
> Apart from this, it's also necessary for the next patch "sched/psi: remove
> NR_ONCPU task accounting". Suppose we walk the common ancestors twice:
> 
> (1) psi_group_change(.clear = 0, .set = TSK_ONCPU)
> (2) psi_group_change(.clear = TSK_ONCPU, .set = 0)
> 
> We previously used tasks[NR_ONCPU] to record TSK_ONCPU, tasks[NR_ONCPU]++
> in (1) then tasks[NR_ONCPU]-- in (2), so tasks[NR_ONCPU] still be correct.
> 
> The next patch change to use one bit in state mask to record TSK_ONCPU,
> PSI_ONCPU bit will be set in (1), but then be cleared in (2), which cause
> the psi_group_cpu has task running on CPU but without PSI_ONCPU bit set!
> 
> With this patch, we will never walk the common ancestors twice, so won't
> have above problem.
> 
> Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
