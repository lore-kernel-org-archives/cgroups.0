From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 04/12] mm: memcontrol: retry reclaim for oom-disabled and
 __GFP_NOFAIL charges
Date: Tue, 17 Jun 2014 11:45:27 -0400
Message-ID: <20140617154527.GC7331@cmpxchg.org>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
 <1402948472-8175-5-git-send-email-hannes@cmpxchg.org>
 <20140617135344.GC19886@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=iVfrs/mRhV8U3bQ+/WnFvoTe8b+CqNwMjnhZ9hukmZY=;
	b=dZa9xr1uVjHaTyHmDETF6BpDP9qkIPyO5Wy0RlsLYUF+s3rlLWmQG4Mvw9LbTTLADwG0xNE2DfxXUwVjHIAwDe5vi081DerNtTSmZOjQ3zTxYoG7S3QHvTDDWqfMsA7HT2yi1rt076IBb6WUjIdnv3kqQrWuQpm6OuYIRa/5A1Q=;
Content-Disposition: inline
In-Reply-To: <20140617135344.GC19886-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 17, 2014 at 03:53:44PM +0200, Michal Hocko wrote:
> On Mon 16-06-14 15:54:24, Johannes Weiner wrote:
> > There is no reason why oom-disabled and __GFP_NOFAIL charges should
> > try to reclaim only once when every other charge tries several times
> > before giving up.  Make them all retry the same number of times.
> 
> OK, this makes sense for oom-disabled and __GFP_NOFAIL but does it make
> sense to do additional reclaim for tasks with fatal_signal_pending?
> 
> It is little bit unexpected, because we bypass if the condition happens
> before the reclaim but then we ignore it.

"mm: memcontrol: rearrange charging fast path", moves the pending
signal check inside the retry block, right before reclaim.
