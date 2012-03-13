From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH -V3 7/8] memcg: move HugeTLB resource count to parent
 cgroup on memcg removal
Date: Tue, 13 Mar 2012 14:47:05 -0700
Message-ID: <20120313144705.020b6dde.akpm@linux-foundation.org>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1331622432-24683-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331622432-24683-8-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 13 Mar 2012 12:37:11 +0530
"Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> This add support for memcg removal with HugeTLB resource usage.
> 
> ...
>
> +int hugetlb_force_memcg_empty(struct cgroup *cgroup)

It's useful to document things, you know.  For a major function like
this, a nice little description of why it exists, what its role is,
etc.  Programming is not just an act of telling a computer what to do:
it is also an act of telling other programmers what you wished the
computer to do.  Both are important, and the latter deserves care.

> +{
> +	struct hstate *h;
> +	struct page *page;
> +	int ret = 0, idx = 0;
> +
> +	do {
> +		if (cgroup_task_count(cgroup) || !list_empty(&cgroup->children))
> +			goto out;
> +		if (signal_pending(current)) {
> +			ret = -EINTR;
> +			goto out;
> +		}

Why is its behaviour altered by signal_pending()?  This seems broken.

> +		for_each_hstate(h) {
> +			spin_lock(&hugetlb_lock);
> +			list_for_each_entry(page, &h->hugepage_activelist, lru) {
> +				ret = mem_cgroup_move_hugetlb_parent(idx, cgroup, page);
> +				if (ret) {
> +					spin_unlock(&hugetlb_lock);
> +					goto out;
> +				}
> +			}
> +			spin_unlock(&hugetlb_lock);
> +			idx++;
> +		}
> +		cond_resched();
> +	} while (mem_cgroup_hugetlb_usage(cgroup) > 0);
> +out:
> +	return ret;
> +}
