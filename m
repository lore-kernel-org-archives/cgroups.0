From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 05/16] consider a memcg parameter in
 kmem_create_cache
Date: Fri, 21 Sep 2012 11:14:58 -0700
Message-ID: <20120921181458.GG7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-6-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=z8Ir4VcH4s5crFson/viq4+XlTxZsBLhdXd97gxHBlA=;
        b=AK78P8nnosToB59tGVdlUM5QOBgj4jGdOZmQpchbEkZEzpyeoBfCIl9Vbcw29kE7Pl
         4tNlO8iTZ228H/WCgAsHDAUzrI6RFI6Ylc9NHeapRJLR0AsIOEanG6QW4sjArMooNxvo
         0LiZgaGCy4my7DFUgUsT1NUt8P9eyQGg0co1rUfPtyFyWMio7EqfXt1DKbQNZTyGAw1Y
         XJRdEuuKgXBRI1WMSK6a/H2z16b1bfp39Ne9Kts2RzS39H7xMves6mA1yGskOul9B4uc
         KVHgTzQ3ZIXFN20YwL1M+aIWqm1OuRcF80SP1otb4J+gwD0v/fQ/X4PdtUDPfGv5tupo
         aIlQ==
Content-Disposition: inline
In-Reply-To: <1347977530-29755-6-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>

Hello, Glauber.

On Tue, Sep 18, 2012 at 06:11:59PM +0400, Glauber Costa wrote:
> +void memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *cachep)
> +{
> +	int id = -1;
> +
> +	if (!memcg)
> +		id = ida_simple_get(&cache_types, 0, MAX_KMEM_CACHE_TYPES,
> +				    GFP_KERNEL);
> +	cachep->memcg_params.id = id;
> +}

I'm a bit confused.  Why is id allocated only when memcg is NULL?

Also, how would the per-memcg slab/slubs appear in slabinfo?  If they
appear separately it might be better to give them readable cgroup
names.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
