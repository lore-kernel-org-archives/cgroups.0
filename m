From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: punt high overage reclaim to
 return-to-userland path
Date: Sat, 29 Aug 2015 00:07:04 +0300
Message-ID: <20150828210704.GN9610@esperanza>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-4-git-send-email-tj@kernel.org>
 <20150828171322.GC21463@dhcp22.suse.cz>
 <20150828204554.GM9610@esperanza>
 <20150828205301.GB11089@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150828205301.GB11089-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Aug 28, 2015 at 04:53:01PM -0400, Tejun Heo wrote:
> On Fri, Aug 28, 2015 at 11:45:54PM +0300, Vladimir Davydov wrote:
> > Actually, memory.high by itself *is* the protection against GFP_NOWAIT
> > allocations, similarly to zone watermarks. W/o it we would have no other
> > choice but fail a GFP_NOWAIT allocation on hitting memory.max. One
> > should just set it so that
> > 
> >   memory.max - memory.high > [max sum size of !__GFP_WAIT allocations
> >                               that can normally occur in a row]
> 
> While this would be true in many cases, I don't think this is the
> intention of the two knobs and the space between high and max can be
> filled up by anything which can't be reclaimed - e.g. too many dirty /
> writeback pages on a slow device or memlocked pages.  If it were
> really the buffer for GFP_NOWAIT, there's no reason to even make it a
> separate knob and we *may* change how over-high reclaim behaves in the
> future, so let's please not dig ourselves into something too specific.

Yep, come to think of it, you're right. One might want to use the
memory.high knob as the protection, because currently it is the only way
to protect kmemcg against GFP_NOWAIT failures, but it looks more like
abusing it :-/

We should probably think about introducing some kind of watermarks that
would trigger memcg reclaim, asynchronous or direct, on exceeding
them.

Thanks,
Vladimir
