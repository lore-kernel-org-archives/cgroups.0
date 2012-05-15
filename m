From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 01/29] slab: dup name string
Date: Tue, 15 May 2012 15:04:14 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205151502000.18595@chino.kir.corp.google.com>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-2-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=a5TR0JL8l/Dsedp5h6YMw1SZ+J0ptChFE2+KvOpAEEY=;
        b=nUsXBjXJ4cRQScr2snl7C7HZ064Dbw3lAHXZDXFVW6zVbOPYzLvyESbFK8QnUB3eG9
         NZO3ozeiG+cTCXm5OIN1LKSyqHC73Qnw4GbeJdQzJ9GF4ds62POZSbQz5IPmpNA87jIz
         dUNeYejxouKXzclsHqtmPebanKV/MMsYGyw9VFBwXo11IUFS5BF0rdUJ7F402iZuuBPq
         EKVbG7+VaGebu5WKY2/qEhjHhTrZ+tJVSpYymgHKI4C6nTZjfzxhD5QPM4fyFtcpn+zu
         2VNW7F2FJZfp3rsCotPcrffcW3ZySBj2WMAcb9bHNHRxKzVgUMEcQY6N+SJuAIWWhqPO
         qIgA==
In-Reply-To: <1336758272-24284-2-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On Fri, 11 May 2012, Glauber Costa wrote:

> diff --git a/mm/slab.c b/mm/slab.c
> index e901a36..91b9c13 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2118,6 +2118,7 @@ static void __kmem_cache_destroy(struct kmem_cache *cachep)
>  			kfree(l3);
>  		}
>  	}
> +	kfree(cachep->name);
>  	kmem_cache_free(&cache_cache, cachep);
>  }
>  
> @@ -2526,7 +2527,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>  		BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
>  	}
>  	cachep->ctor = ctor;
> -	cachep->name = name;
> +	cachep->name = kstrdup(name, GFP_KERNEL);
>  
>  	if (setup_cpu_cache(cachep, gfp)) {
>  		__kmem_cache_destroy(cachep);

Couple problems:

 - allocating memory for a string of an unknown, unchecked size, and

 - could potentially return NULL which I suspect will cause problems 
   later.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
