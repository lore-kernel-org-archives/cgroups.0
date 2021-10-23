From: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Subject: Re: [PATCH memcg v3 2/3] mm, oom: do not trigger out_of_memory from
 the #PF
Date: Sun, 24 Oct 2021 00:01:07 +0900
Message-ID: <e2a847a2-a414-2535-e3d1-b100a023b9d1@i-love.sakura.ne.jp>
References: <YXJ/63kIpTq8AOlD@dhcp22.suse.cz>
 <cover.1634994605.git.vvs@virtuozzo.com>
 <f5fd8dd8-0ad4-c524-5f65-920b01972a42@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f5fd8dd8-0ad4-c524-5f65-920b01972a42-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 2021/10/23 22:20, Vasily Averin wrote:
>  /*
> - * The pagefault handler calls here because it is out of memory, so kill a
> - * memory-hogging task. If oom_lock is held by somebody else, a parallel oom
> - * killing is already in progress so do nothing.
> + * The pagefault handler calls here because some allocation has failed. We have
> + * to take care of the memcg OOM here because this is the only safe context without
> + * any locks held but let the oom killer triggered from the allocation context care
> + * about the global OOM.
>   */

Excuse me for a stupid question. I consider

  if (!mutex_trylock(&oom_lock))
    return;
  out_of_memory(&oc);
  mutex_unlock(&oom_lock);

here as the last resort (safeguard) when neither __alloc_pages_may_oom()
nor mem_cgroup_out_of_memory() can make progress. This patch says

  let the oom killer triggered from the allocation context care
  about the global OOM.

but what if the OOM killer cannot be invoked from the allocation context?
Is there a guarantee that all memory allocations which might result in
VM_FAULT_OOM can invoke the OOM killer?
