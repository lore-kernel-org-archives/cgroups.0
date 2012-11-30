From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/4] cgroup: warn about broken hierarchies only after
 css_online
Date: Fri, 30 Nov 2012 16:49:12 +0100
Message-ID: <20121130154912.GM29317@dhcp22.suse.cz>
References: <1354282286-32278-1-git-send-email-glommer@parallels.com>
 <1354282286-32278-2-git-send-email-glommer@parallels.com>
 <20121130151158.GB3873@htj.dyndns.org>
 <50B8CD32.4080807@parallels.com>
 <20121130154504.GD3873@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121130154504.GD3873-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Fri 30-11-12 07:45:04, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Fri, Nov 30, 2012 at 07:13:54PM +0400, Glauber Costa wrote:
> > > Applied to cgroup/for-3.8.  Thanks!
> > > 
> > 
> > We just need to be careful because when we merge it with morton's, more
> > bits will need converting.
> 
> This one is in cgrou proper and I think it should be safe, right?
> Other ones will be difficult.  Not sure how to handle them ATM.  An
> easy way out would be deferring to the next merge window as it's so
> close anyway.  Michal?

yes, I think so as well. I guess the window will open soon.
-- 
Michal Hocko
SUSE Labs
