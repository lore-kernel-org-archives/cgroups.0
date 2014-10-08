From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 1/3] mm: memcontrol: take a css reference for each
 charged page
Date: Wed, 8 Oct 2014 15:29:27 +0200
Message-ID: <20141008132927.GC4592@dhcp22.suse.cz>
References: <1411243235-24680-1-git-send-email-hannes@cmpxchg.org>
 <1411243235-24680-2-git-send-email-hannes@cmpxchg.org>
 <20141008132754.GB4592@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141008132754.GB4592@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov@parallels.com>, Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 08-10-14 15:27:54, Michal Hocko wrote:
> On Sat 20-09-14 16:00:33, Johannes Weiner wrote:
[...]
> > @@ -2803,8 +2808,10 @@ static void memcg_uncharge_kmem(struct mem_cgroup *memcg,
> >  		page_counter_uncharge(&memcg->memsw, nr_pages);
> >  
> 
> Wouldn't a single out_css_put be more readable? I was quite confused
> when I start reading the patch before I saw the next hunk.

Ohh, this will go away in the next patch. Ignore this.

> 
> >  	/* Not down to 0 */
> > -	if (page_counter_uncharge(&memcg->kmem, nr_pages))
> 		goto out_css_put;
> 
> > +	if (page_counter_uncharge(&memcg->kmem, nr_pages)) {
> > +		css_put_many(&memcg->css, nr_pages);
> >  		return;
> > +	}
> >  
> >  	/*
> >  	 * Releases a reference taken in kmem_cgroup_css_offline in case
> > @@ -2816,6 +2823,8 @@ static void memcg_uncharge_kmem(struct mem_cgroup *memcg,
> >  	 */
> >  	if (memcg_kmem_test_and_clear_dead(memcg))
> >  		css_put(&memcg->css);
> > +
> 
> out_css_put:
> > +	css_put_many(&memcg->css, nr_pages);
> >  }
> >  
> >  /*
> -- 
> Michal Hocko
> SUSE Labs

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
