From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 5/6] memcg: make mem_cgroup_reparent_charges non failing
Date: Thu, 18 Oct 2012 16:30:19 +0800
Message-ID: <507FBE1B.4080906@huawei.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz> <1350480648-10905-6-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1350480648-10905-6-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>

>  static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
> @@ -5013,13 +5011,9 @@ free_out:
>  static int mem_cgroup_pre_destroy(struct cgroup *cont)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> -	int ret;
>  
> -	css_get(&memcg->css);
> -	ret = mem_cgroup_reparent_charges(memcg);
> -	css_put(&memcg->css);
> -
> -	return ret;
> +	mem_cgroup_reparent_charges(memcg);
> +	return 0;
>  }
>  

Why don't you make pre_destroy() return void?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
