From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 2/2] memcg: punt high overage reclaim to
 return-to-userland path
Date: Tue, 15 Sep 2015 18:12:18 +0200
Message-ID: <20150915161218.GA12032@cmpxchg.org>
References: <20150913185940.GA25369@htj.duckdns.org>
 <20150913190008.GB25369@htj.duckdns.org>
 <20150915074724.GE2858@cmpxchg.org>
 <20150915155355.GH2905@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150915155355.GH2905@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, mhocko@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, vdavydov@parallels.com, kernel-team@fb.com

On Tue, Sep 15, 2015 at 11:53:55AM -0400, Tejun Heo wrote:
> Hello, Johannes.
> 
> On Tue, Sep 15, 2015 at 09:47:24AM +0200, Johannes Weiner wrote:
> > Why can't we simply fail NOWAIT allocations when the high limit is
> > breached? We do the same for the max limit.
> 
> Because that can lead to continued systematic failures of NOWAIT
> allocations.  For that to work, we'll have to add async reclaimaing.
> 
> > As I see it, NOWAIT allocations are speculative attempts on available
> > memory. We should be able to just fail them and have somebody that is
> > allowed to reclaim try again, just like with the max limit.
> 
> Yes, but the assumption is that even back-to-back NOWAIT allocations
> won't continue to fail indefinitely.

But they have been failing indefinitely forever once you hit the hard
limit in the past. There was never an async reclaim provision there.

I can definitely see that the unconstrained high limit breaching needs
to be fixed one way or another, I just don't quite understand why you
chose to go for new semantics. Is there a new or a specific usecase
you had in mind when you chose deferred reclaim over simply failing?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
