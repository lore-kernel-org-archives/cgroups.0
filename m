From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Thu, 20 Feb 2020 13:23:26 -0500
Message-ID: <20200220182326.ubcjycaubgykiy6e@ca-dmjordan1.us.oracle.com>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <20200219183731.GC11847@dhcp22.suse.cz>
 <20200219191618.GB54486@cmpxchg.org>
 <20200219195332.GE11847@dhcp22.suse.cz>
 <20200219214112.4kt573kyzbvmbvn3@ca-dmjordan1.us.oracle.com>
 <20200219220859.GF54486@cmpxchg.org>
 <20200220154524.dql3i5brnjjwecft@ca-dmjordan1.us.oracle.com>
 <20200220155651.GG698990@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MfkDo7F3aCv5MhbXyV3vcG34vepcUBqfArK40IWMSPM=;
 b=ehED6/brb3OLIlpBCDLQ8RVkzqfWWwGBQzMe5/iZiWEPtp6S/SrP2QtpAUOhXBD/nJW3
 nK+7VZyUtcJpus9B9TOiUgyunJ5eXfP/yip64KVp6ApVzTmHzqKgdXZS93qN3uGRAvaE
 SPIeqGF9hwL5t2z8o2Gnnh4mPl8Yjiaf2TwOo1/zAoPGPiyksfy4sa/+WnA8Du/btm7f
 /G/QxgOuRGFcxgg7HTZq4owWLjVCQjGSw0SJ7aXzhyAH8moJodX+KFz7LRuMtQeRUmNT
 3d3czrmcD0EUdXWaDeqPVdLP0JstG5l9g3O2A1i+re25xPZkGfbLuYrmbIVzxxrd79Wb fA== 
Content-Disposition: inline
In-Reply-To: <20200220155651.GG698990-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Feb 20, 2020 at 10:56:51AM -0500, Tejun Heo wrote:
> On Thu, Feb 20, 2020 at 10:45:24AM -0500, Daniel Jordan wrote:
> > Ok, consistency with io and memory is one advantage to doing it that way.
> > Creating kthreads in cgroups also seems viable so far, and it's unclear whether
> > either approach is significantly simpler or more maintainable than the other,
> > at least to me.
> 
> The problem with separate kthread approach is that many of these work
> units are tiny, and cgroup membership might not be known or doesn't
> agree with the processing context from the beginning

The amount of work wouldn't seem to matter as long as the kernel thread stays
in the cgroup and lives long enough.  There's only the one-time cost of
attaching it when it's forked.  That seems doable for unbound workqueues (the
async reclaim), but may not be for the network packets.

The membership and context issues are pretty compelling though.  Good to know,
I'll keep it in mind as I think this through.

> For example, the ownership of network packets can't be determined till
> processing has progressed quite a bit in shared contexts and each item
> too small to bounce around. The only viable way I can think of
> splitting aggregate overhead according to the number of packets (or
> some other trivially measureable quntity) processed.
> 
> Anything sitting in reclaim layer is the same. Reclaim should be
> charged to the cgroup whose memory is reclaimed *but* shouldn't block
> other cgroups which are waiting for that memory. It has to happen in
> the context of the highest priority entity waiting for memory but the
> costs incurred must be charged to the memory owners.
> 
> So, one way or the other, I think we'll need back charging and once
> back charging is needed for big ticket items like network and reclaim,
> it's kinda silly to use separate mechanisms for other stuff.

Yes, having both would appear to be redundant.

> > Is someone on your side working on remote charging right now?  I was planning
> > to post an RFD comparing these soon and it would make sense to include them.
> 
> It's been on the to do list but nobody is working on it yet.

Ok, thanks.
