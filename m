From: Max Kellermann <mk@cm4all.com>
Subject: Re: [PATCH] cgroup_pids: add fork limit
Date: Tue, 10 Nov 2015 16:37:46 +0100
Message-ID: <20151110153746.GA20758@rabbit.intern.cm-ag>
References: <144716440621.20175.1000688899886388119.stgit@rabbit.intern.cm-ag>
 <20151110151223.GA17938@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151110151223.GA17938@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, cyphar@cyphar.com, lizefan@huawei.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org

On 2015/11/10 16:12, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Nov 10, 2015 at 03:06:46PM +0100, Max Kellermann wrote:
> > This patch introduces a new setting called "fork_remaining".  When
> > positive, each successful fork decrements the value, and once it
> > reaches zero, no further forking is allowed, no matter how many of
> > those processes are still alive.  The special value "unlimited"
> > disables the fork limit.
> > 
> > The goal of this limit is to have another safeguard against fork
> > bombs.  It gives processes a chance to set up their child processes /
> > threads, but will be stopped once they attempt to waste resources by
> > continuously exiting and cloning new processes.  This can be useful
> > for short-lived processes such as CGI programs.
> 
> But what's the resource here?

CPU consumption and memory bandwidth.  A fork/clone is an operation
that puts considerable load on a machine, most of which happens in
kernel space (copying page tables etc.).

> All first-order resources which can be consumed by forking
> repeatedly already have proper controllers.

They do?

I can limit CPU time with RLIMIT_CPU, but that's per-process and thus
completely useless.  There's no cgroup controller with such a feature.
There's "cpu" which changes priority, "cpuset" selects CPUs, "cpuacct"
only does accounting and "freezer" (somewhat related).  But nothing
that limits CPU usage according to configured rules.

I can limit absolute memory usage with memcg, which is a good thing,
but is orthogonal to this feature.  Note that there are already
various RLIMITs about memory usage, and despite that, memcg was
merged due to RLIMIT shortcomings.

"pids" was merged even though there already was RLIMIT_NPROC.  Again,
RLIMITs have their shortcomings.

But which controllers can I use to achieve the same effect as my fork
limit feature?  Did I miss one?

> What's the point of adding an extra second-order controller?

I explained that, and you just cited my explanation.

> Where do we go from there?  Limit on the number of syscalls?

No idea.  Are these questions really relevant for my patch?

Max
