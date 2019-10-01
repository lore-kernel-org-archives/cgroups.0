From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH] mm/memcontrol.c: fix another unused function warning
Date: Tue, 01 Oct 2019 10:40:05 -0400
Message-ID: <1569940805.5576.257.camel@lca.pw>
References: <20191001142227.1227176-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9VDIX95q75l1fcGPHAGCoexbF88NYXczf33Qn1D7mVs=;
        b=IeYUUoTk8eThv+72jp/pu8xdlXAAX3/zY7+IYupoKCxoermZheJWI2mo/kCxoX9snx
         axePe7gr3wV54BxZqT/+17qIbHZ7OBZwdPCzV3bvxJW064GLwtbydfK8IG03nph4oexj
         VdPBwQumivhwrAaBWPsJv1sWgC25P8FIgxuzWJKhmJw25hkWNqen/jbydTfC5Yh1LGzA
         qh9CmPBeE9R4aXGYkDViCY+fox3lMgOFu471rQJ3cDyGzPLktOYX1FDYoQDKH2EKrjQ8
         E2zZ/g0fWndeRA309yMCUTfJ3uRFlKpj6BQtWyUfSSsrMSJIjg8gSg5DVJc+Lfzn6Tgp
         Vzcg==
In-Reply-To: <20191001142227.1227176-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Arnd Bergmann <arnd@arndb.de>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com

On Tue, 2019-10-01 at 16:22 +0200, Arnd Bergmann wrote:
> Removing the mem_cgroup_id_get() stub function introduced a new warning
> of the same kind when CONFIG_MMU is disabled:

Shouldn't CONFIG_MEMCG depends on CONFIG_MMU instead?

> 
> mm/memcontrol.c:4929:13: error: unused function 'mem_cgroup_id_get_many' [-Werror,-Wunused-function]
> 
> Address this using a __maybe_unused annotation.
> 
> Note: alternatively, this could be moved into an #ifdef block.  Marking it
> 'static inline' would not work here as that would still produce the
> warning on clang, which only ignores unused inline functions declared
> in header files instead of .c files.
> 
> Fixes: 4d0e3230a56a ("mm/memcontrol.c: fix a -Wunused-function warning")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  mm/memcontrol.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c313c49074ca..5f9f90e3cef8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4921,7 +4921,8 @@ static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
>  	}
>  }
>  
> -static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
> +static void __maybe_unused
> +mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
>  {
>  	refcount_add(n, &memcg->id.ref);
>  }
