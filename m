From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 2/2] memcg: punt high overage reclaim to
 return-to-userland path
Date: Tue, 15 Sep 2015 18:33:27 +0200
Message-ID: <20150915163327.GA13232@cmpxchg.org>
References: <20150913185940.GA25369@htj.duckdns.org>
 <20150913190008.GB25369@htj.duckdns.org>
 <20150915074724.GE2858@cmpxchg.org>
 <20150915155355.GH2905@mtj.duckdns.org>
 <20150915161218.GA12032@cmpxchg.org>
 <20150915162253.GI2905@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150915162253.GI2905-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Sep 15, 2015 at 12:22:53PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 15, 2015 at 06:12:18PM +0200, Johannes Weiner wrote:
> > But they have been failing indefinitely forever once you hit the hard
> > limit in the past. There was never an async reclaim provision there.
> >
> > I can definitely see that the unconstrained high limit breaching needs
> > to be fixed one way or another, I just don't quite understand why you
> > chose to go for new semantics. Is there a new or a specific usecase
> > you had in mind when you chose deferred reclaim over simply failing?
> 
> Hmmm... so if we just fail, it breaks the assumptions that slab/slub
> is making and while they might not fail outright would behave in an
> undesirable way.  It's just that we didn't notice that before with
> limit_on_bytes and at least on the v2 interface the distinction
> between high and max makes the problem easy to deal with from high
> enforcement.

Gotcha, it makes sense to address this then. Thanks for clarifying.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
