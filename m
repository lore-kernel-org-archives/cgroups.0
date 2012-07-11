From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/hugetlb_cgroup: Add list_del to remove unused page
 from hugepage_activelist when hugepage migration
Date: Wed, 11 Jul 2012 18:16:18 +0800
Message-ID: <20120711101618.GA12033@kernel>
References: <1341978718-6423-1-git-send-email-liwp.linux@gmail.com>
 <87wr2aitpk.fsf@skywalker.in.ibm.com>
 <20120711091648.GA10841@kernel>
 <87txxeiqc0.fsf@skywalker.in.ibm.com>
Reply-To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=72ZaxE9L4TheX4kfxeLxOlgBSmkoBKafDR0UVjD6XQ4=;
        b=atq/NjLATX9B+UlsrmgUAF/yOKND8ymO9zwAn//0xWeqgmdmBzqU2lTgfDovvVyT4c
         x/qJ+0YQ/nSLAmRN36EUIYuYJ0LxTQQjDj9wi4C4lbq5Lw9g29NkxD2VcraD/ZhFf2Is
         Dea5aSUmFL2QjdHk5A4kw3MSK2VEOBMRBXBRgx80PpLU2SdGDjzHN4Y0MpJx+5MYg3LQ
         x1B077xBtXmLfVEDW+An4klBVCY0jqSPUlPodOKmMMNOEG79SApZ2JFN7ity2ZNz51U1
         PdfTGIT5v98RfT++lxpfOtiIS3Evqk79vAsLMKkRoZsMMYpuJ7kdkpQzGtghoGqbnHg7
         S30w==
Content-Disposition: inline
In-Reply-To: <87txxeiqc0.fsf-6yE53ggjAfyqSkle7U1LjlaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jul 11, 2012 at 03:15:19PM +0530, Aneesh Kumar K.V wrote:
>Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
>> On Wed, Jul 11, 2012 at 02:02:23PM +0530, Aneesh Kumar K.V wrote:
>>>Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>>>
>>>> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>>
>>>> hugepage_activelist is used to track currently used HugeTLB pages.
>>>> We can find the in-use HugeTLB pages to support HugeTLB cgroup
>>>> removal. Don't keep unused page in hugetlb_activelist too long.
>>>> Otherwise, on cgroup removal we should update the unused page's 
>>>> charge to parent count. To reduce this overhead, remove unused page 
>>>> from hugepage_activelist immediately.
>>>>
>>>> Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>> ---
>>>>  mm/hugetlb_cgroup.c |    1 +
>>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
>>>> index b834e8d..d819d66 100644
>>>> --- a/mm/hugetlb_cgroup.c
>>>> +++ b/mm/hugetlb_cgroup.c
>>>> @@ -398,6 +398,7 @@ void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
>>>>  	spin_lock(&hugetlb_lock);
>>>>  	h_cg = hugetlb_cgroup_from_page(oldhpage);
>>>>  	set_hugetlb_cgroup(oldhpage, NULL);
>>>> +	list_del(&oldhpage->lru);
>>>>
>>>>  	/* move the h_cg details to new cgroup */
>>>>  	set_hugetlb_cgroup(newhpage, h_cg);
>>>
>>>put_page on the oldhpage will do that. If we do list_del here
>>>free_huge_page() will have error list_move().
>>
>> I don't know if move the page to other lists when migration in order 
>> to reduce overhead I mentioned make sense. :-)
>>
>
>Even if we are in the active_list, we don't get anything wrong because
>hugetlb cgroup is set to NULL for the old hugetlb page. The above patch is
>wrong and will result in crash when we try to put_page the oldhpage.

Hi aneesh, I am happy we are in the same company. I am a guy in LTC
China. I want to know if there any features or works about hugetlb
cgroup I can do with you!

Regards,
Wanpeng Li

>
>-aneesh
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
