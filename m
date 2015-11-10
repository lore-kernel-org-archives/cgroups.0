From: Max Kellermann <mk-xMchvyqCc6DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup_pids: add fork limit
Date: Tue, 10 Nov 2015 18:52:18 +0100
Message-ID: <20151110175218.GA21737@rabbit.intern.cm-ag>
References: <144716440621.20175.1000688899886388119.stgit@rabbit.intern.cm-ag>
 <20151110151223.GA17938@mtj.duckdns.org>
 <20151110153746.GA20758@rabbit.intern.cm-ag>
 <20151110170612.GA21582@rabbit.intern.cm-ag>
 <20151110172915.GA13740@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110172915.GA13740-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015/11/10 18:29, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> It's not a stateful resource.  Of course the resource is controlled in
> terms of bandwidth not absoulte amount consumed.

I'm glad we now agree on the basic facts.

> It's absurd to limit absoulte amount for CPU cycles.

And yet there's an "absurd" feature called RLIMIT_CPU.

It's absurd because it's per-process.  Not because the general idea is
absurd.  The idea is good, and I wish the "cpu" or "cpuacct"
controller had such a knob.  But that's just my opinion.

> The only action possible from there on would be terminating the
> group.  If you wanna do that, do so from userspace.

The kernel already has a documented solution: SIGXCPU and SIGKILL
(already implemented for RLIMIT_CPU).

By the way, I'm not saying RLIMIT_CPU solves my problem - not at all!
I was just explaining why your suggestions don't solve my problem.

> The point is that the missing "feature" is really a non-starter.  What
> if the process falls into infinite loop on fork failures?  It's just a
> silly thing to implement.

Again, you're reverting to useless rhethorical questions to argue why
a feature is silly.

No, the feature is not silly just because it doesn't solve all
problems at once (which is what your rhetorical question implies).
You need other measures to account for endless loops (be it hostile or
out of stupidity).  We do have such measures in our kernel fork.

Other kernel resource limits don't solve all corner cases, but they
were merged anyway.

For example, I can limit I/O and network bandwidth, but I can still
easily stall the whole kernel because the NFS client keeps inode
mutexes locked while waiting for the server, stalling the shrinker,
stalling everything else waiting for the shrinker.  That is a real
problem for us.  But the existence of that problem doesn't make the
net_prio controller bad - it's just one corner case no controller is
currently able to catch.  (In this example, the root cause is bad
kernel code, not a frantic userspace process.  But I hope you get the
point.)

To solve problems with frantic processes, I need more tools, not lame
excuses.  My "fork limit" patch is one tool that has proven to be very
useful.  Maybe one day somebody has a better idea to solve my problem,
but what you said does not.

Max
