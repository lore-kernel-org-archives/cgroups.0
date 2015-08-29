From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: punt high overage reclaim to
 return-to-userland path
Date: Sat, 29 Aug 2015 10:59:05 +0300
Message-ID: <20150829075905.GO9610@esperanza>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-4-git-send-email-tj@kernel.org>
 <20150828163611.GI9610@esperanza>
 <20150828164819.GL26785@mtj.duckdns.org>
 <20150828203231.GL9610@esperanza>
 <20150828204432.GA11089@htj.dyndns.org>
 <20150828220632.GF11089@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150828220632.GF11089-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Aug 28, 2015 at 06:06:32PM -0400, Tejun Heo wrote:
> On Fri, Aug 28, 2015 at 04:44:32PM -0400, Tejun Heo wrote:
> > Ah, cool, so it was a bug from slub.  Punting to return path still has
> > some niceties but if we can't consistently get rid of stack
> > consumption it's not that attractive.  Let's revisit it later together
> > with hard limit reclaim.
> 
> So, I can't check right now but I'm pretty sure I was using SLAB on my
> test config, so this issue may exist there too.

Yeah, SLAB is broken too. It was accidentally broken by commit
4167e9b2cf10 ("mm: remove GFP_THISNODE"), which among other things made
SLAB filter out __GFP_WAIT from gfp flags when probing a NUMA node. I'll
take a look what we can do with that.

Thanks,
Vladimir
