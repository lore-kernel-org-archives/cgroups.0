From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 06/12] memcg: don't use mem_cgroup_get() when creating
 a kmemcg cache
Date: Tue, 09 Apr 2013 11:53:16 +0900
Message-ID: <5163829C.3030809@jp.fujitsu.com>
References: <5162648B.9070802@huawei.com> <516264F1.8020904@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <516264F1.8020904@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

(2013/04/08 15:34), Li Zefan wrote:
> Use css_get()/css_put() instead of mem_cgroup_get()/mem_cgroup_put().
> 
> There are two things being done in the current code:
> 
> First, we acquired a css_ref to make sure that the underlying cgroup
> would not go away. That is a short lived reference, and it is put as
> soon as the cache is created.
> 
> At this point, we acquire a long-lived per-cache memcg reference count
> to guarantee that the memcg will still be alive.
> 
> so it is:
> 
> enqueue: css_get
> create : memcg_get, css_put
> destroy: memcg_put
> 
> So we only need to get rid of the memcg_get, change the memcg_put to
> css_put, and get rid of the now extra css_put.
> 
> (This changelog is basically written by Glauber)
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
