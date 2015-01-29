From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET RFC 0/6] memcg: inode-based dirty-set controller
Date: Wed, 28 Jan 2015 20:21:46 -0500
Message-ID: <20150129012146.GA20617@htj.dyndns.org>
References: <20150115180242.10450.92.stgit@buzz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7Pb8pSOktEpDUOpiRXQMQwazWVPXOmgmQXHWJ1INAHI=;
        b=z6/tZBHZqAyNlaNAG8TP3qK7nrUoWDLXB5nvhwF5ZEg38IfFITv4twOf/fNIcnZ69U
         s9GiIDBriEoqtvs2m70dNtLRP6poXbyJ53cMIo6najnT/bM3uZnGgTt20bGoipRBPjqU
         es7C1CblujgfC3XGG3frhtFPgMZR3+H4MdZEZKTmd/t7Opicm3uoVNk1bO+1VPpVqwb8
         eMCLJSV+12N/x43qYmC4C+PZq1K+qQevYs+S6GCPLWvpYPHBjMPbBPMG5Y7EWW+8hunb
         uA7nY+WETJ3iRTlcRymiqIjrLlzi9Lh/dSO0hPeq4f0SAyZnRwyC0/t6ZmBlv7gcN+I8
         Xp7g==
Content-Disposition: inline
In-Reply-To: <20150115180242.10450.92.stgit@buzz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Roman Gushchin <klamm@yandex-team.ru>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, koct9i@gmail.com

Hello, Konstantin.

Sorry about the delay.

On Thu, Jan 15, 2015 at 09:49:10PM +0300, Konstantin Khebnikov wrote:
> This is ressurection of my old RFC patch for dirty-set accounting cgroup [1]
> Now it's merged into memory cgroup and got bandwidth controller as a bonus.
> 
> That shows alternative solution: less accurate but much less monstrous than
> accurate page-based dirty-set controller from Tejun Heo.

I went over the whole patchset and ISTR having reviewed this a while
ago and the conclusion is the same.  This appears to be simpler on the
surface but this is a hackjob of a design to put it nicely.  You're
working around the complexity of pressure propagation from the lower
layer by building a separate pressure layer at the top most layer.  In
doing so, it's duplicating what already exist below in degenerate
forms but at the cost of fundamental crippling of the whole thing.

This, even in its current simplistic form, is already a dead end.
e.g. iops or bw aren't even the proper resources to distribute for
rotating disks, IO time is, which is what a large proportion of cfq is
trying to estimate and distribute.  What if there are multiple
filesystems on a single device?  Or if a cgroup accesses multiple
backing devices?  How would you guarantee low latency access to a high
priority cgroup while a huge inode from a low pri cgroup is being
written out when none of the lower layers have any idea what they're
doing?

Sure, these issues can be dealt with partially with various
workarounds and additions and I'm sure we'll be doing that if we go
down this path, but the only thing that'll lead to is duplicating more
of what's already in the lower layers with ever growing list of
behavioral and interface oddities which are inherent to the design.

Even in the absence of alternatives, I'd be strongly against this
direction.  I think this sort of ad-hoc "let's solve this one
immediate issue in the easiest way possible" is often worse than not
doing anything.  In the longer term, things like this paint us into a
corner of which we can't easily get out and memcg happens to be an
area where that sort of things took place quite a bit in the past and
people have been desparately trying to right the course, so, no, I
don't think this is happening.

I agree that propagating backpressure from the lower layer involves
more complexity but it is a full and conceptually and design-wise
straight-forward solution which doesn't need to get constantly papered
over.  This is the right thing to do.  It can be argued that the
amount of complexity can be reduced by tracking dirty pages per-inode,
but, if we're gonna do that, we should converting memcg itself to be
per address space too.  The arguments would be exactly the same for
memcg and memcg and writeback must be on the same foundation.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
