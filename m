From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Wed, 5 Jun 2013 15:27:09 -0700
Message-ID: <20130605222709.GM10693@mtj.dyndns.org>
References: <20130604212808.GB13231@dhcp22.suse.cz>
 <20130604215535.GM14916@htj.dyndns.org>
 <20130605073023.GB15997@dhcp22.suse.cz>
 <20130605082023.GG7303@mtj.dyndns.org>
 <20130605143949.GQ15576@cmpxchg.org>
 <20130605172212.GA10693@mtj.dyndns.org>
 <20130605194552.GI15721@cmpxchg.org>
 <20130605200612.GH10693@mtj.dyndns.org>
 <20130605211704.GJ15721@cmpxchg.org>
 <20130605222021.GL10693@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9YiuSm6lUux1MsWrpM9wsnhmHTS5u5SQDx1k8R2PZIw=;
        b=vx6MyOL/VHmQzFfBpKJf+3Eb5QJcD6nwt4g8fhXI4OyfBW0A0rs0CJs2bTgepERgCt
         nD8yIUiutDSq3LI52l96KgNSEJDMrSjljn62kH9Xe/M+2hci0Ubsmq2R7H8VBeP3yd+e
         xfrD+3LxalckpYKqK7eP0z01/2dD28BfhV76f2GUMaQgn1Szx3Y/5jSlL02VRLWhaS81
         rVuzzNJ3x6wc4h51p7VmNPIUBCNJi1trSu/nIqC7VDrjAUQXmmL7bH0kZwjs8C2ioTLl
         vclRl0eUoi7JwxR0rQoLzuvazunWafgcykmE6zXhawnmBs67kFm6VfBMfj6Yx7YLEm+9
         boHg==
Content-Disposition: inline
In-Reply-To: <20130605222021.GL10693-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Jun 05, 2013 at 03:20:21PM -0700, Tejun Heo wrote:
> Yo,
> 
> On Wed, Jun 05, 2013 at 05:17:04PM -0400, Johannes Weiner wrote:
> > That could be an advantage, yes.  But keep in mind that every
> > destruction has to perform this invalidation operation against the
> > global root_mem_cgroup's nr_node * nr_zone * nr_priority_levels
> > iterators, so you can't muck around forever, while possibly holding a
> > lock at this level.  It's not a hot path, but you don't want to turn
> > it into one, either.
> 
> nr_node tends to be pretty low in most cases, so it shouldn't be a
> problem there but yeah with high enough nodes and high enough rate of

Also, do we need to hold a lock?  It doesn't have to be completely
strict, so we might as well get away with something like,

	for_each_cached_pos() {
		if (hint == me) {
			/* simple clearing implementation, we prolly wanna push it forward */
			cached = xchg(hint, NULL);
			if (cached)
				css_put(cached);
		}
	}

It still scans the memory but wouldn't create any contention.

Thanks.

-- 
tejun
