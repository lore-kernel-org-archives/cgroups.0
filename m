From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 3/8] mm: memcg: inline mem_cgroup_charge_common()
Date: Wed, 12 Mar 2014 10:53:00 -0400
Message-ID: <20140312145300.GC14688@cmpxchg.org>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
 <1394587714-6966-4-git-send-email-hannes@cmpxchg.org>
 <20140312125213.GB11831@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=dJsZcdoMXG88l2QTGhl5+1RsWw6zs6iTzTE2i/7G6tg=;
	b=Qy6u/Otm+wZ4gkRPpEeJk8KpV6NtM4sBWKl78Fec077MmZ9W3BgPh59XYOn1E7ZNpEmzTU+AfHEYNMSTDNb0gxHIx+nPmP9uZdzGoP35aXyozhopWsaQdy6UiRxUGBGK9j7p3LclNI3Ml54PG/AYkNoHgY7lQv1Lr5VAUkdGxlc=;
Content-Disposition: inline
In-Reply-To: <20140312125213.GB11831@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 01:52:13PM +0100, Michal Hocko wrote:
> On Tue 11-03-14 21:28:29, Johannes Weiner wrote:
> [...]
> > @@ -3919,20 +3919,21 @@ out:
> >  	return ret;
> >  }
> >  
> > -/*
> > - * Charge the memory controller for page usage.
> > - * Return
> > - * 0 if the charge was successful
> > - * < 0 if the cgroup is over its limit
> > - */
> > -static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
> > -				gfp_t gfp_mask, enum charge_type ctype)
> > +int mem_cgroup_newpage_charge(struct page *page,
> > +			      struct mm_struct *mm, gfp_t gfp_mask)
> 
> s/mem_cgroup_newpage_charge/mem_cgroup_anon_charge/ ?
> 
> Would be a better name? The patch would be bigger but the name more
> apparent...

I wouldn't be opposed to fixing those names at all, but I think that
is out of the scope of this patch.  Want to send one?

mem_cgroup_charge_anon() would be a good name, but then we should also
rename mem_cgroup_cache_charge() to mem_cgroup_charge_file() to match.

Or charge_private() vs. charge_shared()...

> Other than that I am good with this. Without (preferably) or without
> rename:
> Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
