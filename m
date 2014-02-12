From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: use an ordered workqueue for cgroup
 destruction
Date: Wed, 12 Feb 2014 14:59:44 -0800 (PST)
Message-ID: <alpine.LSU.2.11.1402121417230.5029@eggly.anvils>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils> <20140207164321.GE6963@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=GLuhiC9i0gWv03bkeZ81cUiuSqhADSi/oa0C+OfbBZQ=;
        b=ULx3S6r+ynih7IZDFnoKS0WPI1c5vOpGNhnVPcpzsefzjZ3t7kr1vYr5iIFctGmqLR
         E8hsDrJ4PAVXdGqPciYTbrNZasAG2SJsTrfz7vf9mRSyGnsgwy+r96awEaWiobX44lBa
         5EwvqzHEbJyje/+fQeAXIEKuoiYfCLpd1tZ/577uY1fpuY1yD6cPpJn3VgXPwSLRVkj5
         miXeaGVEGBHwuTaEf+e0V5aTLh6nqSVQ8zPXGnLzjBhrDMIvXrTkfEb7jPF+/lj+Czc3
         ikJ+eBsLpfMqPw7wtwipxORDUFBLxLzrflqbUZNITRVvCYajeWwzMXVbH7Sv7qYDqCfH
         lsog==
In-Reply-To: <20140207164321.GE6963-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, 7 Feb 2014, Johannes Weiner wrote:
> On Thu, Feb 06, 2014 at 03:56:01PM -0800, Hugh Dickins wrote:
> > Sometimes the cleanup after memcg hierarchy testing gets stuck in
> > mem_cgroup_reparent_charges(), unable to bring non-kmem usage down to 0.
> > 
> > There may turn out to be several causes, but a major cause is this: the
> > workitem to offline parent can get run before workitem to offline child;
> > parent's mem_cgroup_reparent_charges() circles around waiting for the
> > child's pages to be reparented to its lrus, but it's holding cgroup_mutex
> > which prevents the child from reaching its mem_cgroup_reparent_charges().
> > 
> > Just use an ordered workqueue for cgroup_destroy_wq.
> > 
> > Fixes: e5fca243abae ("cgroup: use a dedicated workqueue for cgroup destruction")
> > Suggested-by: Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.10+
> 
> I think this is a good idea for now and -stable:
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

You might be wondering why this patch didn't reach Linus yet.

It's because more thorough testing, by others here, found that it
wasn't always solving the problem: so I asked Tejun privately to
hold off from sending it in, until we'd worked out why not.

Most of our testing being on a v3,11-based kernel, it was perfectly
possible that the problem was merely our own e.g. missing Tejun's
8a2b75384444 ("workqueue: fix ordered workqueues in NUMA setups").

But that turned out not to be enough to fix it either. Then Filipe
pointed out how percpu_ref_kill_and_confirm() uses call_rcu_sched()
before we ever get to put the offline on to the workqueue: by the
time we get to the workqueue, the ordering has already been lost.

So, thanks for the Acks, but I'm afraid that this ordered workqueue
solution is just not good enough: we should simply forget that patch
and provide a different answer.

So I'm now posting a couple of alternative solutions: 1/2 from Filipe
at the memcg end, and 2/2 from me at the cgroup end.  Each of these
has stood up to better testing, so you can choose between them,
or work out a better answer.

(By the way, I have another little pair of memcg/cgroup fixes to post
shortly, nothing to do with these two: it would be less confusing if
I had some third fix to add in there, but sadly not.)

Hugh
