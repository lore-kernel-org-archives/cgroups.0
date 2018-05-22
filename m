From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH] mm: fix race between kmem_cache destroy, create and
 deactivate
Date: Tue, 22 May 2018 16:43:02 +0000
Message-ID: <0100016388bb8ade-de95df0e-6154-4ddc-98bb-ee33811cca85-000000@email.amazonses.com>
References: <20180521174116.171846-1-shakeelb@google.com> <20180521114227.233983ac7038a9f4bf5b7066@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ug7nbtf4gccmlpwj322ax3p6ow6yfsug; d=amazonses.com; t=1527007382;
        h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type:Feedback-ID;
        bh=ifK5nphAsIvboDdGhQRXC44uOJcpD6cBQHzAowxFlf4=;
        b=KmhSvcoe/8KozPIjq1LtNQnQUsyAm08sDtM1VVRVyZN+1mjF9JZI4fAjqeKDxiKw
        Gfz0DpjpU12KDH3vZotMbWcSaFR2fzR31XF0yvMdHQc5x+ELbdidm6pc8UcjxRvmFUn
        HUrYugKfhcaqvLw6q+hZF9LhWhKtmkErZC6baDTU=
In-Reply-To: <20180521114227.233983ac7038a9f4bf5b7066@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@kernel.org>, Greg Thelen <gthelen@google.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, Linux MM <linux-mm@kvack.org>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Mon, 21 May 2018, Andrew Morton wrote:

> The patch seems depressingly complex.
>
> And a bit underdocumented...

Maybe separate out the bits that rename refcount to alias_count?

> > +	refcount_t refcount;
> > +	int alias_count;
>
> The semantic meaning of these two?  What locking protects alias_count?

slab_mutex

>
> >  	int object_size;
> >  	int align;
> >
> > diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
> > index 3773e26c08c1..532d4b6f83ed 100644
> > --- a/include/linux/slub_def.h
> > +++ b/include/linux/slub_def.h
> > @@ -97,7 +97,8 @@ struct kmem_cache {
> >  	struct kmem_cache_order_objects max;
> >  	struct kmem_cache_order_objects min;
> >  	gfp_t allocflags;	/* gfp flags to use on each alloc */
> > -	int refcount;		/* Refcount for slab cache destroy */
> > +	refcount_t refcount;	/* Refcount for slab cache destroy */
> > +	int alias_count;	/* Number of root kmem caches merged */
>
> "merged" what with what in what manner?

That is a basic SLUB feature.
