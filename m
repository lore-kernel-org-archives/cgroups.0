From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v4 1/2] cgroup: memcg: net: do not associate sock with
 unrelated cgroup
Date: Tue, 10 Mar 2020 15:34:00 -0700 (PDT)
Message-ID: <20200310.153400.1874430252406858978.davem@davemloft.net>
References: <20200310051606.33121-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200310051606.33121-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: shakeelb@google.com
Cc: edumazet@google.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, gthelen@google.com, akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Date: Mon,  9 Mar 2020 22:16:05 -0700

> We are testing network memory accounting in our setup and noticed
> inconsistent network memory usage and often unrelated cgroups network
> usage correlates with testing workload. On further inspection, it
> seems like mem_cgroup_sk_alloc() and cgroup_sk_alloc() are broken in
> irq context specially for cgroup v1.
> 
> mem_cgroup_sk_alloc() and cgroup_sk_alloc() can be called in irq context
> and kind of assumes that this can only happen from sk_clone_lock()
> and the source sock object has already associated cgroup. However in
> cgroup v1, where network memory accounting is opt-in, the source sock
> can be unassociated with any cgroup and the new cloned sock can get
> associated with unrelated interrupted cgroup.
> 
> Cgroup v2 can also suffer if the source sock object was created by
> process in the root cgroup or if sk_alloc() is called in irq context.
> The fix is to just do nothing in interrupt.
> 
> WARNING: Please note that about half of the TCP sockets are allocated
> from the IRQ context, so, memory used by such sockets will not be
> accouted by the memcg.
> 
> The stack trace of mem_cgroup_sk_alloc() from IRQ-context:
 ...
> The stack trace of mem_cgroup_sk_alloc() from IRQ-context:
> Fixes: 2d7580738345 ("mm: memcontrol: consolidate cgroup socket tracking")
> Fixes: d979a39d7242 ("cgroup: duplicate cgroup reference when cloning sockets")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reviewed-by: Roman Gushchin <guro@fb.com>

Applied and queued up for -stable.
