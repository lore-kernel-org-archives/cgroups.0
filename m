From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V8 14/16] hugetlb/cgroup: add charge/uncharge calls for HugeTLB alloc/free
Date: Mon, 11 Jun 2012 15:59:11 +0530
Message-ID: <8762ay5eh4.fsf@skywalker.in.ibm.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-15-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120611092133.GI12402@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120611092133.GI12402@tiehlicka.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Sat 09-06-12 14:29:59, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> This adds necessary charge/uncharge calls in the HugeTLB code.  We do
>> hugetlb cgroup charge in page alloc and uncharge in compound page destructor.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> ---
>>  mm/hugetlb.c        |   16 +++++++++++++++-
>>  mm/hugetlb_cgroup.c |    7 +------
>>  2 files changed, 16 insertions(+), 7 deletions(-)
>> 
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index bf79131..4ca92a9 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -628,6 +628,8 @@ static void free_huge_page(struct page *page)
>>  	BUG_ON(page_mapcount(page));
>>  
>>  	spin_lock(&hugetlb_lock);
>> +	hugetlb_cgroup_uncharge_page(hstate_index(h),
>> +				     pages_per_huge_page(h), page);
>>  	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
>>  		/* remove the page from active list */
>>  		list_del(&page->lru);
>> @@ -1116,7 +1118,10 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>>  	struct hstate *h = hstate_vma(vma);
>>  	struct page *page;
>>  	long chg;
>> +	int ret, idx;
>> +	struct hugetlb_cgroup *h_cg;
>>  
>> +	idx = hstate_index(h);
>>  	/*
>>  	 * Processes that did not create the mapping will have no
>>  	 * reserves and will not have accounted against subpool
>> @@ -1132,6 +1137,11 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>>  		if (hugepage_subpool_get_pages(spool, chg))
>>  			return ERR_PTR(-ENOSPC);
>>  
>> +	ret = hugetlb_cgroup_charge_page(idx, pages_per_huge_page(h), &h_cg);
>
> So we do not have any page yet and hugetlb_cgroup_charge_cgroup sound
> more appropriate
>

Will do

-aneesh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
