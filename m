From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm/page_owner: Dump memcg information
Date: Wed, 2 Feb 2022 18:56:16 +0100
Message-ID: <YfrFwCur8XR1AIdK@dhcp22.suse.cz>
References: <YfgT/9tEREQNiiAN@cmpxchg.org>
 <YfgnUZQBRkqhrEIb@carbon.dhcp.thefacebook.com>
 <Yfgpknwr1tMnPkqh@dhcp22.suse.cz>
 <12686956-612d-d89b-5641-470d5e913090@redhat.com>
 <YfkQJ4QhfY0dICB9@dhcp22.suse.cz>
 <268a8bdf-4c70-b967-f34c-2293b54186f0@redhat.com>
 <YfpHbtffFi2x1L4p@dhcp22.suse.cz>
 <YfqpSPLC+LAdqbJX@carbon.dhcp.thefacebook.com>
 <YfqzbwAPKpshXSLK@dhcp22.suse.cz>
 <YfrEpOGObnc0mYAW@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643824577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eUaCCmIrt4YXjEHnPOouYBMineoqEjQxWMOeykndMd0=;
        b=LVC7QKF9m3y87F2lRODe1hv/0VpW6yBSKfqzNrbC+ql2jmd+Gdx7rF40xvljUGtdOYzaik
        dFyHjYuA394ZAR40l98/+zytDpSVZV7EnNLBgnsAoCmYkfj+UeOcwQQGudFdWr0CMa1WaP
        rxWjwNZtjIvt35GHr7ossjaNISAv4oU=
Content-Disposition: inline
In-Reply-To: <YfrEpOGObnc0mYAW-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed 02-02-22 09:51:32, Roman Gushchin wrote:
> On Wed, Feb 02, 2022 at 05:38:07PM +0100, Michal Hocko wrote:
> > On Wed 02-02-22 07:54:48, Roman Gushchin wrote:
> > > On Wed, Feb 02, 2022 at 09:57:18AM +0100, Michal Hocko wrote:
> > > > On Tue 01-02-22 11:41:19, Waiman Long wrote:
> > > > > 
> > > > > On 2/1/22 05:49, Michal Hocko wrote:
> > > > [...]
> > > > > > Could you be more specific? Offlined memcgs are still part of the
> > > > > > hierarchy IIRC. So it shouldn't be much more than iterating the whole
> > > > > > cgroup tree and collect interesting data about dead cgroups.
> > > > > 
> > > > > What I mean is that without piggybacking on top of page_owner, we will to
> > > > > add a lot more code to collect and display those information which may have
> > > > > some overhead of its own.
> > > > 
> > > > Yes, there is nothing like a free lunch. Page owner is certainly a tool
> > > > that can be used. My main concern is that this tool doesn't really
> > > > scale on large machines with a lots of memory. It will provide a very
> > > > detailed information but I am not sure this is particularly helpful to
> > > > most admins (why should people process tons of allocation backtraces in
> > > > the first place). Wouldn't it be sufficient to have per dead memcg stats
> > > > to see where the memory sits?
> > > > 
> > > > Accumulated offline memcgs is something that bothers more people and I
> > > > am really wondering whether we can do more for those people to evaluate
> > > > the current state.
> > > 
> > > Cgroup v2 has corresponding counters for years. Or do you mean something different?
> > 
> > Do we have anything more specific than nr_dying_descendants?
> 
> No, just nr_dying_descendants.
> 
> > I was thinking about an interface which would provide paths and stats for dead
> > memcgs. But I have to confess I haven't really spent much time thinking
> > about how much work that would be. I am by no means against adding memcg
> > information to the page owner. I just think there must be a better way
> > to present resource consumption by dead memcgs.
> 
> I'd go with a drgn script. I wrote a bunch of them some times ago and
> can probably revive them and post here (will take few days).

That would be really awsome!

Thanks!

-- 
Michal Hocko
SUSE Labs
