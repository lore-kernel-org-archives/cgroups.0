From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 3/9] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 19 Nov 2019 11:44:48 -0500
Message-ID: <20191119164448.GA396644@cmpxchg.org>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
 <1574166203-151975-4-git-send-email-alex.shi@linux.alibaba.com>
 <20191119155704.GP20752@bombadil.infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zDBiRfFmubevLJV/wK2eb+YrsoC2fdQK9RvQnh7Da5M=;
        b=oDIPg4xCvt+FI8k7NV6RunpeXQu5TzDO2AQca/h0guGU4mgiq1YtDvI6V7LBxsaqq1
         uwfSLg0IcO4TaXVfotXy+i7rNoLMt0PZ6I8K3ThD3VGWQID8Fjl83+9XEhUriUJx3+g0
         0CzUtYPbOLTHDP3iDEv1yEzYoD7v8IpCbpfdiQsdXs/GiCDtuzmhZBqcY/rWbYwSADGR
         +RDSDa21cGwXkTrArBpw1fWESvOV6UzVqxuufjvGN2nrtcT8w6dlObbUyiIMeo9ilkLr
         Oz36AFMlb8Hm5Y3i2tJb2unF7k/PcMNsjY1DWl4W379Z/mzSC61zlxVa4JkS9/CCc4x7
         M/LQ==
Content-Disposition: inline
In-Reply-To: <20191119155704.GP20752@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, shakeelb@google.com, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>

On Tue, Nov 19, 2019 at 07:57:04AM -0800, Matthew Wilcox wrote:
> On Tue, Nov 19, 2019 at 08:23:17PM +0800, Alex Shi wrote:
> > +static inline struct lruvec *lock_page_lruvec_irqsave(struct page *page,
> > +				struct pglist_data *pgdat, unsigned long *flags)
> > +{
> > +	struct lruvec *lruvec = mem_cgroup_page_lruvec(page, pgdat);
> > +
> > +	spin_lock_irqsave(&lruvec->lru_lock, *flags);
> > +
> > +	return lruvec;
> > +}
> 
> This should be a macro, not a function.  You basically can't do this;
> spin_lock_irqsave needs to write to a variable which can then be passed
> to spin_unlock_irqrestore().  What you're doing here will dereference the
> pointer in _this_ function, but won't propagate the modified value back to
> the caller.  I suppose you could do something like this ...

This works because spin_lock_irqsave and local_irq_save() are
macros. It boils down to '*flags = arch_local_irq_save()' in this
function, and therefor does the right thing.

We exploit that in quite a few places:

$ git grep 'spin_lock_irqsave(.*\*flags' | wc -l
39
