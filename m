From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Thu, 20 Aug 2015 00:52:32 -0700
Message-ID: <20150820075232.GA27917@mtj.duckdns.org>
References: <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org>
 <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org>
 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
 <1439954620.3479.30.camel@gmail.com>
 <20150819164113.GB20716@mtj.duckdns.org>
 <1440043259.3515.84.camel@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=3b3oSiGnmZoXKZW7X8awEYXlSC0eCLfcybQifx2OYgk=;
        b=TCn9IzwsFpRSXHwEo1nAuZwJiv2VT+M+2dWUKRKKz60mJ+xYSpW5Q/S00yTxtUqw34
         Gjsjto7TTooUf3h+HmArwOXkutv7eYw1Op1tJfN7eLdGxqIO/CIxMBUnvbceCSE/Yg0M
         TUd/ycdT7vVmRincGfPTk9frIrzD+g6Bg0/ExhO1DSlNjzuWs57kTtoCqktGDDaQMSac
         AYwxj0t7B/LcQevM7P2+LGTljcCbFr8lk9H1/n4v9oTd0ANAh7aOdsZzTgGY3cLeIbbJ
         Es9Fmle3V0zKim6wwsSTKFHRe/VAZ/STNh3ol95LRXzjkfWtkQe16jpaR43bkxsZok0V
         X3lA==
Content-Disposition: inline
In-Reply-To: <1440043259.3515.84.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hey, Mike.

On Thu, Aug 20, 2015 at 06:00:59AM +0200, Mike Galbraith wrote:
> If create/attach/detach/destroy aren't hot paths, what is?  Those are
> fork/exec/exit cgroup analogs.  If you have thousands upon thousands of

Things like page faults?  cgroup controllers hook into subsystems and
their hot path operations get affected by the method of cgroup
association.

Also, migration and create/destroy are completely different.
create/destroy don't need much synchronization - a new task is made
visible only after the initial association is set up and a dying
task's association is destroyed only after the task isn't referenced
by anybody.  There's nothing dynamic about those compared to
migration.

> potentially active cgroups (aka customers), you wouldn't want to keep
> them all around just in case when you can launch cgroup tasks the same
> way we launch any other task.  You wouldn't contemplate slowing down
> fork/exec/exit, but create/attach/detach/destroy are one and the same..
> they need to be just as fast/light as they can be, as they are part and
> parcel of the higher level process.

You're conflating two completely different operations.  Also, when I
say migration is a relatively expensive operation, I'm comparing it to
bouncing a request to another thread as opposed to bouncing the
issuing thread to different cgroup request-by-request.

> That's why my hack ended up in a large enterprise outfit's product, it
> was _needed_ to fix up cgroups performance suckage.  That suckage was
> fixed up properly quite a bit later.

Hmm... I bet you're talking about the removal of synchronize_rcu() in
migration path, sure, that was a silly thing to have there but also
that comparison is likely a couple orders of magnitude off of what the
thread was originally talking about.

> Anyway, if what they or anybody like them can currently do with their
> job launcher/manager gizmos is negatively impacted, they can gripe for
> themselves.  All I'm saying is that there are definitely users out there
> to whom create/attach/detach/destroy are highly important.

Hmmm... I think this discussion got pretty badly derailed at this
point.  If I'm not mistaken, you're talking about tens or a few
hundred millisecs of latency per migration which no longer exists and
won't ever come back and the discussion originally was about something
like migrating thread for issuing several IO requests versus bouncing
that to a dedicated issuer thread in that domain.

Thanks.

-- 
tejun
