From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: use an ordered workqueue for cgroup destruction
Date: Fri, 7 Feb 2014 15:35:08 -0500
Message-ID: <20140207203508.GC8833@htj.dyndns.org>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
 <20140207140402.GA3304@htj.dyndns.org>
 <alpine.LSU.2.11.1402071130250.333@eggly.anvils>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/p51M1cbX97+bW33Bv2nNYTirjWem0lsBeV9LKiZNt8=;
        b=fg61d2sciYYvZ6iNRtbBkkWZQiGdLAJTeyj54dcCObchtZgS5K5dgOuWXvnF3PbCM5
         rXmHFOz0xh+1HUVtnwFyX5Q1GU1lN/MOK+reoGFV0ViX4I9e0YxTPGW8Rnwfk2/guuHU
         rbJrOhUaKBoLF0fOC1oMwLdjhfX7XubrDqUghbLPAWFbMlySw2Iwqh41GvCaboEyMT1C
         a0kmzLXW1php+OAGroN/rHcPo+9tKNSBP/vSqZbwTahRoT4vQ6Ccpg0h6svbc71WKoPh
         vHNYC7W4hcrV19GCDi86YDSm0CFZjfgPkyf8mty0qPU+Gfni08XFKstiT2sHxqD/6Fwe
         NYAQ==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402071130250.333@eggly.anvils>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd@google.com>
Cc: Filipe Brandenburger <filbranden@google.com>, Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, Markus Blank-Burian <burian@muenster.de>, Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Hello, Hugh.

On Fri, Feb 07, 2014 at 12:20:44PM -0800, Hugh Dickins wrote:
> > But even with offline being called outside cgroup_mutex, IIRC, the
> > described problem would still be able to deadlock as long as the tree
> > depth is deeper than max concurrency level of the destruction
> > workqueue.  Sure, we can give it large enough number but it's
> > generally nasty.
> 
> You worry me there: I certainly don't want to be introducing new
> deadlocks.  You understand workqueues much better than most of us: I'm
> not sure what "max concurrency level of the destruction workqueue" is,
> but it sounds uncomfortably like an ordered workqueue's max_active 1.

Ooh, max_active is always a finite number.  The only reason we usually
don't worry about it is because they are large enough for the existing
dependency chains to cause deadlocks.  The theoretical problem with
cgroup is that the dependency chain can grow arbitrarily long and
multiple removals along different subhierarchies can overlap which
means that there can be multiple long dependency chains among work
items.  The probability would be extremely low but deadlock might be
possible even with relatively high max_active.

Besides, the reason we reduced max_active in the first place was
because destruction work items tend to just stack up without any
actual concurrency benefits, so increasing concurrncy level seems a
bit nasty to me (but probably a lot of those traffic jam was from
cgroup_mutex and once we take that out of the picture, it could become
fine).

> You don't return to this concern in the following mails of the thread:
> did you later decide that it actually won't be a problem?  I'll assume
> so for the moment, since you took the patch, but please reassure me.

I was just worrying about a different solution where we take
css_offline invocation outside of cgroup_mutex and bumping up
max_active.  There's nothing to worry about your patch.  Sorry about
not being clear.  :)

> > One thing I don't get is why memcg has such reverse dependency at all.
> > Why does the parent wait for its descendants to do something during
> > offline?  Shouldn't it be able to just bail and let whatever
> > descendant which is stil busy propagate things upwards?  That's a
> > usual pattern we use to tree shutdowns anyway.  Would that be nasty to
> > implement in memcg?
> 
> I've no idea how nasty it would be to change memcg around, but Michal
> and Hannes appear very open to doing so.  I do think that memcg's current
> expectation is very reasonable: it's perfectly normal that a rmdir cannot
> succeed until the directory is empty, and to depend upon that fact; but
> the use of workqueue made some things asynchronous which were not before,
> which has led to some surprises.

Maybe.  The thing is that ->css_offline() isn't really comparable to
rmdir.  ->css_free() is and is fully ordered through refcnts as one
would expect.  Whether ->css_offline() should be ordered similarly so
that the parent's offline is called iff all its children finished
offlining, I'm not sure.  Maybe it'd be something nice to have but I
kinda wanna keep the offline hook and its usages simple and limited.
It's not where the actual destruction should happen.  It's just a
notification to get ready.

Looks like Johannes's patch is headed towards that direction - moving
destruction from ->css_offline to ->css_free(), so if that works out,
I think we should be good for the time being.

Thanks!

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
