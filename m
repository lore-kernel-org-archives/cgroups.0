From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 07/16] memcg: skip memcg kmem allocations in
 specified code regions
Date: Fri, 21 Sep 2012 12:59:29 -0700
Message-ID: <20120921195929.GL7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-8-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XfGXftn2LHDFVYMkfjzSVN5tB0CSdc0SF+uqSWcqqbQ=;
        b=cLBg1X9vrcbSzCwtJ39Ht8p+AAPuTIYSSafTCalVVFz6fimriU2dWaaOQaVs6wdnWF
         uBtT+YMcvDJ4wZFid9kUNpT3iomZb1M6dg8ALn3eakMBnww/Q0yLMLSZyTi8xMW5cps9
         UT11cVkNUKvcJi+66Wdpn8DUZJRiSOv+WtB+pOgSg80J8rE2YBzfb+Wed3wKvnDgKP9V
         qH7O9TMDZl8mK8MSFyZoIC1Hf94zYMkpZZ1D9DRwVPK2ElNYDQM6kNB5Op9dtlY4XaYE
         yrH83PLmznRBraD4gqnuAV7QJqhkOfLAl9CwvnVKZuGZR56jv28+hyUw4mDvqbFOeLc8
         t8mg==
Content-Disposition: inline
In-Reply-To: <1347977530-29755-8-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>

Hello,

On Tue, Sep 18, 2012 at 06:12:01PM +0400, Glauber Costa wrote:
> +static void memcg_stop_kmem_account(void)
> +{
> +	if (!current->mm)
> +		return;
> +
> +	current->memcg_kmem_skip_account++;
> +}
> +
> +static void memcg_resume_kmem_account(void)
> +{
> +	if (!current->mm)
> +		return;
> +
> +	current->memcg_kmem_skip_account--;
> +}

I can't say I'm a big fan of this approach.  If there are enough
users, maybe but can't we just annotate the affected allocations
explicitly?  Is this gonna have many more users?

Also, in general, can we please add some comments?  I know memcg code
is dearth of comments but let's please not keep it that way.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
