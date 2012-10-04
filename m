From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 1/2] mm: memcontrol: handle potential crash when rmap
 races with task exit
Date: Thu, 4 Oct 2012 16:19:08 -0400
Message-ID: <20121004201908.GA2625@cmpxchg.org>
References: <1349374157-20604-1-git-send-email-hannes@cmpxchg.org>
 <1349374157-20604-2-git-send-email-hannes@cmpxchg.org>
 <20121004184958.GG27536@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121004184958.GG27536-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Oct 04, 2012 at 08:49:58PM +0200, Michal Hocko wrote:
> On Thu 04-10-12 14:09:16, Johannes Weiner wrote:
> > page_referenced() counts only references of mm's that are associated
> > with the memcg hierarchy that is being reclaimed.  However, if it
> > races with the owner of the mm exiting, mm->owner may be NULL.  Don't
> > crash, just ignore the reference.
> 
> This seems to be fixed by Hugh's patch 3a981f48 "memcg: fix use_hierarchy
> css_is_ancestor oops regression" which seems to be merged already.

And look who acked the patch.  I'll show myself out...
