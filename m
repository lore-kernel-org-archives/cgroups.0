From: Max Kellermann <mk@cm4all.com>
Subject: Re: [PATCH] cgroup_pids: add fork limit
Date: Tue, 10 Nov 2015 17:01:34 +0100
Message-ID: <20151110160134.GB20758@rabbit.intern.cm-ag>
References: <144716440621.20175.1000688899886388119.stgit@rabbit.intern.cm-ag>
 <CAOviyaiXSCztjv0d99G-t-yo1wtGzXZr0qpuqcKDBdV=wnMinw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOviyaiXSCztjv0d99G-t-yo1wtGzXZr0qpuqcKDBdV=wnMinw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org

On 2015/11/10 16:25, Aleksa Sarai <cyphar@cyphar.com> wrote:
> > The goal of this limit is to have another safeguard against fork
> > bombs.  It gives processes a chance to set up their child processes /
> > threads, but will be stopped once they attempt to waste resources by
> > continuously exiting and cloning new processes.  This can be useful
> > for short-lived processes such as CGI programs.
> 
> Processes don't "use up resources" after they've died and been freed
> (which is dealt with inside PIDs).

That is true, but misses the point.

At some point, while the fork was in progress, those processes did
consume a considerable amount of resources.  At that very range of
time, the server was occupied with executing these forks, and was
unable to give CPU time to other processes.

Now if the kernel had stopped that fork bomb earlier, he would have
had more capacity to execute other jobs which are waiting in the
queue.  That fork bomb did do its damage, even though the number of
processes was limited - and the goal of the fork limit feature is to
detect it early and stop it from spreading larger.

Some jobs are predictable in how many forks will happen.  Just like
some jobs are predictable in how many processes there will be at a
time, how many open files it has at a time, how much memory it will
consume at a time.  All those limits are useful.

That's the big difference: existing cgroups limit a given resource at
one point in time, while "fork limit" is a counter that expires after
a certain amount of resources is consumed (integrated over time).  It
is about "consumption", not about "usage".

This is similar to RLIMIT_CPU, which does not rate-limit the CPU
usage, but the total amount of time spent executing.

> Fork bombs aren't bad because they cause a lot of fork()s, they're bad
> because the *create a bunch of processes that use up memory*, which
> happens because they call fork() a bunch of times and **don't
> exit()**.

That is partly true, but is just one side of the story.

The fork() calls itself are expensive, and a process forking and
exiting over and over can put heavy load on your server.  All within
"pids" and "memcg" limits.

The goal of my patch is to stop the fork bomb as early as possible,
with an additional limit that is reasonable, which no "good" job
implementation will need to cross.

I developed this feature long before cgroups have been invented
(actually I developed something similar to cgroups/namespaces back
then).  It has been proven very successful in a large CGI hosting
cluster.  It's perfectly ok for me to maintain this in my private
branch forever ...

Max
