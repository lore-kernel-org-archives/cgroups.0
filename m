From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/2] mm: memcontrol: basic memory statistics in cgroup2
 memory controller
Date: Thu, 14 Jan 2016 15:25:21 -0500
Message-ID: <20160114202521.GB20218@cmpxchg.org>
References: <1452722469-24704-1-git-send-email-hannes@cmpxchg.org>
 <1452722469-24704-2-git-send-email-hannes@cmpxchg.org>
 <20160113144930.b20ed63f1c6a28730f66eccd@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160113144930.b20ed63f1c6a28730f66eccd-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Jan 13, 2016 at 02:49:30PM -0800, Andrew Morton wrote:
> > @@ -5095,6 +5107,46 @@ static int memory_events_show(struct seq_file *m, void *v)
> >  	return 0;
> >  }
> >  
> > +static int memory_stat_show(struct seq_file *m, void *v)
> > +{
> > +	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
> > +	int i;
> > +
> > +	/* Memory consumer totals */
> > +
> > +	seq_printf(m, "anon %lu\n",
> > +		   tree_stat(memcg, MEM_CGROUP_STAT_RSS) * PAGE_SIZE);
> 
> Is there any reason why this won't overflow a longword on 32-bit?

It will, I don't know what I was thinking there. Fixed in the update.
