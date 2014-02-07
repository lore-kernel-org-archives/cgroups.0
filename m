From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: use an ordered workqueue for cgroup destruction
Date: Fri, 7 Feb 2014 10:21:58 -0500
Message-ID: <20140207152158.GC3304@htj.dyndns.org>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=57NSQ9Y2IBO1b+VYup1uzmwJJTbLwEkM6gwxShGQXz4=;
        b=DAPOuUhxORTIV/gbhsDX/PRCdSeN8FokCPjNHFSwa0CiBt9lXZPDjZwgdR0haXtMed
         JvgVUMWFHHAcG6Acs1F4TS6n+bAcCBfFp7oQwgsJfnGV2QH73Gt6eQyvg9gMKxwk60fb
         WEajRDIKDh+OYsxvWLDV0dVSBohpuxFZj2vSw2YBUe1Bv+1KhfbMIMSrKcYjvnehcB/f
         HVdB2FfTitD5HQteA6Pjq8bpQMrxPGsSccGQS4apVUiDINkUVvz3NIxsakW5LLKWxx2i
         VM/p7PBw7dRrW3xQVoVxRVAFtjrXbkg93+iXuXqRmrjZUa7ZoAoTBSxwW+KUSfz67sCE
         CkLQ==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd@google.com>
Cc: Filipe Brandenburger <filbranden@google.com>, Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, Markus Blank-Burian <burian@muenster.de>, Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

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
> 
> Fixes: e5fca243abae ("cgroup: use a dedicated workqueue for cgroup destruction")
> Suggested-by: Filipe Brandenburger <filbranden@google.com>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org # 3.10+

Applied to cgroup/for-3.14-fixes with comment updated to indicate that
this is temporary.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
