From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] memcg: reparent charges of children before
 processing parent
Date: Wed, 12 Feb 2014 19:25:38 -0500
Message-ID: <20140213002538.GB2916@htj.dyndns.org>
References: <alpine.LSU.2.11.1402121500070.5029@eggly.anvils>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=CQE/ueenvhCFYmCwPQ56L+7b8AMptQr5fLCV4HSK/u0=;
        b=s8jqxlu3+a+Q/O78EJGbj8dQiodvw5r93Yci6qAJ+oEzE/oWnNBAhn3Qpy06fOVtNe
         pcjtqXTtmNYVSKTU+YesK5NSlnuVTZxA5V44GSolh9q7SxQ4qHIQd89nXvJnIoTtlR5F
         4EYlDgntIS40u/ADvxxGuqH+GSZOhGd+16oBDAAwzI5PWNcS7IolZF//JOFEbmK5wzDR
         2D4VNtf2muTxD9F14Sc0J23awrOAUPQehtCDwrzpdGy6EszVR4KymrnYhxGck60We4vF
         Ot9+Tcv7pEyokGW/8g2lD3RvGqHKBHlgLpAuWQxAOuYvUzzpOAxYuvJEr9VV0hI11vmu
         ENhw==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402121500070.5029@eggly.anvils>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Filipe Brandenburger <filbranden@google.com>, Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, Markus Blank-Burian <burian@muenster.de>, Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Hello,

On Wed, Feb 12, 2014 at 03:03:31PM -0800, Hugh Dickins wrote:
> From: Filipe Brandenburger <filbranden@google.com>
> 
> Sometimes the cleanup after memcg hierarchy testing gets stuck in
> mem_cgroup_reparent_charges(), unable to bring non-kmem usage down to 0.
> 
> There may turn out to be several causes, but a major cause is this: the
> workitem to offline parent can get run before workitem to offline child;
> parent's mem_cgroup_reparent_charges() circles around waiting for the
> child's pages to be reparented to its lrus, but it's holding cgroup_mutex
> which prevents the child from reaching its mem_cgroup_reparent_charges().
> 
> Further testing showed that an ordered workqueue for cgroup_destroy_wq
> is not always good enough: percpu_ref_kill_and_confirm's call_rcu_sched
> stage on the way can mess up the order before reaching the workqueue.
> 
> Instead, when offlining a memcg, call mem_cgroup_reparent_charges() on
> all its children (and grandchildren, in the correct order) to have their
> charges reparented first.
> 
> Fixes: e5fca243abae ("cgroup: use a dedicated workqueue for cgroup destruction")
> Signed-off-by: Filipe Brandenburger <filbranden@google.com>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org # v3.10+ (but will need extra care)
> ---
> Or, you may prefer my alternative cgroup.c approach in 2/2:
> there's no need for both.  Please note that neither of these patches
> attempts to handle the unlikely case of racy charges made to child
> after its offline, but parent's offline coming before child's free:
> mem_cgroup_css_free()'s backstop call to mem_cgroup_reparent_charges()
> cannot help in that case, with or without these patches.  Fixing that
> would have to be a separate effort - Michal's?

I've changed my mind several times now but I think it'd be a better
idea to stick to this patch, at least for now.  This one is easier for
-stable backport and it looks like the requirements for ordering
->css_offline() might go away depending on how reparenting changes
work out.

 Reviewed-by: Tejun Heo <tj@kernel.org>

Michal, Johannes, can you guys please ack this one if you guys agree?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
