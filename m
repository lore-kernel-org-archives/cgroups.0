From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 12/16] memcg/sl[au]b Track all the memcg children of
 a kmem_cache.
Date: Fri, 21 Sep 2012 13:31:01 -0700
Message-ID: <20120921203101.GP7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-13-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jYvvIO8TY1fWMvUKgr4HFduz9zJthrc754nwdedKqJc=;
        b=FM3LJup5k0k+MBcqi/YvQMwExCuhHN0YWvcY2NSzqAj7edW9nq4+CNeBLtI6sFdFKt
         Bj4yuIefNeAUTsUuZNaorrg138X27LCvLeXeDR9ex7MgXSPOUTy82JpYDnoJyRCcnBJF
         dcIL02VtiUAP/CKGlPgMAzNCDu3+PQ7L831Mcl+k0B9FddimkFU37IhTyjMXxxo7tl70
         GG6TjqD1GXBpcQLpJ6u2f8KGXQaZEwMgjrsTTl5DaawtF7q2RLxuHxHOrlS6kgmoq6V8
         t8WDhbTc4MiiT6yAOFMT+fkbAFrtgb/eayrh4XxRQhmmbFG5k3DzwKB2LGk55gFBlGo5
         YaMw==
Content-Disposition: inline
In-Reply-To: <1347977530-29755-13-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>

Hello, Glauber.

On Tue, Sep 18, 2012 at 06:12:06PM +0400, Glauber Costa wrote:
> This enables us to remove all the children of a kmem_cache being
> destroyed, if for example the kernel module it's being used in
> gets unloaded. Otherwise, the children will still point to the
> destroyed parent.

I find the terms parent / child / sibling a bit confusing.  It usually
implies proper tree structure.  Maybe we can use better terms which
reflect the single layer structure better?

And, again, in general, please add some comments.  If someone tries to
understand this for the first time and takes a look at
mem_cgroup_cache_params, there's almost nothing to guide that person.
What's the struct for?  What does each field do?  What are the
synchronization rules?

> @@ -626,6 +630,9 @@ void memcg_release_cache(struct kmem_cache *cachep)
>  {
>  	if (cachep->memcg_params.id != -1)
>  		ida_simple_remove(&cache_types, cachep->memcg_params.id);
> +	else
> +		list_del(&cachep->memcg_params.sibling_list);
> +

list_del_init() please.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
