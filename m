From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH v5 1/7] mm: postpone kmem_cache memcg pointer
 initialization to memcg_link_cache()
Date: Tue, 28 May 2019 20:14:16 +0300
Message-ID: <20190528171416.ujwr5rhbo7g4wfd5@esperanza>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-2-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WjL1kPJpFZ+/6P/J2gFeO1EXLoFczY/0XpAxesm/SAI=;
        b=X2EOagEpclu4ci+J5hELZN56hZWa/YKEEJMK9pne6v5cmFWQgQ58z6hcuN4SKQZLrs
         2LYlVt5tiD/iE7WqzRZ8jHNm0MmyqhWQEq2iiBv+DbERpI0KtlpIuMTL9yxGXn0AATbh
         8S0dlssbwt0wAe9eMcKuq2YGU1jgdpZYeMbvwqLprQpHN3qxVNgQDU8vri2A537s8p//
         4WiaEtaZRVBk3HrrAySnKiZf7QfTCHiQPbl3Qy0m6tUmkxDUBAoSxoVUsBGbuUEW8WH2
         XoXsVF5Uid2iHAY8wQtjZ5v4ARPAKJRygdV96eXj2QnQS68LlFvJivE/aqEn0j6N9eNR
         yrbA==
Content-Disposition: inline
In-Reply-To: <20190521200735.2603003-2-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>

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

This one is a no-brainer.

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

Provided it's necessary for the rest of the series.
