From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH v4] mm: fix race between kmem_cache destroy, create and
 deactivate
Date: Tue, 12 Jun 2018 11:33:14 +0300
Message-ID: <20180612083314.ftl4hmn4xwnehjdx@esperanza>
References: <20180611192951.195727-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2CUoKXg/Jtc5sIdU2xR4mhcen0nTu7a2lUGvIEAuSVw=;
        b=EOuJGpy8lYROQorMGNi92tF5uE0GVcl+EICrGulTwEvZFQoZQDG5b7q4aNubDCN7Gq
         J3cHkLo+4OnA8cxGvy3I+d/6J2dHliSmpid1NYfMqnv/fmjLnCxNl4cMIjzhfxfb2WS9
         qz9nNDbWPaRtmtittPfWdJO0915lN0q+Fek5/Z2HzsgfNtQ2DqpfgfI6wpv2GC6oCR7g
         JCR7/gZy13y+qYEjgK0gArY9MwZjk+bDhxtdM12cA7kxtWdyqScwg4IKhEDN5PO+jTzl
         wuU6EI/tA0dpAhtG4a03h9bK0bFYV9+OLKFH0eZzVZQqSVyfH5Bl+jatkpHq6erNgQNI
         OOoQ==
Content-Disposition: inline
In-Reply-To: <20180611192951.195727-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon, Jun 11, 2018 at 12:29:51PM -0700, Shakeel Butt wrote:
> The memcg kmem cache creation and deactivation (SLUB only) is
> asynchronous. If a root kmem cache is destroyed whose memcg cache is in
> the process of creation or deactivation, the kernel may crash.
> 
> Example of one such crash:
> 	general protection fault: 0000 [#1] SMP PTI
> 	CPU: 1 PID: 1721 Comm: kworker/14:1 Not tainted 4.17.0-smp
> 	...
> 	Workqueue: memcg_kmem_cache kmemcg_deactivate_workfn
> 	RIP: 0010:has_cpu_slab
> 	...
> 	Call Trace:
> 	? on_each_cpu_cond
> 	__kmem_cache_shrink
> 	kmemcg_cache_deact_after_rcu
> 	kmemcg_deactivate_workfn
> 	process_one_work
> 	worker_thread
> 	kthread
> 	ret_from_fork+0x35/0x40
> 
> To fix this race, on root kmem cache destruction, mark the cache as
> dying and flush the workqueue used for memcg kmem cache creation and
> deactivation. SLUB's memcg kmem cache deactivation also includes RCU
> callback and thus make sure all previous registered RCU callbacks
> have completed as well.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

Thanks.
