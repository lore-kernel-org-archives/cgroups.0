From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
Date: Wed, 15 Aug 2012 14:55:55 +0200
Message-ID: <20120815125555.GG23985@dhcp22.suse.cz>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
 <1344517279-30646-5-git-send-email-glommer@parallels.com>
 <20120814162144.GC6905@dhcp22.suse.cz>
 <502B6D03.1080804@parallels.com>
 <1345029143.2976.41.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1345029143.2976.41.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Wed 15-08-12 12:12:23, James Bottomley wrote:
> On Wed, 2012-08-15 at 13:33 +0400, Glauber Costa wrote:
> > > This can
> > > be quite confusing.  I am still not sure whether we should mix the two
> > > things together. If somebody wants to limit the kernel memory he has to
> > > touch the other limit anyway.  Do you have a strong reason to mix the
> > > user and kernel counters?
> > 
> > This is funny, because the first opposition I found to this work was
> > "Why would anyone want to limit it separately?" =p
> > 
> > It seems that a quite common use case is to have a container with a
> > unified view of "memory" that it can use the way he likes, be it with
> > kernel memory, or user memory. I believe those people would be happy to
> > just silently account kernel memory to user memory, or at the most have
> > a switch to enable it.
> > 
> > What gets clear from this back and forth, is that there are people
> > interested in both use cases.
> 
> Haven't we already had this discussion during the Prague get together?
> We discussed the use cases and finally agreed to separate accounting for
> k and then k+u mem because that satisfies both the Google and Parallels
> cases.  No-one was overjoyed by k and k+u but no-one had a better
> suggestion ... is there a better way of doing this that everyone can
> agree to?
> We do need to get this nailed down because it's the foundation of the
> patch series.

There is a slot in MM/memcg minisum at KS so we have a slot to discuss
this.

> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
