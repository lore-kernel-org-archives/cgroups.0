From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V8 10/16] hugetlb/cgroup: Add the cgroup pointer to page lru
Date: Tue, 12 Jun 2012 15:10:20 +0530
Message-ID: <87mx48ool7.fsf@skywalker.in.ibm.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4FD6F530.6050603@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FD6F530.6050603-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
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
>> Add the hugetlb cgroup pointer to 3rd page lru.next. This limit
>> the usage to hugetlb cgroup to only hugepages with 3 or more
>> normal pages. I guess that is an acceptable limitation.
>> 
>> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
>>   include/linux/hugetlb_cgroup.h |   31 +++++++++++++++++++++++++++++++
>>   mm/hugetlb.c                   |    4 ++++
>>   2 files changed, 35 insertions(+)
>> 
>> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
>> index 5794be4..ceff1d5 100644
>> --- a/include/linux/hugetlb_cgroup.h
>> +++ b/include/linux/hugetlb_cgroup.h
>> @@ -26,6 +26,26 @@ struct hugetlb_cgroup {
>>   };
>> 
>>   #ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
>> +static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
>> +{
>> +	if (!PageHuge(page))
>> +		return NULL;
>
> I'm not very sure but....
>
> 	VM_BUG_ON(!PageHuge(page)) ??
>
>
>
>> +	if (compound_order(page)<  3)
>> +		return NULL;
>> +	return (struct hugetlb_cgroup *)page[2].lru.next;
>> +}
>> +
>> +static inline
>> +int set_hugetlb_cgroup(struct page *page, struct hugetlb_cgroup *h_cg)
>> +{
>> +	if (!PageHuge(page))
>> +		return -1;
>
> ditto.
>
>> +	if (compound_order(page)<  3)
>> +		return -1;
>> +	page[2].lru.next = (void *)h_cg;
>> +	return 0;
>> +}
>> +

done

-aneesh
