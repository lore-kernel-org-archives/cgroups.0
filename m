From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v20 04/20] mm/thp: use head for head page in
 lru_add_page_tail
Date: Mon, 2 Nov 2020 16:03:57 +0000
Message-ID: <20201102160357.GP27442@casper.infradead.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-5-git-send-email-alex.shi@linux.alibaba.com>
 <20201029135047.GE599825@cmpxchg.org>
 <06a5b7d8-bbf2-51b7-1352-2b630186e15f@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ById62lxNkbzmGe1y6sEW9CH+Xn28r08JtKiwHI4ZFE=; b=eXXZJcEJI37a+/rq1NcdCftKu9
        1w1qhi7JK4Le0V6NXiB4NVW+gvn9ySrTjTmOENM8vLHMoaZsenii71Nci4qAeWZ0mamhK8a35JlQK
        J6cojCg0ge0utPapk8k+jZjA6fWe4Fy6jHXiyGPgdfX9BY6C+qR/NI+aInfubiQUD76BE/6AuMWf6
        2rZwOBSfaFCGmbL4e9iS4ymkQ4uuSmJgbUmrZEe7AuPpgfqxeEoNWiItbK37ZJp7oIKQTDRWtkIfD
        RaNYRb+6U8KoxF7lQmMkTuC3Lqs1i1WIXcnj20sKrUrkN/yGwYgCfwn+13jRLArwa8HrkX306cFP0
        r5FYl46Q==;
Content-Disposition: inline
In-Reply-To: <06a5b7d8-bbf2-51b7-1352-2b630186e15f@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com

On Fri, Oct 30, 2020 at 10:46:54AM +0800, Alex Shi wrote:
> -static void lru_add_page_tail(struct page *page, struct page *page_tail,
> +static void lru_add_page_tail(struct page *head, struct page *tail,
>  		struct lruvec *lruvec, struct list_head *list)
>  {
> -	VM_BUG_ON_PAGE(!PageHead(page), page);
> -	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
> -	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
> +	VM_BUG_ON_PAGE(!PageHead(head), head);
> +	VM_BUG_ON_PAGE(PageCompound(tail), head);
> +	VM_BUG_ON_PAGE(PageLRU(tail), head);

These last two should surely have been
	VM_BUG_ON_PAGE(PageCompound(tail), tail);
	VM_BUG_ON_PAGE(PageLRU(tail), tail);

Also, what do people think about converting these to VM_BUG_ON_PGFLAGS?

Either way:

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
