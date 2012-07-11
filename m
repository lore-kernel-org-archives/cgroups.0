From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm/hugetlb_cgroup: Add list_del to remove unused page from hugepage_activelist when hugepage migration
Date: Wed, 11 Jul 2012 15:15:19 +0530
Message-ID: <87txxeiqc0.fsf@skywalker.in.ibm.com>
References: <1341978718-6423-1-git-send-email-liwp.linux@gmail.com> <87wr2aitpk.fsf@skywalker.in.ibm.com> <20120711091648.GA10841@kernel>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120711091648.GA10841@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>

Wanpeng Li <liwp.linux@gmail.com> writes:

> On Wed, Jul 11, 2012 at 02:02:23PM +0530, Aneesh Kumar K.V wrote:
>>Wanpeng Li <liwp.linux@gmail.com> writes:
>>
>>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>>>
>>> hugepage_activelist is used to track currently used HugeTLB pages.
>>> We can find the in-use HugeTLB pages to support HugeTLB cgroup
>>> removal. Don't keep unused page in hugetlb_activelist too long.
>>> Otherwise, on cgroup removal we should update the unused page's 
>>> charge to parent count. To reduce this overhead, remove unused page 
>>> from hugepage_activelist immediately.
>>>
>>> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>>> ---
>>>  mm/hugetlb_cgroup.c |    1 +
>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
>>> index b834e8d..d819d66 100644
>>> --- a/mm/hugetlb_cgroup.c
>>> +++ b/mm/hugetlb_cgroup.c
>>> @@ -398,6 +398,7 @@ void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
>>>  	spin_lock(&hugetlb_lock);
>>>  	h_cg = hugetlb_cgroup_from_page(oldhpage);
>>>  	set_hugetlb_cgroup(oldhpage, NULL);
>>> +	list_del(&oldhpage->lru);
>>>
>>>  	/* move the h_cg details to new cgroup */
>>>  	set_hugetlb_cgroup(newhpage, h_cg);
>>
>>put_page on the oldhpage will do that. If we do list_del here
>>free_huge_page() will have error list_move().
>
> I don't know if move the page to other lists when migration in order 
> to reduce overhead I mentioned make sense. :-)
>

Even if we are in the active_list, we don't get anything wrong because
hugetlb cgroup is set to NULL for the old hugetlb page. The above patch is
wrong and will result in crash when we try to put_page the oldhpage.

-aneesh
