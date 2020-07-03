From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PROPOSAL] memcg: per-memcg user space reclaim interface
Date: Fri, 3 Jul 2020 08:35:48 +0200
Message-ID: <20200703063548.GM18446@dhcp22.suse.cz>
References: <20200702152222.2630760-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200702152222.2630760-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 02-07-20 08:22:22, Shakeel Butt wrote:
[...]
> Interface options:
> ------------------
> 
> 1) memcg interface e.g. 'echo 10M > memory.reclaim'
> 
> + simple
> + can be extended to target specific type of memory (anon, file, kmem).
> - most probably restricted to cgroup v2.
> 
> 2) fadvise(PAGEOUT) on cgroup_dir_fd
> 
> + more general and applicable to other FSes (actually we are using
> something similar for tmpfs).
> + can be extended in future to just age the LRUs instead of reclaim or
> some new use cases.

Could you explain why memory.high as an interface to trigger pro-active
memory reclaim is not sufficient. Also memory.low limit to protect
latency sensitve workloads?
-- 
Michal Hocko
SUSE Labs
