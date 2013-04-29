From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Mon, 29 Apr 2013 17:27:52 +0200
Message-ID: <20130429152752.GD1172@dhcp22.suse.cz>
References: <20130421124554.GA8473@dhcp22.suse.cz>
 <20130422043939.GB25089@mtj.dyndns.org>
 <20130422151908.GF18286@dhcp22.suse.cz>
 <20130422155703.GC12543@htj.dyndns.org>
 <20130422162012.GI18286@dhcp22.suse.cz>
 <20130422183020.GF12543@htj.dyndns.org>
 <20130423092944.GA8001@dhcp22.suse.cz>
 <20130423170900.GH12543@htj.dyndns.org>
 <20130426115120.GG31157@dhcp22.suse.cz>
 <20130426183741.GA25940@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130426183741.GA25940-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri 26-04-13 11:37:41, Tejun Heo wrote:
> Hey,
> 
> On Fri, Apr 26, 2013 at 01:51:20PM +0200, Michal Hocko wrote:
> > Maybe I should have been more explicit about this but _yes I do agree_
> > that a separate limit would work as well. I just do not want to
> 
> Heh, the point was more about what we shouldn't be doing, but, yeah,
> it's good that we at least agree on something.  :)
> 
> > Anyway, I will think about cons and pros of the new limit. I think we
> > shouldn't block the first 3 patches in the series which keep the current
> > semantic and just change the internals to do the same thing. Do you
> > agree?
> 
> As the merge window is coming right up, if it isn't something super
> urgent, can we please hold it off until after the merge window?  It
> would be really great if we can pin down the semantics of the knob
> before doing anything. 

I think that merging it into 3.10 would be too ambitious but I think
this core code cleanup makes sense for future discussions so I would
like to post it for -mm tree at least. The sooner it will be the better
IMHO.

> Please.  I'll think / study more about it in the coming weeks.
> 
> Thanks.
> 
> -- 
> tejun

-- 
Michal Hocko
SUSE Labs
