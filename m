From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch] mm, memcg: pass charge order to oom killer
Date: Thu, 8 Mar 2012 14:39:35 +0900
Message-ID: <20120308143935.d38318f7.kamezawa.hiroyu@jp.fujitsu.com>
References: <alpine.DEB.2.00.1203071341320.4520@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1203071341320.4520-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, 7 Mar 2012 13:43:05 -0800 (PST)
David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> The oom killer typically displays the allocation order at the time of oom
> as a part of its diangostic messages (for global, cpuset, and mempolicy
> ooms).
> 
> The memory controller may also pass the charge order to the oom killer so
> it can emit the same information.  This is useful in determining how
> large the memory allocation is that triggered the oom killer.
> 
> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Now, usual memcg only supports 1 page allocation.
(If hugetlb allocation failed, it will use a normal page allocation.)

But it seems there are(will be) changes because of tcp buffer control or
slab accounting.
 
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
