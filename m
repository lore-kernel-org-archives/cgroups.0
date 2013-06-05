From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Wed, 5 Jun 2013 10:22:12 -0700
Message-ID: <20130605172212.GA10693@mtj.dyndns.org>
References: <1370306679-13129-1-git-send-email-tj@kernel.org>
 <1370306679-13129-4-git-send-email-tj@kernel.org>
 <20130604131843.GF31242@dhcp22.suse.cz>
 <20130604205025.GG14916@htj.dyndns.org>
 <20130604212808.GB13231@dhcp22.suse.cz>
 <20130604215535.GM14916@htj.dyndns.org>
 <20130605073023.GB15997@dhcp22.suse.cz>
 <20130605082023.GG7303@mtj.dyndns.org>
 <20130605143949.GQ15576@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+Cm/W78UyBOsEyRlS2A745WGBbiYX4PX6d9+KCuw1P8=;
        b=XsFVNwLp09F7cSlw/Y0BtCfNOv4PljdA/+jRMM0+4sImGgEx+c9IWtwlhJ/sebaE0j
         5lC4lP5TOw7/CKu2XQQ2+8WI2s6VXUfoFpGoF8x7gCL8CWpVu8dWvIwwz/o9vcicb7g5
         21qos2M9YFGdN8+EheHjoPf+2eWBv0+uUZUi2oiZ4+MMdoqtSIabHN9srqoH3GbgSeTd
         HxvGxSBtvRUiFXlUG9vZSeriL8R++4HTr/pEyZBXcVE8kOp0PZRMiKnAc6NPs62vRXh/
         eaEL4rqho+rCVmS+HnIL6UBGBjLEDGWMwhX5USPf5FhPaukJtyZhk2qPbt8adpoOvTt5
         RUug==
Content-Disposition: inline
In-Reply-To: <20130605143949.GQ15576-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hey, Johannes.

On Wed, Jun 05, 2013 at 10:39:49AM -0400, Johannes Weiner wrote:
> 5k cgroups * say 10 priority levels * 1k struct mem_cgroup may pin 51M
> of dead struct mem_cgroup, plus whatever else the css pins.

Yeah, it seems like it can grow quite a bit.

> > I'll get to the barrier thread but really complex barrier dancing like
> > that is only justifiable in extremely hot paths a lot of people pay
> > attention to.  It doesn't belong inside memcg proper.  If the cached
> > amount is an actual concern, let's please implement a simple clean up
> > thing.  All we need is a single delayed_work which scans the tree
> > periodically.
> > 
> > Johannes, what do you think?
> 
> While I see your concerns about complexity (and this certainly is not
> the most straight-forward code), I really can't get too excited about
> asynchroneous garbage collection, even worse when it's time-based. It
> would probably start out with less code but two releases later we
> would have added all this stuff that's required to get the interaction
> right and fix unpredictable reclaim disruption that hits when the
> reaper coincides just right with heavy reclaim once a week etc.  I
> just don't think that asynchroneous models are simpler than state
> machines.  Harder to reason about, harder to debug.

Agreed, but we can do the cleanup from ->css_offline() as Michal
suggested.  Naively implemented, this will lose the nice property of
keeping the iteration point even when the cursor cgroup is removed,
which can be an issue if we're actually worrying about cases with 5k
cgroups continuously being created and destroyed.  Maybe we can make
it point to the next cgroup to visit rather than the last visited one
and update it from ->css_offline().

> Now, there are separate things that add complexity to our current
> code: the weak pointers, the lockless iterator, and the fact that all
> of it is jam-packed into one monolithic iterator function.  I can see
> why you are not happy.  But that does not mean we have to get rid of
> everything wholesale.
> 
> You hate the barriers, so let's add a lock to access the iterator.
> That path is not too hot in most cases.
> 
> On the other hand, the weak pointer is not too esoteric of a pattern
> and we can neatly abstract it into two functions: one that takes an
> iterator and returns a verified css reference or NULL, and one to
> invalidate pointers when called from the memcg destruction code.
>
> These two things should greatly simplify mem_cgroup_iter() while not
> completely abandoning all our optimizations.
> 
> What do you think?

I really think the weak pointers should go especially as we can
achieve about the same thing with normal RCU dereference.  Also, I'm a
bit confused about what you're suggesting.  If we have invalidation
from offline, why do we need weak pointers?

Thanks.

-- 
tejun
