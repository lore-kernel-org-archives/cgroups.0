From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/11] memcg: kmem controller infrastructure
Date: Mon, 25 Jun 2012 11:06:19 -0700
Message-ID: <20120625180619.GD3869@google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
 <1340633728-12785-7-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=P7yRG3NjNOZL6i2XQyfdJx4PHc4Eq4Ib354UQIAw0y0=;
        b=gRHD3AOmAGclqAabKP6aaZOSZfBT+PKGW+E5skjwTyaHOzswaeGaV7gV+t/IEEmOH5
         Rlh8JHB/69ncA5omvoq/s65zwJDRzfXlr5FbVg8sDIsLDIKgS/WTbd9PdZ0KVfXwAa9U
         A7+ZCI7TJHOv3lg3HXbRLrryRmbRHJaGmdC5oL/JNJAxjeHN9mWjvmx+iZfz/+af6uIL
         SCpq0SWEPgdJ6PAgZVRXd/xLUiTtzMz+MxFh0Z68+DG/Sa3sCKB2zJo/edoN5rf+b6dC
         o+48gG/YNSHHnsQrQOJzfWeUjaSj28wycAFAInGlW0JfUIWgidnNonFbhkvE4JTvKlKE
         scLw==
Content-Disposition: inline
In-Reply-To: <1340633728-12785-7-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

Again, nits.

On Mon, Jun 25, 2012 at 06:15:23PM +0400, Glauber Costa wrote:
> +#define mem_cgroup_kmem_on 1
> +bool __mem_cgroup_new_kmem_page(gfp_t gfp, void *handle, int order);
> +void __mem_cgroup_commit_kmem_page(struct page *page, void *handle, int order);
> +void __mem_cgroup_free_kmem_page(struct page *page, int order);
> +#define is_kmem_tracked_alloc (gfp & __GFP_KMEMCG)

Ugh... please do the following instead.

static inline bool is_kmem_tracked_alloc(gfp_t gfp)
{
	return gfp & __GFP_KMEMCG;
}

>  #else
>  static inline void sock_update_memcg(struct sock *sk)
>  {
> @@ -416,6 +423,43 @@ static inline void sock_update_memcg(struct sock *sk)
>  static inline void sock_release_memcg(struct sock *sk)
>  {
>  }
> +
> +#define mem_cgroup_kmem_on 0
> +#define __mem_cgroup_new_kmem_page(a, b, c) false
> +#define __mem_cgroup_free_kmem_page(a,b )
> +#define __mem_cgroup_commit_kmem_page(a, b, c)
> +#define is_kmem_tracked_alloc (false)

I would prefer static inlines here too.  It's a bit more code in the
header but leads to less surprises (e.g. arg evals w/ side effects or
compiler warning about unused vars) and makes it easier to avoid
cosmetic errors.

Thanks.

-- 
tejun
