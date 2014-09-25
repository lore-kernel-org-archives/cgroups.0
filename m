From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch v2] mm: memcontrol: do not iterate uninitialized memcgs
Date: Thu, 25 Sep 2014 09:54:50 -0400
Message-ID: <20140925135450.GA1822@cmpxchg.org>
References: <1411612278-4707-1-git-send-email-hannes@cmpxchg.org>
 <20140925024054.GA4888@cmpxchg.org>
 <20140925114339.GD12090@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140925114339.GD12090-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 25, 2014 at 01:43:39PM +0200, Michal Hocko wrote:
> On Wed 24-09-14 22:40:55, Johannes Weiner wrote:
> > Argh, buggy css_put() against the root.  Hand grenades, everywhere.
> > Update:
> > 
> > ---
> > From 9b0b4d72d71cd8acd7aaa58d2006c751decc8739 Mon Sep 17 00:00:00 2001
> > From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Date: Wed, 24 Sep 2014 22:00:20 -0400
> > Subject: [patch] mm: memcontrol: do not iterate uninitialized memcgs
> > 
> > The cgroup iterators yield css objects that have not yet gone through
> > css_online(), but they are not complete memcgs at this point and so
> > the memcg iterators should not return them.  d8ad30559715 ("mm/memcg:
> > iteration skip memcgs not yet fully initialized") set out to implement
> > exactly this, but it uses CSS_ONLINE, a cgroup-internal flag that does
> > not meet the ordering requirements for memcg, and so we still may see
> > partially initialized memcgs from the iterators.
> 
> I do not see how would this happen. CSS_ONLINE is set after css_online
> callback returns and mem_cgroup_css_online ends the core initialization
> with mutex_unlock which should provide sufficient memory ordering
> requirements

But the iterators do not use the mutex?  We are missing the matching
acquire for the proper ordering.
