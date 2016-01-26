From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: drop superfluous entry in the per-memcg
 stats array
Date: Tue, 26 Jan 2016 16:43:34 -0500
Message-ID: <20160126214334.GA4016@cmpxchg.org>
References: <1453841729-29072-1-git-send-email-hannes@cmpxchg.org>
 <20160126133024.07f372dbf8935e03a3035269@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160126133024.07f372dbf8935e03a3035269-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Jan 26, 2016 at 01:30:24PM -0800, Andrew Morton wrote:
> On Tue, 26 Jan 2016 15:55:29 -0500 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> 
> > MEM_CGROUP_STAT_NSTATS is just a delimiter for cgroup1 statistics, not
> > an actual array entry. Reuse it for the first cgroup2 stat entry, like
> > in the event array.
> > 
> > ...
> >
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -51,7 +51,7 @@ enum mem_cgroup_stat_index {
> >  	MEM_CGROUP_STAT_SWAP,		/* # of pages, swapped out */
> >  	MEM_CGROUP_STAT_NSTATS,
> >  	/* default hierarchy stats */
> > -	MEMCG_SOCK,
> > +	MEMCG_SOCK = MEM_CGROUP_STAT_NSTATS,
> >  	MEMCG_NR_STAT,
> >  };
> 
> The code looks a bit odd.  How come mem_cgroup_stat_names[] ends with
> "swap"?  Should MEMCG_SOCK be in there at all?

It's cgroup1 vs. cgroup2 statistics. I'm using the same array in order
to use the original statistics infrastructure. It's a little weird, it
will be much cleaner once everything is converted to percpu_counter.

> And the naming is a bit sad.  "MEM_CGROUP_STAT_FILE_MAPPED" maps to
> "mapped_file", not "file_mapped".

MEM_CGROUP_STAT_FILE_MAPPED is named after NR_FILE_MAPPED because
they're both accounted from the same sites. Who knows why the
user-visible stat was then called mapped_file... :/

And in cgroup2 it's called file_mapped! At least there it'll be
consistent.
