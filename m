From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH v5 6/7] mm: reparent slab memory on cgroup removal
Date: Tue, 28 May 2019 21:33:02 +0300
Message-ID: <20190528183302.zv75bsxxblc6v4dt@esperanza>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-7-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/dxRboK00I5JVZJIcKIh8lDmjqTZ8vT2RGIZXym9hs8=;
        b=JdETCGK02W+TtswFGWYTMmY9WIEyBXPpCljaIU/VvB/d3DyEtFWnP0lJVxjUjx9TD+
         BbFimxaiEpjpXaitfVH8KM8TBEOsn6oSsKdEWrPjq9D15Ew99jozw+GsV/lZqrVVZ0bd
         sGtow18Jv93Jk3c4kkSM9BZ05m3scy1imL1EdiSpaSjWhIrIPyNB9w8DdlCdVlnDOZNn
         KB5glui+lV+DZKpPu++CN6VKlXQmcVFXpxLJUgk52DMVAvzV1zTNcKZuZuMlzrMfr+zo
         qH7zlgas8ajm6z/0f37WMEh9ITFodHk5tXZpvMdRGXtAceFsYcaEo3ESqN2B34xySD+d
         KVXQ==
Content-Disposition: inline
In-Reply-To: <20190521200735.2603003-7-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>

On Tue, May 21, 2019 at 01:07:34PM -0700, Roman Gushchin wrote:
> Let's reparent memcg slab memory on memcg offlining. This allows us
> to release the memory cgroup without waiting for the last outstanding
> kernel object (e.g. dentry used by another application).
> 
> So instead of reparenting all accounted slab pages, let's do reparent
> a relatively small amount of kmem_caches. Reparenting is performed as
> a part of the deactivation process.
> 
> Since the parent cgroup is already charged, everything we need to do
> is to splice the list of kmem_caches to the parent's kmem_caches list,
> swap the memcg pointer and drop the css refcounter for each kmem_cache
> and adjust the parent's css refcounter. Quite simple.
> 
> Please, note that kmem_cache->memcg_params.memcg isn't a stable
> pointer anymore. It's safe to read it under rcu_read_lock() or
> with slab_mutex held.
> 
> We can race with the slab allocation and deallocation paths. It's not
> a big problem: parent's charge and slab global stats are always
> correct, and we don't care anymore about the child usage and global
> stats. The child cgroup is already offline, so we don't use or show it
> anywhere.
> 
> Local slab stats (NR_SLAB_RECLAIMABLE and NR_SLAB_UNRECLAIMABLE)
> aren't used anywhere except count_shadow_nodes(). But even there it
> won't break anything: after reparenting "nodes" will be 0 on child
> level (because we're already reparenting shrinker lists), and on
> parent level page stats always were 0, and this patch won't change
> anything.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>

This one looks good to me. I can't see why anything could possibly go
wrong after this change.
