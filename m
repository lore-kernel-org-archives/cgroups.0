From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] slub: Don't panic for memcg kmem cache creation
 failure
Date: Fri, 21 Jun 2019 13:52:26 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.1906211352130.77141@chino.kir.corp.google.com>
References: <20190619232514.58994-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=xsZwkR1O4dGnGMsIIG/ufAmeJ6Z+ZenaQocCY4Tza70=;
        b=rv+E/7b7JY6cpCuEo3QEn8sbHqI1ZR79p1uD+ayLvYUjdZXy45cMBXnpOBANzRD/h9
         AKwFkx5YKkPwDV+z+alIPV1uhD4Us31/0w7Onebbflsxun6qItXz81HGcxTZ7S45mQkF
         mdeJXXlNrRYxGieY6CO5sW7OvYILoQQwQhzFqNXgIR9sUhMfzb7yJehRXESr28JDm6lq
         IJUwCKmkCEQEHh2qvgZDsesKij6FJXeF66csul2evLnnuuXC21nlojygQcdLk+8jHF2L
         PqLK6XveRhNJzO6G5iTrQWirXDKQbFegQGPu2Np+nWTUBVb8ggftrLbBsHWiZy5kTdaQ
         g5dg==
In-Reply-To: <20190619232514.58994-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>

On Wed, 19 Jun 2019, Shakeel Butt wrote:

> Currently for CONFIG_SLUB, if a memcg kmem cache creation is failed and
> the corresponding root kmem cache has SLAB_PANIC flag, the kernel will
> be crashed. This is unnecessary as the kernel can handle the creation
> failures of memcg kmem caches. Additionally CONFIG_SLAB does not
> implement this behavior. So, to keep the behavior consistent between
> SLAB and SLUB, removing the panic for memcg kmem cache creation
> failures. The root kmem cache creation failure for SLAB_PANIC correctly
> panics for both SLAB and SLUB.
> 
> Reported-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Acked-by: David Rientjes <rientjes@google.com>
