From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v4 0/6] replace cgroup_lock with memcg specific locking
Date: Fri, 25 Jan 2013 16:03:28 -0800
Message-ID: <20130125160328.7a73849f.akpm@linux-foundation.org>
References: <1358862461-18046-1-git-send-email-glommer@parallels.com>
	<510258D0.6060407@parallels.com>
	<20130125101854.GC8876@dhcp22.suse.cz>
	<51025E2B.4080105@parallels.com>
	<20130125173701.GH3081@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130125173701.GH3081-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Lord Glauber Costa of Sealand <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On Fri, 25 Jan 2013 09:37:01 -0800
Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> Hey,
> 
> On Fri, Jan 25, 2013 at 02:27:55PM +0400, Lord Glauber Costa of Sealand wrote:
> > > I would vote to -mm. Or is there any specific reason to have it in
> > > cgroup tree? It doesn't touch any cgroup core parts, does it?
> > > 
> > Copying Andrew (retroactively sorry you weren't directly CCd on this one
> > as well).
> > 
> > I depend on css_online and the cgroup generic iterator. If they are
> > already present @ -mm, then fine.
> > (looking now, they seem to be...)
> 
> Yeah, they're all in cgroup/for-next so should be available in -mm, so
> I think -mm probably is the better tree to route these.
> 

yep, grabbed, thanks.

The good changelogging and code commenting really help with review -
thanks for doing that.  It's a shame so few people are interested in
reviewing them!  (Hint).

