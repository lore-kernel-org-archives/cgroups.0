From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] jump_label: make static_key_enabled() work on
 static_key_true/false types too
Date: Thu, 17 Sep 2015 17:37:43 +0200
Message-ID: <20150917153743.GN3816@twins.programming.kicks-ass.net>
References: <1442368285-16306-1-git-send-email-tj@kernel.org>
 <1442368285-16306-2-git-send-email-tj@kernel.org>
 <20150917085957.GI3816@twins.programming.kicks-ass.net>
 <20150917152752.GD7205@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150917152752.GD7205@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Andrew Morton <akpm@linux-foundation.org>

On Thu, Sep 17, 2015 at 11:27:52AM -0400, Tejun Heo wrote:
> On Thu, Sep 17, 2015 at 10:59:57AM +0200, Peter Zijlstra wrote:
> > On Tue, Sep 15, 2015 at 09:51:22PM -0400, Tejun Heo wrote:
> > > static_key_enabled() can be used on struct static_key but not on its
> > > wrapper types static_key_true and static_key_false.  The function is
> > > useful for debugging and management of static keys.  Update it so that
> > > it can be used for the wrapper types too.
> > > 
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > ---
> > > Hello,
> > > 
> > > If this patch is acceptable, please let me know how it should be
> > > routed.
> > > 
> > 
> > Yeah, no problem with this, I'm assuming there's dependencies in the
> > patches you didn't send me? 
> 
> Yeap, later patches add static_keys for testing whether a controller
> is enabled and whether it's on the new or old hierarchy and management
> path in cgroup core needs to index the keys and test them.

Ok, take it through you tree then, its a small enough patch.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
