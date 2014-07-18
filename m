From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Fri, 18 Jul 2014 09:12:46 +0200
Message-ID: <20140718071246.GA21565@dhcp22.suse.cz>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715082545.GA9366@dhcp22.suse.cz>
 <20140715121935.GB9366@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dBbmwTbbbfJ7+ZsLVOwurIMgS3Xw8YvWRBMZKmmyV40=;
        b=dkvZH0P8hBHfknbEcRdbhBOEtPIsEKMLo8pD42YmmlXYRLFDZJg3utgPBsXFRrS0h7
         MNVVZCcuuw7z+xmdpXAh+aqNIb+Cuqst/pOZgnSaP4IfDrwxM4jz8EYvqUCgaCvOmj28
         DuETNAPUZ0QrbAdR8dsiUaCi1TAEy+ajp0/0wgSVgQteE9N/RMG1iJkr88A2JbV5PT82
         lABVPPS02Q8rH7wxal/qMNydFVntNugmQJ0QbocIGE6SP1Nh2sKucFMehuLEoDh+gW4p
         PuJms4DjIKjqsdh4Cw1xhUW9ovdbPYU52XwUnv07t2CYyse7ifApTWxATfOc77tnZMgY
         l8hg==
Content-Disposition: inline
In-Reply-To: <20140715121935.GB9366@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue 15-07-14 14:19:35, Michal Hocko wrote:
> [...]
> > +/**
> > + * mem_cgroup_migrate - migrate a charge to another page
> > + * @oldpage: currently charged page
> > + * @newpage: page to transfer the charge to
> > + * @lrucare: page might be on LRU already
> 
> which one? I guess the newpage?
> 
> > + *
> > + * Migrate the charge from @oldpage to @newpage.
> > + *
> > + * Both pages must be locked, @newpage->mapping must be set up.
> > + */
> > +void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
> > +			bool lrucare)
> > +{
> > +	unsigned int nr_pages = 1;
> > +	struct page_cgroup *pc;
> > +
> > +	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
> > +	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
> > +	VM_BUG_ON_PAGE(PageLRU(oldpage), oldpage);
> > +	VM_BUG_ON_PAGE(PageLRU(newpage), newpage);
> 
> 	VM_BUG_ON_PAGE(PageLRU(newpage) && !lruvec, newpage);

I guess everything except these two notes got addressed.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
