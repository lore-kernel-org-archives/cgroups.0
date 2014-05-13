From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: deprecate memory.force_empty knob
Date: Tue, 13 May 2014 09:16:56 -0400
Message-ID: <20140513131655.GC18849@cmpxchg.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-3-git-send-email-tj@kernel.org>
 <20140512145324.GE9564@dhcp22.suse.cz>
 <20140512145803.GF9564@dhcp22.suse.cz>
 <20140512150014.GB1421@htj.dyndns.org>
 <20140512152015.GH9564@dhcp22.suse.cz>
 <20140512152507.GD1421@htj.dyndns.org>
 <20140512153458.GJ9564@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=Q+scfMN8wsJ8noaBbh1SQWPaUMaEeldhd6Ajvyba66A=;
	b=VwEccOL0M7gnoUJAkHwbGy8TGqWPLjYxrvdaybyKbXhkhD0KpU89FR5mGQYv+Gb/ZpsBV542mUoK95KzjHgyJYKPfa9LKEW//MEvt/sERspNOneqym/mxQpffAepqWnlN9VB8b0L53Td5RPXX8tmSNNCSA+ERtkku4cIWYKfZIY=;
Content-Disposition: inline
In-Reply-To: <20140512153458.GJ9564-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, May 12, 2014 at 05:34:58PM +0200, Michal Hocko wrote:
> On Mon 12-05-14 11:25:07, Tejun Heo wrote:
> > On Mon, May 12, 2014 at 05:20:15PM +0200, Michal Hocko wrote:
> > > On Mon 12-05-14 11:00:14, Tejun Heo wrote:
> > > > On Mon, May 12, 2014 at 04:58:03PM +0200, Michal Hocko wrote:
> > > > > @@ -4793,6 +4793,10 @@ static int mem_cgroup_force_empty_write(struct cgroup_subsys_state *css,
> > > > >  
> > > > >  	if (mem_cgroup_is_root(memcg))
> > > > >  		return -EINVAL;
> > > > > +	pr_info("%s (%d): memory.force_empty is deprecated and will be removed.",
> > > > > +			current->comm, task_pid_nr(current));
> > > > > +	pr_cont(" Let us know if you know if it needed in your usecase at");
> > > > > +	pr_cont(" linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org\n");
> > > > >  	return mem_cgroup_force_empty(memcg);
> > > > 
> > > > It probably would be way easier to just mark the knob with
> > > > CFTYPE_INSANE.
> > > 
> > > That would prevent from creating the file, right? I do not mind that but
> > > I would like to see people complaining before.
> > 
> > Oh sure, if you wanna see people complaining before the roll out of
> > unified hierarchy, but let's make sure it's also marked with
> > CFTYPE_INSANE.  It's easy to remove the flag afterwards.  The other
> > way isn't, so...
> ---
> >From 6f2a33df7750f0794b03f7a85aba02a4e631f2a0 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Date: Mon, 12 May 2014 16:20:46 +0200
> Subject: [PATCH] memcg: deprecate memory.force_empty knob
> 
> force_empty has been introduced primarily to drop memory before it gets
> reparented on the group removal. This alone doesn't sound fully
> justified because reparented pages which are not in use can be reclaimed
> also later when there is a memory pressure on the parent level.
> 
> Mark the knob CFTYPE_INSANE which tells the cgroup core that it
> shouldn't create the knob with the experimental sane_behavior. Other
> users will get informed about the deprecation and asked to tell us more.
> But I expect that most users will be simply cgroup remove handlers
> which do that since ever without having any good reason for it.
> 
> If somebody really cares and the reparented pages, which would be dropped
> otherwise, push out more important ones then we should fix the
> reparenting code and put pages to the tail.
> 
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

I'm skeptical the printk will do anything useful, but you marked the
knob insane and that's the most important change.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
