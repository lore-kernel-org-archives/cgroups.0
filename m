From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V8 13/16] hugetlb/cgroup: add hugetlb cgroup control files
Date: Tue, 12 Jun 2012 16:28:16 +0530
Message-ID: <87d354okzb.fsf@skywalker.in.ibm.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-14-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4FD6FF47.8080200@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FD6FF47.8080200-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> writes:

> (2012/06/09 17:59), Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V"<aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> 
>> Add the control files for hugetlb controller
>> 
>> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
>>   include/linux/hugetlb.h        |    5 ++
>>   include/linux/hugetlb_cgroup.h |    6 ++
>>   mm/hugetlb.c                   |    8 +++
>>   mm/hugetlb_cgroup.c            |  130 ++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 149 insertions(+)
>> 
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 4aca057..9650bb1 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -4,6 +4,7 @@
>>   #include<linux/mm_types.h>
>>   #include<linux/fs.h>
>>   #include<linux/hugetlb_inline.h>
>> +#include<linux/cgroup.h>
>> 
>>   struct ctl_table;
>>   struct user_struct;
>> @@ -221,6 +222,10 @@ struct hstate {
>>   	unsigned int nr_huge_pages_node[MAX_NUMNODES];
>>   	unsigned int free_huge_pages_node[MAX_NUMNODES];
>>   	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
>> +#ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
>> +	/* cgroup control files */
>> +	struct cftype cgroup_files[5];
>> +#endif
>>   	char name[HSTATE_NAME_LEN];
>>   };
>> 
>> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
>> index ceff1d5..ba4836f 100644
>> --- a/include/linux/hugetlb_cgroup.h
>> +++ b/include/linux/hugetlb_cgroup.h
>> @@ -62,6 +62,7 @@ extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
>>   					 struct page *page);
>>   extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>>   					   struct hugetlb_cgroup *h_cg);
>> +extern int hugetlb_cgroup_file_init(int idx) __init;
>>   #else
>>   static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
>>   {
>> @@ -106,5 +107,10 @@ hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>>   {
>>   	return;
>>   }
>> +
>> +static inline int __init hugetlb_cgroup_file_init(int idx)
>> +{
>> +	return 0;
>> +}
>>   #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
>>   #endif
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 1ca2d8f..bf79131 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -30,6 +30,7 @@
>>   #include<linux/hugetlb.h>
>>   #include<linux/hugetlb_cgroup.h>
>>   #include<linux/node.h>
>> +#include<linux/hugetlb_cgroup.h>
>>   #include "internal.h"
>> 
>>   const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
>> @@ -1916,6 +1917,13 @@ void __init hugetlb_add_hstate(unsigned order)
>>   	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
>>   	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
>>   					huge_page_size(h)/1024);
>> +	/*
>> +	 * Add cgroup control files only if the huge page consists
>> +	 * of more than two normal pages. This is because we use
>> +	 * page[2].lru.next for storing cgoup details.
>> +	 */
>> +	if (order>= 2)
>> +		hugetlb_cgroup_file_init(hugetlb_max_hstate - 1);
>> 
>
> What happens at hugetlb module exit ? please see hugetlb_exit().
>
> BTW, module unload of hugetlbfs is restricted if hugetlb cgroup is mounted ??
>

hugetlb is a binary config

config HUGETLBFS
	bool "HugeTLB file system support"

config HUGETLB_PAGE
	def_bool HUGETLBFS

-aneesh
