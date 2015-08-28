From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: punt high overage reclaim to
 return-to-userland path
Date: Fri, 28 Aug 2015 23:45:54 +0300
Message-ID: <20150828204554.GM9610@esperanza>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-4-git-send-email-tj@kernel.org>
 <20150828171322.GC21463@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150828171322.GC21463-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Aug 28, 2015 at 07:13:22PM +0200, Michal Hocko wrote:
...
> > * If the allocation doesn't have __GFP_WAIT, direct reclaim is
> >   skipped.  If a process performs only speculative allocations, it can
> >   blow way past the high limit.  This is actually easily reproducible
> >   by simply doing "find /".  VFS tries speculative !__GFP_WAIT
> >   allocations first, so as long as there's memory which can be
> >   consumed without blocking, it can keep allocating memory regardless
> >   of the high limit.
> 
> It is a bit confusing that you are talking about direct reclaim but in
> fact mean high limit reclaim. But yeah, you are right there is no
> protection against GFP_NOWAIT allocations there.

Actually, memory.high by itself *is* the protection against GFP_NOWAIT
allocations, similarly to zone watermarks. W/o it we would have no other
choice but fail a GFP_NOWAIT allocation on hitting memory.max. One
should just set it so that

  memory.max - memory.high > [max sum size of !__GFP_WAIT allocations
                              that can normally occur in a row]

That being said, currently I don't see any point in making memory.high
!__GFP_WAIT-safe.

Thanks,
Vladimir
