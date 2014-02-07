From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: use an ordered workqueue for cgroup
 destruction
Date: Fri, 7 Feb 2014 12:20:44 -0800 (PST)
Message-ID: <alpine.LSU.2.11.1402071130250.333@eggly.anvils>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils> <20140207140402.GA3304@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=leLu//SivOA5/pNr3HVwcW7n5tm2dhZMLMpvDirkWJM=;
        b=c5gxnsRQET+jRT4sAHJTUCivERbnQOmIUsTA3X2ausxN4qb0Hzsw/OcVnGuxoqz0p8
         Wy364YzHLOgnfmgX3lnJw5Q5LfuhCjLipElLt5HQg5ZvnH6dxcU91ix1k5autqbI6jsN
         ZAMx3ErShpBS5p6GWFYDW70AVpcuh6jWjNoqome1QMAFYHH6gnjf4or8NzmlaBXrZKVd
         Y0LyvZBMc5Zx9naC56sZvImaTtBJODNwtxeHBFrV6Q46S2cdq+eTFgQvwFWT7DUGPIGi
         Ger5HGy3WmOdnXnbEKtOkQdXLVRu/VIw87bbGFVnH/4ZJTS7r70gVDrGzlsWf6YX3JXv
         uNwA==
In-Reply-To: <20140207140402.GA3304-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi Tejun,

On Fri, 7 Feb 2014, Tejun Heo wrote:
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
> 
> Hmmm... I'm not really comfortable with this.  This would seal shut
> any possiblity of increasing concurrency in that path, which is okay
> now but I find the combination of such long term commitment and the
> non-obviousness (it's not apparent from looking at memcg code why it
> wouldn't deadlock) very unappealing.  Besides, the only reason
> offline() is currently called under cgroup_mutex is history.  We can
> move it out of cgroup_mutex right now.

Thanks for taking the patch into your tree for now,
and thanks to Michal and Hannes for supporting it.

Yes, we're not sealing a door shut with this one-liner.  My first
reaction to the deadlock was indeed, what's the cgroup_mutex for here?
and I've seen enough deadlocks on cgroup_mutex (though most from this
issue, I now believe) to welcome the idea of reducing its blanket use.

But I think there are likely to be bumps along that road (just as
there have been along the workqueue-ification road), so this ordered
workqueue appears much the safer option for now.  Please rip it out
again when the cgroup_mutex is safely removed from this path.

(I've certainly written memcg code myself that "knows" it's already
serialized by cgroup_mutex at the outer level: I think code that
never reached anyone else's tree, but I'm not certain of that.)

> 
> But even with offline being called outside cgroup_mutex, IIRC, the
> described problem would still be able to deadlock as long as the tree
> depth is deeper than max concurrency level of the destruction
> workqueue.  Sure, we can give it large enough number but it's
> generally nasty.

You worry me there: I certainly don't want to be introducing new
deadlocks.  You understand workqueues much better than most of us: I'm
not sure what "max concurrency level of the destruction workqueue" is,
but it sounds uncomfortably like an ordered workqueue's max_active 1.

You don't return to this concern in the following mails of the thread:
did you later decide that it actually won't be a problem?  I'll assume
so for the moment, since you took the patch, but please reassure me.

> 
> One thing I don't get is why memcg has such reverse dependency at all.
> Why does the parent wait for its descendants to do something during
> offline?  Shouldn't it be able to just bail and let whatever
> descendant which is stil busy propagate things upwards?  That's a
> usual pattern we use to tree shutdowns anyway.  Would that be nasty to
> implement in memcg?

I've no idea how nasty it would be to change memcg around, but Michal
and Hannes appear very open to doing so.  I do think that memcg's current
expectation is very reasonable: it's perfectly normal that a rmdir cannot
succeed until the directory is empty, and to depend upon that fact; but
the use of workqueue made some things asynchronous which were not before,
which has led to some surprises.

Hugh
