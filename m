From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 4/7] memcg: sleep during flushing stats in safe
 contexts
Date: Thu, 23 Mar 2023 11:56:13 -0400
Message-ID: <20230323155613.GC739026@cmpxchg.org>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-5-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1679586974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=73H5IIveVwCSuj8ISfgz0DD6tM9W3+Bkt6XVlPhAYGQ=;
        b=BOTN3RHikvmNyJ/5BRIscfqCjptXrf8qpEubjPg0OC/Xwy+boUt94/+OfrbOvrjrzs
         cJmWGbxdzfNwYKXLNjFeE4gMQoT6n7Ue/HEG5/LMoEeTKeSw/uGUVJVLhA+eCCAdPAw6
         TtqrrK35mvYRbzkyskIxNy5mDJm9BfKY9K6UzVcc3DGVU9OzF+09jvq6Drjb5mZ2qmVt
         HenjMS5dF/r4y3zFsqrBc6Pye1BCCpqXxrBcHNF0Eo2mmCOm0/3b/V5FU143KRmBza1U
         0t4zXTHbwVZfvfVGehbwYOD9++M2yfXXjOlk6zzl04FgUWlZQ7+y/4hEPkd/CR7pqYbK
         NovA==
Content-Disposition: inline
In-Reply-To: <20230323040037.2389095-5-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu, Mar 23, 2023 at 04:00:34AM +0000, Yosry Ahmed wrote:
> @@ -644,26 +644,26 @@ static void __mem_cgroup_flush_stats(void)
>  		return;
>  
>  	flush_next_time = jiffies_64 + 2*FLUSH_TIME;
> -	cgroup_rstat_flush(root_mem_cgroup->css.cgroup, false);
> +	cgroup_rstat_flush(root_mem_cgroup->css.cgroup, may_sleep);

How is it safe to call this with may_sleep=true when it's holding the
stats_flush_lock?

>  	atomic_set(&stats_flush_threshold, 0);
>  	spin_unlock(&stats_flush_lock);
>  }
