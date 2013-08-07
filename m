From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/3] memcg: Limit the number of events registered on
 oom_control
Date: Wed, 7 Aug 2013 15:57:34 +0200
Message-ID: <20130807135734.GK8184@dhcp22.suse.cz>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <1375874907-22013-2-git-send-email-mhocko@suse.cz>
 <20130807130836.GB27006@htj.dyndns.org>
 <20130807133746.GI8184@dhcp22.suse.cz>
 <20130807134741.GF27006@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130807134741.GF27006-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On Wed 07-08-13 09:47:41, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 07, 2013 at 03:37:46PM +0200, Michal Hocko wrote:
> > > It isn't different from listening from epoll, for example.
> > 
> > epoll limits the number of watchers, no?
> 
> Not that I know of.  It'll be limited by max open fds but I don't
> think there are other limits. 

max_user_watches seems to be a limit (4% of lowmem in maximum).

> Why would there be?

Because userspace should hog kernel resources without any limit.

> > > If there needs to be kernel memory limit, shouldn't that be handled by
> > > kmemcg?
> > 
> > kmemcg would surely help but turning it on just because of potential
> > abuse of the event registration API sounds like an overkill.
> > 
> > I think having a cap for user trigable kernel resources is a good thing
> > in general.
> 
> I don't know.  It's just very arbitrary because listening to events
> itself isn't (and shouldn't) be something which consumes resource
> which isn't attributed to the listener and this artificially creates a
> global resource.  The problem with memory usage event is breaching
> that rule with shared kmalloc() so putting well-defined limit on it is
> fine but the latter two create additional artificial restrictions
> which are both unnecessary and unconventional.  No?

Hmm, OK so you think that the fd limit is sufficient already?
-- 
Michal Hocko
SUSE Labs
