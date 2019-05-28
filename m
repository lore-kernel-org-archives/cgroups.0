From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v5 5/7] mm: rework non-root kmem_cache lifecycle
 management
Date: Tue, 28 May 2019 18:03:53 -0400
Message-ID: <20190528220353.GC26614@cmpxchg.org>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-6-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZB6HVXPOZ6dJd49xc2bEcD13tElE9byJqAMfahspmoo=;
        b=ToLngH1jdhNI9UHTF8mqD15qUyNQONEg/Z1t3IceMNsoGy9/azm9l4mpXuBFjzeaNU
         DF0dDXbXAvHbBYG0zaQQPpZ/V9sOMriSfNAjQuG5jB3Z+5sMan2GbE4PmLqavh+/yWBT
         dBgFl+Y0x0ZlpdGRI0ttZdHXZKhRYg/Mc4cf+maDZn3pGpuX+sEs1wWdvYCtv4U6SS8v
         2sZKF5aqRSTCE8fqQLDzWJzu+yMg5zVT2DhXjcFim48rFB+G6IWcYilRZeLczdJ2Jm8l
         iNuAb1Z6C7WuucQuNmOjutEP7zMEQcJU0AxxjHeZCcGSZVyvtBwq7unQv0RRuwvFOdlg
         hntQ==
Content-Disposition: inline
In-Reply-To: <20190521200735.2603003-6-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>

On Tue, May 21, 2019 at 01:07:33PM -0700, Roman Gushchin wrote:
> +	arr = rcu_dereference(cachep->memcg_params.memcg_caches);
> +
> +	/*
> +	 * Make sure we will access the up-to-date value. The code updating
> +	 * memcg_caches issues a write barrier to match this (see
> +	 * memcg_create_kmem_cache()).
> +	 */
> +	memcg_cachep = READ_ONCE(arr->entries[kmemcg_id]);

READ_ONCE() isn't an SMP barrier, it just prevents compiler
muckery. This needs an explicit smp_rmb() to pair with the smp_wmb()
on the other side.

I realize you're only moving this code, but it would be good to fix
that up while you're there.
