From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 12/13] mm: memcontrol: rewrite charge API
Date: Mon, 14 Jul 2014 20:43:02 +0200
Message-ID: <20140714184302.GA2094@dhcp22.suse.cz>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-13-git-send-email-hannes@cmpxchg.org>
 <20140714150446.GD30713@dhcp22.suse.cz>
 <20140714171324.GQ29639@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=SavloavQlo4Fo+HuCGU0x5gFAmKEZGq4F6jqebVbS+s=;
        b=YSjXrQxLIZIgDlSgwm+/HLsuGMs1cb9woUK25ebdY7D/DZrt6bEP7/qBPI2hakNHn4
         de+iPCSdMWGAJ55g75ARD32iwZZEPIujwwDykWBNtt31CscF1S0rMdKFY6doOuqkbrCx
         5neQIa56t4m07JLXhY3KKeHB1LBVrAZA5w/ZLBZ8KUX0Bs1axd+IEmvYV8zBaHdrkGvL
         zfiewcolhp/RHcAikImfTIZ5wXHPusIxYxe7jiK3JFaicqiD/hYtni3dkOzkB+I43lBr
         d2jQmU704P7TPpYge56tMBHXjYQBgQhhNtJy9HXTiomkWRvk6btCZ/drV0QLGcD1hzgg
         VVfg==
Content-Disposition: inline
In-Reply-To: <20140714171324.GQ29639@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon 14-07-14 13:13:24, Johannes Weiner wrote:
> On Mon, Jul 14, 2014 at 05:04:46PM +0200, Michal Hocko wrote:
> > Hi,
> > I've finally manage to untagle myself from internal stuff...
> > 
> > On Wed 18-06-14 16:40:44, Johannes Weiner wrote:
> > > The memcg charge API charges pages before they are rmapped - i.e. have
> > > an actual "type" - and so every callsite needs its own set of charge
> > > and uncharge functions to know what type is being operated on.  Worse,
> > > uncharge has to happen from a context that is still type-specific,
> > > rather than at the end of the page's lifetime with exclusive access,
> > > and so requires a lot of synchronization.
> > > 
> > > Rewrite the charge API to provide a generic set of try_charge(),
> > > commit_charge() and cancel_charge() transaction operations, much like
> > > what's currently done for swap-in:
> > > 
> > >   mem_cgroup_try_charge() attempts to reserve a charge, reclaiming
> > >   pages from the memcg if necessary.
> > > 
> > >   mem_cgroup_commit_charge() commits the page to the charge once it
> > >   has a valid page->mapping and PageAnon() reliably tells the type.
> > > 
> > >   mem_cgroup_cancel_charge() aborts the transaction.
> > > 
> > > This reduces the charge API and enables subsequent patches to
> > > drastically simplify uncharging.
> > > 
> > > As pages need to be committed after rmap is established but before
> > > they are added to the LRU, page_add_new_anon_rmap() must stop doing
> > > LRU additions again.  Revive lru_cache_add_active_or_unevictable().
> > 
> > I think it would make more sense to do
> > lru_cache_add_active_or_unevictable in a separate patch for easier
> > review. Too late, though...
> > 
> > Few comments bellow
> > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > The patch looks correct but the code is quite tricky so I hope I didn't
> > miss anything.
> > 
> > Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> Thanks!
> 
> > > @@ -54,28 +54,11 @@ struct mem_cgroup_reclaim_cookie {
> > >  };
> > >  
> > >  #ifdef CONFIG_MEMCG
> > > -/*
> > > - * All "charge" functions with gfp_mask should use GFP_KERNEL or
> > > - * (gfp_mask & GFP_RECLAIM_MASK). In current implementatin, memcg doesn't
> > > - * alloc memory but reclaims memory from all available zones. So, "where I want
> > > - * memory from" bits of gfp_mask has no meaning. So any bits of that field is
> > > - * available but adding a rule is better. charge functions' gfp_mask should
> > > - * be set to GFP_KERNEL or gfp_mask & GFP_RECLAIM_MASK for avoiding ambiguous
> > > - * codes.
> > > - * (Of course, if memcg does memory allocation in future, GFP_KERNEL is sane.)
> > > - */
> > 
> > I think we should slightly modify the comment but the primary idea
> > should stay there. What about the following?
> > /*
> >  * Although memcg charge functions do not allocate any memory they are
> >  * still getting GFP mask to control the reclaim process (therefore
> >  * gfp_mask & GFP_RECLAIM_MASK is expected).
> >  * GFP_KERNEL should be used for the general charge path without any
> >  * constraints for the reclaim
> >  * __GFP_WAIT should be cleared for atomic contexts
> >  * __GFP_NORETRY should be set for charges which might fail rather than
> >  * spend too much time reclaiming
> >  * __GFP_NOFAIL should be set for charges which cannot fail.
> >  */
> 
> What *is* the primary idea here?
> 
> Taking any kind of gfp mask and interpreting the bits that pertain to
> you is done in a lot of places already, and there really is no need to
> duplicate the documentation and risk it getting stale and misleading.

The idea was to document which flags do we care about as not all of them
are implemented. On the other hand I do agree that stale doc is worse
than no doc.

[...]
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
