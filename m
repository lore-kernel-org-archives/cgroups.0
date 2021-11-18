From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v7] hugetlb: Add hugetlb.*.numa_stat file
Date: Wed, 17 Nov 2021 16:12:49 -0800
Message-ID: <86d3ba7a-3706-d66c-cbf7-d2c39ad2cd4c@oracle.com>
References: <20211117201825.429650-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rorM2zXxQd3+OmY4f8e7ideAQCMEkWoCzR2pbkmtGWk=;
 b=fnU7bhKuPI3Rl4xKEYT1JyZGEimfDcvs7JVKUEBO+b1y+jyIaTkIwG+UaZeTkb9hTOeE
 5J+2Zjki6mVgAHRmaT+I6NyAS0DEjDzXkhbtYbtQ1rmB6kyvBmsnW3jG2lBkZ+c0Cnjo
 HTJZp/7r4zsIH1LHjpdX/sTpqn6aLJLry7jJe3WLpe8RY2MrZVLnF/M+XdlcGtGldfy6
 JWA/A5tBsIYJrlyyFieKcNhv64PWFEz7MmjL7iE5PlK+3rwUUIGfqLSgxeuhG6j9ZPYL
 DVRtxIN98ia/ithi4uLO+Bg3IfWM7xZA5RL6/1Z+e7Up9iCGbzIqtM4eDvp3Utcbqexp xg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rorM2zXxQd3+OmY4f8e7ideAQCMEkWoCzR2pbkmtGWk=;
 b=QeTmKlEg3dXR/G4BAWrBEba6BnWtOX71tuBDg8KBHgdL4swnUAQaXktYiuZloY6u8Y7nNjprYNWOOfNUUkjP0lQUxvsRaz6z4Nq8fqSEnvuBjZy9vZ0KxQzD0o7jjiWZlD2NDQMJ3zO7kLgmmChB93NEyV5h0MO8vBAjldz5nxw=
Content-Language: en-US
In-Reply-To: <20211117201825.429650-1-almasrymina@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, Oscar Salvador <osalvador@suse.de>, Michal Hocko <mhocko@suse.com>, Muchun Song <songmuchun@bytedance.com>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Jue Wang <juew@google.com>, Yang Yao <ygyao@google.com>, Joanna Li <joannali@google.com>, Cannon Matthews <cannonmatthews@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On 11/17/21 12:18, Mina Almasry wrote:
...
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
...
> @@ -288,11 +317,21 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
>  					   struct hugetlb_cgroup *h_cg,
>  					   struct page *page, bool rsvd)
>  {
> +	unsigned long *usage;
> +

I assume the use of a pointer is just to make the following WRITE_ONCE
look better?  I prefer the suggestion by Muchun:

unsigned long usage = h_cg->nodeinfo[page_to_nid(page)]->usage[idx];

usage += nr_pages;
WRITE_ONCE(h_cg->nodeinfo[page_to_nid(page)]->usage[idx], usage);

I had to think for just a second 'why are we using/passing a pointer?'.
Not insisting we use Muchun's suggestion, it just caused me to think
a little more than necessary.

In any case, I would move the variable usage inside the
'if (!rsvd)' block.

>  	if (hugetlb_cgroup_disabled() || !h_cg)
>  		return;
> 
>  	__set_hugetlb_cgroup(page, h_cg, rsvd);
> -	return;
> +	if (!rsvd) {
> +		usage = &h_cg->nodeinfo[page_to_nid(page)]->usage[idx];
> +		/*
> +		 * This write is not atomic due to fetching *usage and writing
> +		 * to it, but that's fine because we call this with
> +		 * hugetlb_lock held anyway.
> +		 */
> +		WRITE_ONCE(*usage, *usage + nr_pages);
> +	}
>  }
> 
>  void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
> @@ -316,6 +355,7 @@ static void __hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
>  					   struct page *page, bool rsvd)
>  {
>  	struct hugetlb_cgroup *h_cg;
> +	unsigned long *usage;

Same here.

Otherwise, looks good to me.
-- 
Mike Kravetz
