From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/11] memcg: propagate kmem limiting information to
 children
Date: Mon, 25 Jun 2012 11:29:07 -0700
Message-ID: <20120625182907.GF3869@google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
 <1340633728-12785-10-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=KrbH4541yw6I1sN0qBJabw6AC72Nijguj9SqKhRzNnk=;
        b=Fj7m4vVbWMJRTfG+PZeO+4PYGZehkPUP0+Zw0MSW3CVmSg4T5giIiXcgvEAsdOHRBU
         qfzplFdwox7Cwc/A5W/NZAqHiQaAg0Su9jvwJKQvQPpc41RRNSNLEH48+GceRfLpivqd
         797rO4hmfkNQjYFxvaq2Vq2/T5H9Zv9WEHWD8pBWSc2isMpz8gzpnmMJKbXtUr5RaUnp
         MclW4IHC8ElXCnSg+kCxJlRHylJMYr2jM6fRmJlYLlh1MAFqH9mbniJpBUXWhV5lLTAq
         +hJdO0h2Bsn6B/hA6K77aoRyDeacWiGZdBj30pgW+eUNWBmaH+OXYdiCsUZixtkXxRVD
         yrYw==
Content-Disposition: inline
In-Reply-To: <1340633728-12785-10-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

Feeling like a nit pervert but..

On Mon, Jun 25, 2012 at 06:15:26PM +0400, Glauber Costa wrote:
> @@ -287,7 +287,11 @@ struct mem_cgroup {
>  	 * Should the accounting and control be hierarchical, per subtree?
>  	 */
>  	bool use_hierarchy;
> -	bool kmem_accounted;
> +	/*
> +	 * bit0: accounted by this cgroup
> +	 * bit1: accounted by a parent.
> +	 */
> +	volatile unsigned long kmem_accounted;

Is the volatile declaration really necessary?  Why is it necessary?
Why no comment explaining it?

> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +static void mem_cgroup_update_kmem_limit(struct mem_cgroup *memcg, u64 val)
> +{
> +	struct mem_cgroup *iter;
> +
> +	mutex_lock(&set_limit_mutex);
> +	if (!test_and_set_bit(KMEM_ACCOUNTED_THIS, &memcg->kmem_accounted) &&
> +		val != RESOURCE_MAX) {
> +
> +		/*
> +		 * Once enabled, can't be disabled. We could in theory
> +		 * disable it if we haven't yet created any caches, or
> +		 * if we can shrink them all to death.
> +		 *
> +		 * But it is not worth the trouble
> +		 */
> +		static_key_slow_inc(&mem_cgroup_kmem_enabled_key);
> +
> +		if (!memcg->use_hierarchy)
> +			goto out;
> +
> +		for_each_mem_cgroup_tree(iter, memcg) {
> +			if (iter == memcg)
> +				continue;
> +			set_bit(KMEM_ACCOUNTED_PARENT, &iter->kmem_accounted);
> +		}
> +
> +	} else if (test_and_clear_bit(KMEM_ACCOUNTED_THIS, &memcg->kmem_accounted)
> +		&& val == RESOURCE_MAX) {
> +
> +		if (!memcg->use_hierarchy)
> +			goto out;
> +
> +		for_each_mem_cgroup_tree(iter, memcg) {
> +			struct mem_cgroup *parent;

Blank line between decl and body please.

> +			if (iter == memcg)
> +				continue;
> +			/*
> +			 * We should only have our parent bit cleared if none of
> +			 * ouri parents are accounted. The transversal order of

                              ^ type

> +			 * our iter function forces us to always look at the
> +			 * parents.

Also, it's okay here but the text filling in comments and patch
descriptions tend to be quite inconsistent.  If you're on emacs, alt-q
is your friend and I'm sure vim can do text filling pretty nicely too.

> +			 */
> +			parent = parent_mem_cgroup(iter);
> +			while (parent && (parent != memcg)) {
> +				if (test_bit(KMEM_ACCOUNTED_THIS, &parent->kmem_accounted))
> +					goto noclear;
> +					
> +				parent = parent_mem_cgroup(parent);
> +			}

Better written in for (;;)?  Also, if we're breaking on parent ==
memcg, can we ever hit NULL parent in the above loop?

> +			clear_bit(KMEM_ACCOUNTED_PARENT, &iter->kmem_accounted);
> +noclear:
> +			continue;
> +		}
> +	}
> +out:
> +	mutex_unlock(&set_limit_mutex);

Can we please branch on val != RECOURSE_MAX first?  I'm not even sure
whether the above conditionals are correct.  If the user updates an
existing kmem limit, the first test_and_set_bit() returns non-zero, so
the code proceeds onto clearing KMEM_ACCOUNTED_THIS, which succeeds
but val == RESOURCE_MAX fails so it doesn't do anything.  If the user
changes it again, it will set ACCOUNTED_THIS again.  So, changing an
existing kmem limit toggles KMEM_ACCOUNTED_THIS, which just seems
wacky to me.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
