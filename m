From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v5 08/11] mm: memcontrol: introduce memcg_reparent_ops
Date: Sun, 19 Jun 2022 12:47:39 -0700
Message-ID: <Yq99W9ps1b/+XOwh@castle>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-9-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655668066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OmVesAtZj3F0FKl2f4W9KeAOvC/uB1VCNNtyFwxxP9I=;
        b=OY6DMLII7wiyFQUlghxLigw/dZpLgmKP6un0IhO4Cligy+mRBNPXEPRJwVeV1R4Ul0e3KP
        Jps9VNA7Gn97vU3YbFrLGWC3b4hV61+aEF3XU2HbFdMzi3kMOb9X7K5HsFDJwbgmhiMs7T
        6mkneWt1ousS67WqNBDSmvJflVA5YWg=
Content-Disposition: inline
In-Reply-To: <20220530074919.46352-9-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Mon, May 30, 2022 at 03:49:16PM +0800, Muchun Song wrote:
> In the previous patch, we know how to make the lruvec lock safe when LRU
> pages are reparented. We should do something like following.
> 
>     memcg_reparent_objcgs(memcg)
>         1) lock
>         // lruvec belongs to memcg and lruvec_parent belongs to parent memcg.
>         spin_lock(&lruvec->lru_lock);
>         spin_lock(&lruvec_parent->lru_lock);
> 
>         2) relocate from current memcg to its parent
>         // Move all the pages from the lruvec list to the parent lruvec list.
> 
>         3) unlock
>         spin_unlock(&lruvec_parent->lru_lock);
>         spin_unlock(&lruvec->lru_lock);
> 
> Apart from the page lruvec lock, the deferred split queue lock (THP only)
> also needs to do something similar. So we extract the necessary three steps
> in the memcg_reparent_objcgs().
> 
>     memcg_reparent_objcgs(memcg)
>         1) lock
>         memcg_reparent_ops->lock(memcg, parent);
> 
>         2) relocate
>         memcg_reparent_ops->relocate(memcg, reparent);
> 
>         3) unlock
>         memcg_reparent_ops->unlock(memcg, reparent);
> 
> Now there are two different locks (e.g. lruvec lock and deferred split
> queue lock) need to use this infrastructure. In the next patch, we will
> use those APIs to make those locks safe when the LRU pages reparented.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

I've mixed feelings about this: it looks nice, but maybe too nice. I wonder
if it's better to open-code it. Not very confident, I wonder what others are
thinking.

1) Because the lock callback is first called for all ops, then relocate, then
unlock, implicit lock dependencies are created. Now it depends on the order
of elements in the memcg_reparent_ops array, which isn't very obvious.
2) Unlikely there will be a lot of new ops added in the future.

The code looks correct though.

Thanks!
