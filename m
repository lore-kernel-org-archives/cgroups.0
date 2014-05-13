From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: deprecate memory.force_empty knob
Date: Tue, 13 May 2014 17:09:53 +0200
Message-ID: <20140513150953.GC25996@dhcp22.suse.cz>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-3-git-send-email-tj@kernel.org>
 <20140512145324.GE9564@dhcp22.suse.cz>
 <20140512145803.GF9564@dhcp22.suse.cz>
 <20140512150014.GB1421@htj.dyndns.org>
 <20140512152015.GH9564@dhcp22.suse.cz>
 <20140512152507.GD1421@htj.dyndns.org>
 <20140512153458.GJ9564@dhcp22.suse.cz>
 <20140513131655.GC18849@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140513131655.GC18849-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 13-05-14 09:16:56, Johannes Weiner wrote:
> On Mon, May 12, 2014 at 05:34:58PM +0200, Michal Hocko wrote:
[...]
> > >From 6f2a33df7750f0794b03f7a85aba02a4e631f2a0 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > Date: Mon, 12 May 2014 16:20:46 +0200
> > Subject: [PATCH] memcg: deprecate memory.force_empty knob
> > 
> > force_empty has been introduced primarily to drop memory before it gets
> > reparented on the group removal. This alone doesn't sound fully
> > justified because reparented pages which are not in use can be reclaimed
> > also later when there is a memory pressure on the parent level.
> > 
> > Mark the knob CFTYPE_INSANE which tells the cgroup core that it
> > shouldn't create the knob with the experimental sane_behavior. Other
> > users will get informed about the deprecation and asked to tell us more.
> > But I expect that most users will be simply cgroup remove handlers
> > which do that since ever without having any good reason for it.
> > 
> > If somebody really cares and the reparented pages, which would be dropped
> > otherwise, push out more important ones then we should fix the
> > reparenting code and put pages to the tail.
> > 
> > Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> 
> I'm skeptical the printk will do anything useful, but you marked the
> knob insane and that's the most important change.

Well, I suspect that most users will try the new semantic at the latest
possible moment and then it can come up as a surprise. I would prefer to
catch those as soon as possible. I am even thinking to push this to SLES
to catch possible enterprise users.

> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thanks. OK, I will post it to Andrew. I guess he will want to have some
rate-limiting or print-once semantic...
-- 
Michal Hocko
SUSE Labs
