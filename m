From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 2/8] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 10 Dec 2019 05:41:33 -0800
Message-ID: <20191210134133.GI32169@bombadil.infradead.org>
References: <1575978384-222381-1-git-send-email-alex.shi@linux.alibaba.com>
 <1575978384-222381-3-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ftX9rvm1yHZa4SUpNOQRgZGTA7du9HcjWYSa3Fi88Wo=; b=jAqsM/qUhmvw4P1Bolh5cygJ3
        hsbrlYtszIVFAu/Uxu1V6Mj+pSAeMQtx72QJYGIrX/2dGESI0JBL14Wij2exyavRDLZNVsksN3Qxt
        bIt9sgdQlvH0PRlPFwCCqIFQY/QBgOYVpcCEAcLzEFHU7lm62M+Ztlz7ihaJBlweBioVHZ+aZLGCL
        PVJUwBX1ySkYfQB3iBmM0v8qqtPK4pH68epCCof/Nf4eDtD7UyK+wqHG5ESjWPmmDEW3JeICjR//W
        HWCQQ1osShwzmfRxfa0z2pi4zet4xq5yEJXubTH6Mad7F1c9b1jRoTy+rogQZ89lu3LQkdP+pnAT1
Content-Disposition: inline
In-Reply-To: <1575978384-222381-3-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, shakeelb@google.com, hannes@cmpxchg.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh Kum

On Tue, Dec 10, 2019 at 07:46:18PM +0800, Alex Shi wrote:
> -static void lock_page_lru(struct page *page, int *isolated)
> +static struct lruvec *lock_page_lru(struct page *page, int *isolated)
>  {
> -	pg_data_t *pgdat = page_pgdat(page);
> +	struct lruvec *lruvec = lock_page_lruvec_irq(page);
>  
> -	spin_lock_irq(&pgdat->lru_lock);
>  	if (PageLRU(page)) {
> -		struct lruvec *lruvec;
>  
> -		lruvec = mem_cgroup_page_lruvec(page, pgdat);
>  		ClearPageLRU(page);
>  		del_page_from_lru_list(page, lruvec, page_lru(page));
>  		*isolated = 1;
>  	} else
>  		*isolated = 0;
> +
> +	return lruvec;
>  }

I still don't understand how this is supposed to work for !PageLRU
pages.  Which lruvec have you locked if this page isn't on an LRU?

