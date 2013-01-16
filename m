From: Colin Cross <ccross@google.com>
Subject: Re: [PATCH v5 00/11] per-cgroup cpu-stat
Date: Tue, 15 Jan 2013 16:33:10 -0800
Message-ID: <CAMbhsRQ7B4Uu1Wukfay+m4K7CVXtVbsTTEd6JHrwC2s+NcEFNA@mail.gmail.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=kKjwv9Bv/CcOAaxNlGgGDBUShDfOkVBsxUM/Ap2OrbQ=;
        b=EFpyRQ9OG79KFJ8kRO3SoeCx92bGGiPAkNgDkCR+ThUUopq9Ob04pnp5xmvBuaoi4S
         Qg8ulw6+Zxh9LbaMs8gmQDMoAnTwun7uDDWKwfizBoG5xiJh6eh0kxqDSSL3RYOp7FlV
         OzeTVlfqYLyyrqriDFwS5ho1mkJK4qb2O4Hq4mNP8MKHpguNk2WU1Nr5EXZQXEL495Yk
         RzjV6cSQdwNdztMtmKm5lAj3GRYfZgWgS3ofAAHklv17pxCvM208RWLIiFvVdpGgKmQy
         eBl/OkeyR7T6+C7L+Xz3zTK5gQrzf67pCii+snFCBNKI0G5DG/QNDwLVSjUGE7MxMLDV
         X3VA==
In-Reply-To: <1357731938-8417-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>

On Wed, Jan 9, 2013 at 3:45 AM, Glauber Costa <glommer@parallels.com> wrote:
> [ update: I thought I posted this already before leaving for holidays. However,
>   now that I am checking for replies, I can't find nor replies nor the original
>   mail in my boxes or archives. I am posting again for safety sake, but sorry
>   you are getting this twice by any chance ]
>
> Hi all,
>
> This is an attempt to provide userspace with enough information to reconstruct
> per-container version of files like "/proc/stat". In particular, we are
> interested in knowing the per-cgroup slices of user time, system time, wait
> time, number of processes, and a variety of statistics.
>
> This task is made more complicated by the fact that multiple controllers are
> involved in collecting those statistics: cpu and cpuacct. So the first thing I
> am doing here, is ressurecting Tejun's patches that aim at deprecating cpuacct.
>
> This is one of the major differences from earlier attempts: all data is provided
> by the cpu controller, resulting in greater simplicity.

Android userspace is currently using both cpu and cpuacct, and not
co-mounting them.  They are used for fundamentally different uses such
that creating a single hierarchy for both of them while maintaining
the existing behavior is not possible.

We use the cpu cgroup primarily as a priority container.  A simple
view is that each thread is assigned to a foreground cgroup when it is
user-visible, and a background cgroup when it is not.  The foreground
cgroup is assigned a significantly higher cpu.shares value such that
when each group is fully loaded the background group will get 5% and
the foreground group will get 95%.

We use the cpuacct cgroup to measure cpu usage per uid, primarily to
estimate one cause of battery usage.  Each uid gets a cgroup, and when
spawning a task for a new uid we put it in the appropriate cgroup.

We could create a new uid cgroup for cpuacct inside the foreground and
background cgroups used for scheduling, but that would drastically
change the way scheduling works when multiple uids have active
threads.  With separate cpu and cpuacct mounts, every active
foreground thread will get equal cpu time.  With co-mounted cpu and
cpuacct cgroups, cpu time will be shared between each accounting
group, and then sub-shared inside that group.

A concrete example:
Two uids, 1 and 2.  Uid 1 has one thread A, uid 2 has two threads B
and C.  All threads are foreground and running continuously.

With separate cpu and cpuacct mounts, we have:
/cpu/foreground/tasks:
A
B
C
/cpuacct/uid/1/tasks:
A
/cpuacct/uid/2/tasks:
B
C

A, B, and C each will get 33% of the cpu time.

With co-mounted cpu and cpuacct mounts:
/cpu/foreground/1/tasks:
A
/cpu/foreground/2/tasks
B
C

A will get 50% of the cpu time, B and C will get 25% of the cpu time.
I don't see any way to add new subgroups for accounting without
partitioning the cpu time for each subgroup.
