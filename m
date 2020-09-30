From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] mm: memcontrol: remove obsolete comment of
 mem_cgroup_unmark_under_oom()
Date: Wed, 30 Sep 2020 10:43:43 +0200
Message-ID: <20200930084343.GO2277@dhcp22.suse.cz>
References: <7d1ea112d8a740cab555eaf7be530286@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601455424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QhiptoBURkg4uq4dMDHGe+8biN2SOcQktd4lq8iMzC4=;
        b=VfV4dAj7zRnkAOtH9oe2lFoD+GI1LiJPXeQl9iW87xGUeS7/HL4Tf4zh4DG4lZqyanotic
        qxviOA9fNLmmfV8/5czDMQKDRRwCGC00zf4qsG5MwCLidLYExCBcKV5pKVfCRjRESXR7iK
        CkDeAVlzxX3OD7eMMZSQ3noEWtrfLEE=
Content-Disposition: inline
In-Reply-To: <7d1ea112d8a740cab555eaf7be530286@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linmiaohe <linmiaohe@huawei.com>
Cc: "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed 30-09-20 01:34:25, linmiaohe wrote:
> Michal Hocko <mhocko@suse.com> wrote:
> > On Thu 17-09-20 06:59:00, Miaohe Lin wrote:
> >> Since commit 79dfdaccd1d5 ("memcg: make oom_lock 0 and 1 based rather 
> >> than counter"), the mem_cgroup_unmark_under_oom() is added and the 
> >> comment of the mem_cgroup_oom_unlock() is moved here. But this comment 
> >> make no sense here because mem_cgroup_oom_lock() does not operate on under_oom field.
> >
> >OK, so I've looked into this more deeply and I finally remember why we have this comment here. The point is that under_oom shouldn't underflow and that we have to explicitly check for > 0 because a new child memcg could have been added between mem_cgroup_mark_under_oom and mem_cgroup_unmark_under_oom.
> >
> >So the comment makes sense although it is not as helpful as it could be.
> >I think that changing it to the following will be more usefule
> >
> >	/*
> >	 * Be careful about under_oom underflows becase a child memcg
> >	 * could have neem added after mem_cgroup_mark_under_oom
> 
> Should it be s/neem/been/ ?

yep, fat fingers...

> 
> >	 */
> 
> Many thanks for detailed explanation. Will fix it in v2. Thanks again.

-- 
Michal Hocko
SUSE Labs
