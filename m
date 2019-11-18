From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 3/7] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 18 Nov 2019 11:11:26 -0500
Message-ID: <20191118161126.GB365174@cmpxchg.org>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573874106-23802-4-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j0SqAQT8llYIw4e/49l3a9ohNbFeVl5zPNeEm/Wp4s0=;
        b=D4nk0Siou5s/cqdoqRqvYGa8zjueKxO+SjyVZm6/zT83sFfDUd2SnGh1k9QnwDRDrx
         CH6WGIyRKE0rF+mnWZMd8pHyYqF+YLfdNHGtqMo/fOoR4AXXtBL0Cj7J0CMVPjVHqH1A
         5p89M+K8M+qZDQsxCDXAtPbwLRRrKzSr3XyWyZ95bNw/QI/aHZbmCL8249BGxWEd1uNi
         NmxnkCqIoZnTJ4pMiiNzMsyDF7nPDvcgoyhCtivfuijsRgBIc92NpnNww90o0JoHuJom
         W1UH6Cibz2Uc69M0LwpMJivjKj1PUsQuKOhtJZg9yyVl2bQ6Et0jog0H3A2vuFx+O7mN
         fvRQ==
Content-Disposition: inline
In-Reply-To: <1573874106-23802-4-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.c>

On Sat, Nov 16, 2019 at 11:15:02AM +0800, Alex Shi wrote:
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 62470325f9bc..cf274739e619 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1246,6 +1246,42 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
>  	return lruvec;
>  }
>  
> +struct lruvec *lock_page_lruvec_irq(struct page *page,
> +					struct pglist_data *pgdat)
> +{
> +	struct lruvec *lruvec;
> +
> +again:
> +	lruvec = mem_cgroup_page_lruvec(page, pgdat);
> +	spin_lock_irq(&lruvec->lru_lock);

This isn't safe. Nothing prevents the page from being moved to a
different memcg in between these two operations, and the lruvec having
been freed by the time you try to acquire the spinlock.

You need to use the rcu lock to dereference page->mem_cgroup and its
lruvec when coming from the page like this.

You also need to use page_memcg_rcu() to insert the appropriate
lockless access barriers, which mem_cgroup_page_lruvec() does not do
since it's designed for use with pgdat->lru_lock.
