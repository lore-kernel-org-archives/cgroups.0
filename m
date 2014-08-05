From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: avoid charge statistics churn during
 page migration
Date: Tue, 5 Aug 2014 15:34:28 +0200
Message-ID: <20140805133428.GH15908@dhcp22.suse.cz>
References: <1407184469-20741-1-git-send-email-hannes@cmpxchg.org>
 <20140805122434.GD15908@dhcp22.suse.cz>
 <20140805131223.GA14734@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140805131223.GA14734-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 05-08-14 09:12:23, Johannes Weiner wrote:
> On Tue, Aug 05, 2014 at 02:24:34PM +0200, Michal Hocko wrote:
> > On Mon 04-08-14 16:34:29, Johannes Weiner wrote:
> > > Charge migration currently disables IRQs twice to update the charge
> > > statistics for the old page and then again for the new page.
> > > 
> > > But migration is a seemless transition of a charge from one physical
> > > page to another one of the same size, so this should be a non-event
> > > from an accounting point of view.  Leave the statistics alone.
> > 
> > Moving stats to mem_cgroup_commit_charge sounds logical to me but does
> > this work properly even for the fuse replace page cache case when old
> > and new pages can already live in different memcgs?
> 
> We don't migrate if the new page is already charged.

Right you are.

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

-- 
Michal Hocko
SUSE Labs
