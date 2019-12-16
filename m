From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v6 02/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 16 Dec 2019 04:14:27 -0800
Message-ID: <20191216121427.GZ32169@bombadil.infradead.org>
References: <1576488386-32544-1-git-send-email-alex.shi@linux.alibaba.com>
 <1576488386-32544-3-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cJuNyiJ6x2GmYYoz1Gvq9PWu1CKComrXo+DxXGJQ3kE=; b=WkHus4CkcBNFVoG84isWKSEOd
        RozRAuZWCdoYEDviJCWowXeaBRF2NBjp2g+BCGy2DbC7PxVBPdYxYC/qAoyQIJOe7P6Q7zPC1+W3x
        mqaVqhCaH6fkD4m5t+4LpI17CQ/4gIAYT8rrRhqSr67/+W5yl8xmfxFI35Ka0AQqf26tWwcArkM+w
        wPcKnDawJabaXS4XiexrIXicQ2YEHJFqKLfU8aYKGsQe4r8SyCAlzLfH8hkWOdrG72a+hDrm6C1Sl
        uYBbGjoOufC9SmziLadJpk/RWsLmyf8x9sp2PiMAwvfIz2NMAOzwxiCknWzlbJKiflpdzLncbh6aX
Content-Disposition: inline
In-Reply-To: <1576488386-32544-3-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, shakeelb@google.com, hannes@cmpxchg.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh Kum

On Mon, Dec 16, 2019 at 05:26:18PM +0800, Alex Shi wrote:
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

You still didn't fix this function.  Go back and look at my comment from
the last time you sent this patch set.
