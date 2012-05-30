From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge infrastructure
Date: Wed, 30 May 2012 17:37:57 +0400
Message-ID: <4FC622B5.9080600@parallels.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-17-git-send-email-glommer@parallels.com> <20120530130416.GD25094@somewhere.redhat.com> <4FC61B4E.2060206@parallels.com> <20120530133736.GF25094@somewhere.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120530133736.GF25094@somewhere.redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On 05/30/2012 05:37 PM, Frederic Weisbecker wrote:
> Right. __mem_cgroup_get_kmem_cache() fetches the memcg of the owner
> and calls memcg_create_cache_enqueue() which does css_tryget(&memcg->css).
> After this tryget I think you're fine. And in-between you're safe against
> css_set removal due to rcu_read_lock().
>
> I'm less clear with __mem_cgroup_new_kmem_page() though...

That one does not get memcg->css but it does call mem_cgroup_get(), that 
does prevent against the memcg structure being freed, which I believe to 
be good enough.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
