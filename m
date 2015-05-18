From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET] cgroup, sched: restructure threadgroup locking and
 replace it with a percpu_rwsem
Date: Mon, 18 May 2015 22:06:55 +0200
Message-ID: <20150518200655.GB19282@twins.programming.kicks-ass.net>
References: <1431549318-16756-1-git-send-email-tj@kernel.org>
 <20150518163440.GA24861@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150518163440.GA24861-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, May 18, 2015 at 12:34:40PM -0400, Tejun Heo wrote:
> On Wed, May 13, 2015 at 04:35:15PM -0400, Tejun Heo wrote:
> > threadgroup locking was added because cgroup needs threadgroups to
> > stay stable across attach operations.  It was implemented as a
> > per-signal_struct generic locking mechanism so that other users which
> > require threadgroups stable across blocking operations can use it too;
> > however, it hasn't grown any other use cases and still conditionalized
> > on CONFIG_CGROUPS.
> 
> Ingo, Peter, what do you guys think? 

I had a brief look and didn't spot anhything really weird. I'll try and
give is a little more time tomorrow.

On routing I think you can take it through the cgroup tree if Ingo is ok
with that.
