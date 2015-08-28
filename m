From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: punt high overage reclaim to
 return-to-userland path
Date: Fri, 28 Aug 2015 19:36:11 +0300
Message-ID: <20150828163611.GI9610@esperanza>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440775530-18630-4-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hi Tejun,

On Fri, Aug 28, 2015 at 11:25:29AM -0400, Tejun Heo wrote:
> Currently, try_charge() tries to reclaim memory directly when the high
> limit is breached; however, this has a couple issues.
> 
> * try_charge() can be invoked from any in-kernel allocation site and
>   reclaim path may use considerable amount of stack.  This can lead to
>   stack overflows which are extremely difficult to reproduce.

IMO this paragraph does not justify this patch at all, because one will
still invoke direct reclaim from try_charge() on hitting the hard limit.

> 
> * If the allocation doesn't have __GFP_WAIT, direct reclaim is
>   skipped.  If a process performs only speculative allocations, it can
>   blow way past the high limit.  This is actually easily reproducible
>   by simply doing "find /".  VFS tries speculative !__GFP_WAIT
>   allocations first, so as long as there's memory which can be
>   consumed without blocking, it can keep allocating memory regardless
>   of the high limit.

I think there shouldn't normally occur a lot of !__GFP_WAIT allocations
in a row - they should still alternate with normal __GFP_WAIT
allocations. Yes, that means we can breach memory.high threshold for a
short period of time, but it isn't a hard limit, so it looks perfectly
fine to me.

I tried to run `find /` over ext4 in a cgroup with memory.high set to
32M and kmem accounting enabled. With such a setup memory.current never
got higher than 33152K, which is only 384K greater than the memory.high.
Which FS did you use?

Thanks,
Vladimir
