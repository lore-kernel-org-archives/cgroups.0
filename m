From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 03/12] mm: huge_memory: use GFP_TRANSHUGE when charging
 huge pages
Date: Wed, 18 Jun 2014 16:26:17 -0400
Message-ID: <20140618202617.GE7331@cmpxchg.org>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
 <1402948472-8175-4-git-send-email-hannes@cmpxchg.org>
 <20140617142317.GD19886@dhcp22.suse.cz>
 <20140617153814.GB7331@cmpxchg.org>
 <20140617162747.GB9572@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=skxcjtBfm0AYfhE/OD+bSwju+Yz/iFcNYD6KZFqKjjA=;
	b=c+xCmVOy9fEBbqTKX2OWiyP6xz0zUgHxwApcaWMmPFEH8N1oK7gJYHr4h+7Tl1xgCpHotn9kVUpvE0FzMSXl0CxAIpSuMzIDtcRpn8jh72kmqD1OcPGlbOv19cQTtuc2CbwlnyO7wNYddZtG1+7P9JCMhipToiGUaW9fkCVL27s=;
Content-Disposition: inline
In-Reply-To: <20140617162747.GB9572-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 17, 2014 at 06:27:47PM +0200, Michal Hocko wrote:
> On Tue 17-06-14 11:38:14, Johannes Weiner wrote:
> > On Tue, Jun 17, 2014 at 04:23:17PM +0200, Michal Hocko wrote:
> [...]
> > > @@ -2647,7 +2645,7 @@ retry:
> > >  	if (fatal_signal_pending(current))
> > >  		goto bypass;
> > >  
> > > -	if (!oom)
> > > +	if (!oom_gfp_allowed(gfp_mask))
> > >  		goto nomem;
> > 
> > We don't actually need that check: if __GFP_NORETRY is set, we goto
> > nomem directly after reclaim fails and don't even reach here.
> 
> I meant it for further robustness. If we ever change oom_gfp_allowed in
> future and have new and unexpected users then we should back off.  Or
> maybe WARN_ON(!oom_gfp_allowed(gfp_mask)) would be more appropriate to
> catch those and fix the charging code or the charger?

There is a slight deviation from the page allocator in that we could
potentially invoke OOM on NOFS charges, but I'm not sure whether NOFS
flags are wrong to enter the memcg charge code, per se, so the WARN_ON
would appear like a fairly random restriction to have...

> > From eda800d2aa2376d347d6d4f7660e3450bd4c5dbb Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > Date: Tue, 17 Jun 2014 11:10:59 -0400
> > Subject: [patch] mm: memcontrol: remove explicit OOM parameter in charge path
> > 
> > For the page allocator, __GFP_NORETRY implies that no OOM should be
> > triggered, whereas memcg has an explicit parameter to disable OOM.
> > 
> > The only callsites that want OOM disabled are THP charges and charge
> > moving.  THP already uses __GFP_NORETRY and charge moving can use it
> > as well - one full reclaim cycle should be plenty.  Switch it over,
> > then remove the OOM parameter.
> > 
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Thanks!
