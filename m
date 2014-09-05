From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: revert use of root_mem_cgroup res_counter
Date: Fri, 5 Sep 2014 17:55:07 +0400
Message-ID: <20140905135507.GE25641@esperanza>
References: <1409921037-21405-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1409921037-21405-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 05, 2014 at 08:43:57AM -0400, Johannes Weiner wrote:
> Dave Hansen reports a massive scalability regression in an uncontained
> page fault benchmark with more than 30 concurrent threads, which he
> bisected down to 05b843012335 ("mm: memcontrol: use root_mem_cgroup
> res_counter") and pin-pointed on res_counter spinlock contention.
> 
> That change relied on the per-cpu charge caches to mostly swallow the
> res_counter costs, but it's apparent that the caches don't scale yet.
> 
> Revert memcg back to bypassing res_counters on the root level in order
> to restore performance for uncontained workloads.
> 
> Reported-by: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Tested-by: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

It's a pity we have to revert this nice cleanup, but seems we can't do
anything better right now. FWIW,

Reviewed-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
