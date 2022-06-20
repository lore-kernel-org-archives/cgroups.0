From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH v5 08/11] mm: memcontrol: introduce memcg_reparent_ops
Date: Mon, 20 Jun 2022 15:14:27 +0800
Message-ID: <YrAeU7yy6jhh+4zd@FVFYT0MHHV2J.usts.net>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-9-songmuchun@bytedance.com>
 <Yq99W9ps1b/+XOwh@castle>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eje5eCQ8r99TF3Jk0Qo8Mipd7vUdFeKKOC/KwGU7LYo=;
        b=5rjycCsWpc48JYQSoB4UcNVOmG+xAyesyo1mdm5rRUN994NyEiZ9k1gWuZ8JtZpRMP
         +t2ea1U2dv3RAM5uPoEEheqmZOFdxYojQE4qK1jJiWODWj7qtMc9qreieOw7jgRi3Gru
         CPQKm469WxG0mK9uHF8ugLNBD9vNZqHP0iscnj9b6MT52CKIda2e4NasxL+5tUKOxTOh
         NyfiZR36HKx1Bor2GxITw1ZyRLZ4XW+Qdtc42fjrzuFgzmH9UkQ5/fN/NQv2MgLO8+mA
         ssZzqrrmOpBYjTaya8uuD4A6lIQrGOXoCTbtrCcSo3ZV+2R4u94IGcyvAyggnunAWW9a
         Pc/A==
Content-Disposition: inline
In-Reply-To: <Yq99W9ps1b/+XOwh@castle>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, shakeelb@google.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com, longman@redhat.com

On Sun, Jun 19, 2022 at 12:47:39PM -0700, Roman Gushchin wrote:
> On Mon, May 30, 2022 at 03:49:16PM +0800, Muchun Song wrote:
> > In the previous patch, we know how to make the lruvec lock safe when LRU
> > pages are reparented. We should do something like following.
> > 
> >     memcg_reparent_objcgs(memcg)
> >         1) lock
> >         // lruvec belongs to memcg and lruvec_parent belongs to parent memcg.
> >         spin_lock(&lruvec->lru_lock);
> >         spin_lock(&lruvec_parent->lru_lock);
> > 
> >         2) relocate from current memcg to its parent
> >         // Move all the pages from the lruvec list to the parent lruvec list.
> > 
> >         3) unlock
> >         spin_unlock(&lruvec_parent->lru_lock);
> >         spin_unlock(&lruvec->lru_lock);
> > 
> > Apart from the page lruvec lock, the deferred split queue lock (THP only)
> > also needs to do something similar. So we extract the necessary three steps
> > in the memcg_reparent_objcgs().
> > 
> >     memcg_reparent_objcgs(memcg)
> >         1) lock
> >         memcg_reparent_ops->lock(memcg, parent);
> > 
> >         2) relocate
> >         memcg_reparent_ops->relocate(memcg, reparent);
> > 
> >         3) unlock
> >         memcg_reparent_ops->unlock(memcg, reparent);
> > 
> > Now there are two different locks (e.g. lruvec lock and deferred split
> > queue lock) need to use this infrastructure. In the next patch, we will
> > use those APIs to make those locks safe when the LRU pages reparented.
> > 
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> 
> I've mixed feelings about this: it looks nice, but maybe too nice. I wonder
> if it's better to open-code it. Not very confident, I wonder what others are
> thinking.
>

I also thought about this. Open-code is not simplified than this since
memcg_reparent_ops can be used for 3 locks which simplifies code a lot.
I also want to hear others' thoughts on this.
 
> 1) Because the lock callback is first called for all ops, then relocate, then
> unlock, implicit lock dependencies are created. Now it depends on the order
> of elements in the memcg_reparent_ops array, which isn't very obvious.

Maybe we can add some comments explaining the lock dependency depends on the
element order in array.

> 2) Unlikely there will be a lot of new ops added in the future.
>

Yep. I think so.

Thanks.

> The code looks correct though.
> 
> Thanks!
> 
