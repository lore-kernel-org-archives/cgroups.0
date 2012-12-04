From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] memcg: disable pages allocation for swap cgroup
 on system booting up
Date: Tue, 4 Dec 2012 13:34:27 +0100
Message-ID: <20121204123427.GK31319@dhcp22.suse.cz>
References: <50BDB5E0.7030906@oracle.com>
 <50BDB5FB.6080707@oracle.com>
 <20121204111721.GB1343@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121204111721.GB1343-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Tue 04-12-12 12:17:21, Michal Hocko wrote:
> On Tue 04-12-12 16:36:11, Jeff Liu wrote:
[...]
> > + * arrive here multiple times.  But we only allocate pages for swap
> > + * cgroup when the first child memcg was created.
> > + */
> > +int swap_cgroup_init(void)
> > +{
> > +	int type;
> > +
> > +	if (!do_swap_account)
> > +		return 0;
> > +
> > +	if (atomic_add_return(1, &swap_cgroup_initialized) != 1)
> > +		return 0;
> > +
> > +	mutex_lock(&swap_cgroup_mutex);
> > +	for (type = 0; type < MAX_SWAPFILES; type++) {
> > +		if (swap_cgroup_alloc_pages(type) < 0) {
> 
> Why do you initialize MAX_SWAPFILES rather than nr_swapfiles?
> 
> Besides that swap_cgroup_alloc_pages is not sufficient because it
> doesn't allocate ctrl->map but it tries to put pages in it.

Sorry, I have missed that you have kept ctrl->map initialization in
swap_cgroup_swapon so this is not an issue.

I think you can do better if swap_cgroup_swapon only initialized
ctrl->length and deferred all the rest to swap_cgroup_alloc_pages (or
its original name as it suits better) including the map allocation which
is currently done in swap_cgroup_swapon.
-- 
Michal Hocko
SUSE Labs
