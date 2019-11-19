From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 3/9] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 19 Nov 2019 07:57:04 -0800
Message-ID: <20191119155704.GP20752@bombadil.infradead.org>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
 <1574166203-151975-4-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=W1uhPT3svlAF0ny/aKL/GHGJkaklH1eD5N8ZBRDMDjQ=; b=Xfdf/vrhOYcquHoQNoWpTcYtN
        kuKDO7Bj0HAO9PGeYCNBHKD8xBrQdnj0NBMreHHZsj6FewQ1lt2CJRl5hZh7TsQLGgENhL3m9Y2vg
        hgFjZX+aDnEaE4AoEMRRRAl7sFpRoDW7RF27nGb6Djf9AI9Tj5n16mNuwfZMKDqQd48sFww3pKSoO
        A3tzKcDLGANz00inclHZMDPUpgPNRT5lBfyG4pYvTruFLURextxyUhR1r2/NAqX65anAsLCtSBbTG
        fcpQx31yG7SOO80NCnOArA/EM6w9iLaF4Y5dqIt2zQua0YL/9XPDRqNicbv1QzgepjAfcZST2eANh
Content-Disposition: inline
In-Reply-To: <1574166203-151975-4-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, shakeelb@google.com, hannes@cmpxchg.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh Kum

On Tue, Nov 19, 2019 at 08:23:17PM +0800, Alex Shi wrote:
> +static inline struct lruvec *lock_page_lruvec_irqsave(struct page *page,
> +				struct pglist_data *pgdat, unsigned long *flags)
> +{
> +	struct lruvec *lruvec = mem_cgroup_page_lruvec(page, pgdat);
> +
> +	spin_lock_irqsave(&lruvec->lru_lock, *flags);
> +
> +	return lruvec;
> +}

This should be a macro, not a function.  You basically can't do this;
spin_lock_irqsave needs to write to a variable which can then be passed
to spin_unlock_irqrestore().  What you're doing here will dereference the
pointer in _this_ function, but won't propagate the modified value back to
the caller.  I suppose you could do something like this ...

static inline struct lruvec *lock_page_lruvec_irqsave(struct page *page,
			struct pglist_data *pgdat, unsigned long *flagsp)
{
	unsigned long flags;
	struct lruvec *lruvec = mem_cgroup_page_lruvec(page, pgdat);

	spin_lock_irqsave(&lruvec->lru_lock, flags);
	*flagsp = flags;

	return lruvec;
}

Almost certainly easier to write a macro though.

You shouldn't need the two prior patches with this kind of change.
