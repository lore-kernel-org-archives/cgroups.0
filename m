From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH -V3 5/8] hugetlbfs: Add memcg control files for
 hugetlbfs
Date: Tue, 13 Mar 2012 14:42:33 -0700
Message-ID: <20120313144233.49026e6a.akpm@linux-foundation.org>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1331622432-24683-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331622432-24683-6-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 13 Mar 2012 12:37:09 +0530
"Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> This add control files for hugetlbfs in memcg
> 
> ...
>
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -220,6 +221,10 @@ struct hstate {
>  	unsigned int nr_huge_pages_node[MAX_NUMNODES];
>  	unsigned int free_huge_pages_node[MAX_NUMNODES];
>  	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
> +	/* cgroup control files */
> +	struct cftype cgroup_limit_file;
> +	struct cftype cgroup_usage_file;
> +	struct cftype cgroup_max_usage_file;
>  	char name[HSTATE_NAME_LEN];
>  };

We don't need all these in here if, for example, cgroups is disabled?

> ...
>
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1817,6 +1817,36 @@ static int __init hugetlb_init(void)
>  }
>  module_init(hugetlb_init);
>  
> +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
> +int register_hugetlb_memcg_files(struct cgroup *cgroup,
> +				 struct cgroup_subsys *ss)
> +{
> +	int ret = 0;
> +	struct hstate *h;
> +
> +	for_each_hstate(h) {
> +		ret = cgroup_add_file(cgroup, ss, &h->cgroup_limit_file);
> +		if (ret)
> +			return ret;
> +		ret = cgroup_add_file(cgroup, ss, &h->cgroup_usage_file);
> +		if (ret)
> +			return ret;
> +		ret = cgroup_add_file(cgroup, ss, &h->cgroup_max_usage_file);
> +		if (ret)
> +			return ret;
> +
> +	}
> +	return ret;
> +}
> +/* mm/memcontrol.c because mem_cgroup_read/write is not availabel outside */

Comment has a spelling mistake.

> +int mem_cgroup_hugetlb_file_init(struct hstate *h, int idx);


No, please put it in a header file.  Always.  Where both callers and
the implementation see the same propotype.

> +#else
> +static int mem_cgroup_hugetlb_file_init(struct hstate *h, int idx)
> +{
> +	return 0;
> +}
> +#endif

So this will go into the same header file.
