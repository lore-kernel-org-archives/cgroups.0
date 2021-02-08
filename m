From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/8] cgroup: rstat: punt root-level optimization to
 individual controllers
Date: Mon, 8 Feb 2021 10:58:11 -0500
Message-ID: <YCFfkxytFaYooidE@slm.duckdns.org>
References: <20210205182806.17220-1-hannes@cmpxchg.org>
 <20210205182806.17220-6-hannes@cmpxchg.org>
 <YB4OT61owRaze5/M@mtj.duckdns.org>
 <YCGfIYTLzcTO+ng8@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tqRaxICy5YHBMmHcX2M4Wd1YNoE/TgL6qyHQaFgZCcY=;
        b=Kbipus5vPp2mNkhFtKdD511qL2yTMBCGkJZfr16sI2xPQnoo74CcVb7BKoEvNsK0Ka
         uhkpzga2kyNnhAT8doX26kRfoHUMEh4usIoPhV1QXcI2l7N6BuHrhC5pj7g0nRcThPfM
         Im3oy3HkeuZHZPj26peXKX7xI4Q9Gw27KDbhyW4CvpnP7D+0Qm76ctrraFJM+mjD5jSG
         7huMyxqW0/n0d3Rm74L0WMPLdSydyk2YfXTZXTtJzY4NGFMUamuDbbqU5exQeM4Lk9US
         mHcN3S9Rqqm7mORgR40fI2W97hMnvhan02fsuGrxKZW1wV1MMqdvgxNdhbrDp6nPQRrs
         sI5w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YCGfIYTLzcTO+ng8-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Mon, Feb 08, 2021 at 03:29:21PM -0500, Johannes Weiner wrote:
> > > @@ -789,6 +793,7 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
> > >  		u64_stats_update_end(&blkg->iostat.sync);
> > >  
> > >  		/* propagate global delta to parent */
> > > +		/* XXX: could skip this if parent is root */
> > >  		if (parent) {
> > >  			u64_stats_update_begin(&parent->iostat.sync);
> > >  			blkg_iostat_set(&delta, &blkg->iostat.cur);
> > 
> > Might as well update this similar to cgroup_base_stat_flush()?
> 
> I meant to revisit that, but I'm never 100% confident when it comes to
> the interaction and lifetime of css, blkcg and blkg_gq.

Yeah, it does get hairy.

> IIUC, the blkg_gq->parent linkage always matches the css parent
> linkage; it just exists as an optimization for ancestor walks, which
> would otherwise have to do radix lookups when going through the css.

But yes, at least this part is straight-forward.

> So with the cgroup_parent() check at the beginning of the function
> making sure we're looking at a non-root group, blkg_gq->parent should
> also never be NULL and I can do if (paren->parent) directly, right?

I think so.

> > >  static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
> > >  {
> > > -	struct cgroup *parent = cgroup_parent(cgrp);
> > >  	struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
> > > +	struct cgroup *parent = cgroup_parent(cgrp);
> > 
> > Is this chunk intentional?
> 
> Yeah, it puts the local variable declarations into reverse christmas
> tree ordering to make them a bit easier to read. It's a while-at-it
> cleanup, mostly a force of habit. I can drop it if it bothers you.

I don't mind either way. Was just wondering whether it was accidental.

Thanks.

-- 
tejun
