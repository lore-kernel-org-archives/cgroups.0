From: Laurent Dufour <ldufour-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 2/2] mm/cgroup: delay soft limit data allocation
Date: Wed, 22 Feb 2017 18:50:19 +0100
Message-ID: <3b8d0a31-d869-4564-0e03-ac621af43ce7@linux.vnet.ibm.com>
References: <1487779091-31381-1-git-send-email-ldufour@linux.vnet.ibm.com>
 <1487779091-31381-3-git-send-email-ldufour@linux.vnet.ibm.com>
 <20170222171132.GB26472@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170222171132.GB26472-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 22/02/2017 18:11, Michal Hocko wrote:
> On Wed 22-02-17 16:58:11, Laurent Dufour wrote:
> [...]
>>  static struct mem_cgroup_tree_per_node *
>>  soft_limit_tree_node(int nid)
>>  {
>> @@ -465,6 +497,8 @@ static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
>>  	struct mem_cgroup_tree_per_node *mctz;
>>  
>>  	mctz = soft_limit_tree_from_page(page);
>> +	if (!mctz)
>> +		return;
>>  	/*
>>  	 * Necessary to update all ancestors when hierarchy is used.
>>  	 * because their event counter is not touched.
>> @@ -502,7 +536,8 @@ static void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
>>  	for_each_node(nid) {
>>  		mz = mem_cgroup_nodeinfo(memcg, nid);
>>  		mctz = soft_limit_tree_node(nid);
>> -		mem_cgroup_remove_exceeded(mz, mctz);
>> +		if (mctz)
>> +			mem_cgroup_remove_exceeded(mz, mctz);
>>  	}
>>  }
>>  
> 
> this belongs to the previous patch, right?

It may. I made the first patch fixing the panic I saw but if you prefer
this to be part of the first one, fair enough.
Tell me what you like.
