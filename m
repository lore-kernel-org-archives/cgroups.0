From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Tue, 15 Jul 2014 20:21:52 +0200
Message-ID: <20140715182152.GA30497@dhcp22.suse.cz>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715155537.GA19454@nhori.bos.redhat.com>
 <20140715160735.GB29269@dhcp22.suse.cz>
 <20140715173439.GU29639@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=nVWE54bIdCEhH+t/AU77Re3iwKlS6FpfAyW8a1dfs74=;
        b=wQDMbWU8MyG3ryVVPKRosZMUUsycqvbaqj+m1aPCp1KzOIUynx8OzA362u6OgedYSZ
         79CBBbXYlv0BcbFqEyM3iOYTuwB6UpSlTXXnWfNophNJ6nObW4RCplFcgGBQ7rqjIN0d
         0ewYd50nI6fNqB9r2bj1xDamX6CMDXRsXpVguKLE16dc1s32dFJ4uVo6LGMmRj/UAqXN
         hFZhbDPJxkE3WcR1tGnT7Zg7w5SKcFaa0UVbkM8v7D3YNxSktomS1sHhH/+QhzlXRDUk
         lyd+eKCk4SPSZmH60jGai0cGRiSP1zKABr9f96unrv0j9o9Yc8JLhtDN6Ycg09wkPaRl
         RJQA==
Content-Disposition: inline
In-Reply-To: <20140715173439.GU29639-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 15-07-14 13:34:39, Johannes Weiner wrote:
> On Tue, Jul 15, 2014 at 06:07:35PM +0200, Michal Hocko wrote:
> > On Tue 15-07-14 11:55:37, Naoya Horiguchi wrote:
> > > On Wed, Jun 18, 2014 at 04:40:45PM -0400, Johannes Weiner wrote:
> > > ...
> > > > diff --git a/mm/swap.c b/mm/swap.c
> > > > index a98f48626359..3074210f245d 100644
> > > > --- a/mm/swap.c
> > > > +++ b/mm/swap.c
> > > > @@ -62,6 +62,7 @@ static void __page_cache_release(struct page *page)
> > > >  		del_page_from_lru_list(page, lruvec, page_off_lru(page));
> > > >  		spin_unlock_irqrestore(&zone->lru_lock, flags);
> > > >  	}
> > > > +	mem_cgroup_uncharge(page);
> > > >  }
> > > >  
> > > >  static void __put_single_page(struct page *page)
> > > 
> > > This seems to cause a list breakage in hstate->hugepage_activelist
> > > when freeing a hugetlbfs page.
> > 
> > This looks like a fall out from
> > http://marc.info/?l=linux-mm&m=140475936311294&w=2
> > 
> > I didn't get to review this one but the easiest fix seems to be check
> > HugePage and do not call uncharge.
> 
> Yes, that makes sense.  I'm also moving the uncharge call into
> __put_single_page() and __put_compound_page() so that PageHuge(), a
> function call, only needs to be checked for compound pages.

Hmm, there doesn't seem to be any point in calling __page_cache_release
for HugePage as well. So it should be sufficient that
__put_compound_page doesn't call __page_cache_release for PageHuge and
uncharge can stay there. Maybe this would be slightly better...
-- 
Michal Hocko
SUSE Labs
