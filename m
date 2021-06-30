From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 17/18] mm/memcg: Add folio_lruvec_relock_irq() and
 folio_lruvec_relock_irqsave()
Date: Wed, 30 Jun 2021 10:39:48 +0200
Message-ID: <YNwt1P0c6RxyQHq3@dhcp22.suse.cz>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-18-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625042389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LAok8aXqVPRw4PDdITfa7F/8C/VBQZ8wiZP19XKfIr4=;
        b=nSWI2n/eeRY5vZ8luIa/myWC8es4URiXrfWhkVK5QQ03iSKA0n2lQTT7LilT67L6m2SMgV
        bv2lagtUox3xY0aiP46UEorTxBTnVDoBaZMml4Iev7Cnt0L1r5sj9ahTFbNP6DRBJ67DIP
        JQLV6CMw30x+rh+nmkq1QGG+SOcRFAg=
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-18-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 30-06-21 05:00:33, Matthew Wilcox wrote:
> These are the folio equivalents of relock_page_lruvec_irq() and
> folio_lruvec_relock_irqsave(), which are retained as compatibility wrappers.
> Also convert lruvec_holds_page_lru_lock() to folio_lruvec_holds_lru_lock().

$ git grep relock_page_lruvec_irqsave
include/linux/memcontrol.h:static inline struct lruvec *relock_page_lruvec_irqsave(struct page *page,

on your tree.
-- 
Michal Hocko
SUSE Labs
