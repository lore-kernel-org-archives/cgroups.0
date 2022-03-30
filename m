From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] mm/memcg: move generation assignment and comparison
 together
Date: Wed, 30 Mar 2022 23:04:29 +0000
Message-ID: <20220330230429.ua5y42cgr3f6crnr@master>
References: <20220225003437.12620-1-richard.weiyang@gmail.com>
 <20220225003437.12620-4-richard.weiyang@gmail.com>
 <YkR902CHgavwleet@cmpxchg.org>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dzKZ7ECGkzcFdPQK5M9ncRL/sQmYPUdD+l7iQzUycAA=;
        b=MftjtHFIxELw4IPjIcxy8tjPG26Iq9aW2ed4nF7XZHiDywZb4f2s/BLKMVFS3lWKmm
         9fmTlV+ZpJ8KDPJEtUXaAFySzX5epOxrYuZ/mH4DpCGdxro2jggjgghc/RUbzwlnawP9
         o3XgG435IlPTYm1Xm2n/BvkdW+/nBK6pp4FnWbY2k3fhd69xWmyaLmj8mYrDUMB4djjj
         25nTEL1u5CYdqavAwTnbUNZnKXTfgEzXVGFJw/V6MDfVs0n8+EKD5+9Y95nGENMoGSpj
         ZyYYt4GNVp0A6CHGzJ+kxLhSn7rwgKr41PBNSEOvFSs4mOpwyVo6N1B+jmL56p9z3WFh
         Fa6Q==
Content-Disposition: inline
In-Reply-To: <YkR902CHgavwleet-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Mar 30, 2022 at 11:57:07AM -0400, Johannes Weiner wrote:
>On Fri, Feb 25, 2022 at 12:34:37AM +0000, Wei Yang wrote:
>> For each round-trip, we assign generation on first invocation and
>> compare it on subsequent invocations.
>> 
>> Let's move them together to make it more self-explaining. Also this
>> reduce a check on prev.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>This makes sense. The function is structured into 1) load state, 2)
>advance, 3) save state. The load state is a better fit for
>initializing reclaim->generation.
>
>> @@ -996,7 +996,14 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>>  		mz = root->nodeinfo[reclaim->pgdat->node_id];
>>  		iter = &mz->iter;
>>  
>> -		if (prev && reclaim->generation != iter->generation)
>> +		/*
>> +		 * On first invocation, assign iter->generation to
>> +		 * reclaim->generation.
>> +		 * On subsequent invocations, make sure no one else jump in.
>> +		 */
>> +		if (!prev)
>> +			reclaim->generation = iter->generation;
>> +		else if (reclaim->generation != iter->generation)
>>  			goto out_unlock;
>
>The comment duplicates the code, it doesn't explain why we're doing
>this. How about:
>
>		/*
>		 * On start, join the current reclaim iteration cycle.
>		 * Exit when a concurrent walker completes it.
>		 */

This one looks better and explain the reclaim model.
Thanks

>
>With that, please feel free to add:
>
>Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

-- 
Wei Yang
Help you, Help me
