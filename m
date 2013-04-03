From: Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC][PATCH 1/7] memcg: use css_get in sock_update_memcg()
Date: Wed, 3 Apr 2013 16:58:48 +0400
Message-ID: <515C2788.90907@parallels.com>
References: <515BF233.6070308@huawei.com> <515BF249.50607@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <515BF249.50607@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan@huawei.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

On 04/03/2013 01:11 PM, Li Zefan wrote:
> Use css_get/css_put instead of mem_cgroup_get/put.
> 
> Note, if at the same time someone is moving @current to a different
> cgroup and removing the old cgroup, css_tryget() may return false,
> and sock->sk_cgrp won't be initialized.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  mm/memcontrol.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 23d0f6e..43ca91d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -536,15 +536,15 @@ void sock_update_memcg(struct sock *sk)
>  		 */
>  		if (sk->sk_cgrp) {
>  			BUG_ON(mem_cgroup_is_root(sk->sk_cgrp->memcg));
> -			mem_cgroup_get(sk->sk_cgrp->memcg);
> +			css_get(&sk->sk_cgrp->memcg->css);
>  			return;
>  		}
>  
>  		rcu_read_lock();
>  		memcg = mem_cgroup_from_task(current);
>  		cg_proto = sk->sk_prot->proto_cgroup(memcg);
> -		if (!mem_cgroup_is_root(memcg) && memcg_proto_active(cg_proto)) {
> -			mem_cgroup_get(memcg);
> +		if (!mem_cgroup_is_root(memcg) &&
> +		    memcg_proto_active(cg_proto) && css_tryget(&memcg->css)) {
>  			sk->sk_cgrp = cg_proto;
>  		}

What happens if this tryget fails ? Won't we leak a reference here? We
will put regardless when the socket is released, and this may go
negative. No?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
