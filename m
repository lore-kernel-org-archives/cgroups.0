From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: use an ordered workqueue for cgroup destruction
Date: Fri, 7 Feb 2014 09:04:02 -0500
Message-ID: <20140207140402.GA3304@htj.dyndns.org>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Z7veqXRfE6uoHw4msFQcG75nVFZJrMA493FYJKZq0pc=;
        b=Wvv7t4/HV2MTp+C9t8iLwDQmY7I81Y1QwRuEphoK4C0A9qee0AICUviLDbYLVnC/Uo
         TI0sqU8k6q3ZRVI85u56t7veoB4omUjXOs+AYQzak0rySQNPssZR4H5JpBcaTUfSBMUa
         gNubYLsdNFexm4cUjlVMtZ/IEvYw+uu49IwScSWjjReTkSqgOgNljqVOOh4Eu55g8unj
         ThR/QjhM6i42VASqRsZ+8AkL0YN0HgUHri8NgoFsdiuJtUHeunn23g1VhGeqNl20bpRL
         Ccid6K1zYfyprTuExGsbTBZ9iSLdESQStAi8PdQhQy+fR5NLNeDhB14Ww0AKpFH9PPPn
         ntww==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd@google.com>
Cc: Filipe Brandenburger <filbranden@google.com>, Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, Markus Blank-Burian <burian@muenster.de>, Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Hello, Hugh.

On Thu, Feb 06, 2014 at 03:56:01PM -0800, Hugh Dickins wrote:
> Sometimes the cleanup after memcg hierarchy testing gets stuck in
> mem_cgroup_reparent_charges(), unable to bring non-kmem usage down to 0.
> 
> There may turn out to be several causes, but a major cause is this: the
> workitem to offline parent can get run before workitem to offline child;
> parent's mem_cgroup_reparent_charges() circles around waiting for the
> child's pages to be reparented to its lrus, but it's holding cgroup_mutex
> which prevents the child from reaching its mem_cgroup_reparent_charges().
> 
> Just use an ordered workqueue for cgroup_destroy_wq.

Hmmm... I'm not really comfortable with this.  This would seal shut
any possiblity of increasing concurrency in that path, which is okay
now but I find the combination of such long term commitment and the
non-obviousness (it's not apparent from looking at memcg code why it
wouldn't deadlock) very unappealing.  Besides, the only reason
offline() is currently called under cgroup_mutex is history.  We can
move it out of cgroup_mutex right now.

But even with offline being called outside cgroup_mutex, IIRC, the
described problem would still be able to deadlock as long as the tree
depth is deeper than max concurrency level of the destruction
workqueue.  Sure, we can give it large enough number but it's
generally nasty.

One thing I don't get is why memcg has such reverse dependency at all.
Why does the parent wait for its descendants to do something during
offline?  Shouldn't it be able to just bail and let whatever
descendant which is stil busy propagate things upwards?  That's a
usual pattern we use to tree shutdowns anyway.  Would that be nasty to
implement in memcg?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
