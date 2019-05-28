From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v5 1/7] mm: postpone kmem_cache memcg pointer
 initialization to memcg_link_cache()
Date: Tue, 28 May 2019 17:56:37 -0400
Message-ID: <20190528215637.GA26614@cmpxchg.org>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-2-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bTzfa4MPBlCsa2uhQknRd/UBV4ojcryy1ZVgr46O0Y0=;
        b=qG03h26gMGgX2CIkJTJdgFwW1fdUGvwM+12oszmGpSYZILYYex8mUqUYB6umJaX2Ge
         BPs7imkNRty6RvcxCTTiaTmPe5Xa7U8IH4yrqIXzMGTxxoN84iWr7xdRxHP+vD9H1P5p
         dq8iGcLIIIWikZqSc6UFy/+0zDb72gN/C0xjf1mr/a9yQaKT749fFHtZt2jdLd6q74oz
         9cto1oQA1PS9VLo2TFd0bDJmnEuDFf3JyqvvRgun2EM123fVGo3KtW0SHC90c8aDUUbG
         aNfTXaIBezA+iAftELYk80T9oTBtjgPINgmGAHwOZWxXxPIIrCx20PddZ/3IOb8uvPvy
         ZI7Q==
Content-Disposition: inline
In-Reply-To: <20190521200735.2603003-2-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>

On Tue, May 21, 2019 at 01:07:29PM -0700, Roman Gushchin wrote:
> Initialize kmem_cache->memcg_params.memcg pointer in
> memcg_link_cache() rather than in init_memcg_params().
> 
> Once kmem_cache will hold a reference to the memory cgroup,
> it will simplify the refcounting.
> 
> For non-root kmem_caches memcg_link_cache() is always called
> before the kmem_cache becomes visible to a user, so it's safe.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
