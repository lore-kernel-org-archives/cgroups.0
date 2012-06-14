From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH -V9 09/15] mm/hugetlb: Add new HugeTLB cgroup
Date: Thu, 14 Jun 2012 16:54:14 +0800
Message-ID: <4FD9A6B6.50503@huawei.com>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1339583254-895-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

> +static inline

> +struct hugetlb_cgroup *hugetlb_cgroup_from_css(struct cgroup_subsys_state *s)
> +{
> +	if (s)


Neither cgroup_subsys_state() or task_subsys_state() will ever return NULL,
so here 's' won't be NULL.

> +		return container_of(s, struct hugetlb_cgroup, css);
> +	return NULL;
> +}
> +
> +static inline
> +struct hugetlb_cgroup *hugetlb_cgroup_from_cgroup(struct cgroup *cgroup)
> +{
> +	return hugetlb_cgroup_from_css(cgroup_subsys_state(cgroup,
> +							   hugetlb_subsys_id));
> +}
> +
> +static inline
> +struct hugetlb_cgroup *hugetlb_cgroup_from_task(struct task_struct *task)
> +{
> +	return hugetlb_cgroup_from_css(task_subsys_state(task,
> +							 hugetlb_subsys_id));
> +}

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
