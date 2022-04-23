From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v4 1/4] memcg: introduce per-memcg reclaim interface
Date: Sat, 23 Apr 2022 13:30:35 +0000
Message-ID: <20220423133035.b6iz6vzhzlym3m4w@google.com>
References: <20220421234426.3494842-1-yosryahmed@google.com> <20220421234426.3494842-2-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Aem2PdHshEukZ4FbitCFbjtHLa6kiNwj57G3fxoNlVk=;
        b=XMNhXPfkwDK4e/banSthnWhXs9a5a1aYvMVU0NMfybXNvVEmGdmNtMSK5oZ++QlHWR
         V3ufPwN5hRsYkM5z7ddo0Hd5/C0+X86gdeDg/EcbOv27ChnnE88NajcxBj4l6hUotTKL
         6tfKwnl6G2aAPMEmhO1Yt7R0ge16i+pGXVJ2xPTzPY66OOpXaSAgdxQEYnybzB9GAExs
         VtlV4OYLzO1vWnYGB9iH8I6VOegPQXleK6VLBFgcWRkY7enBxEw+MDSDLoh5bF3WVyfH
         FqpESvZE7ugxZsVz8I+JwrKaWP6J3N54HEMtZksvV6fAOOhKYCeurqhF2C19tTrZ6OiL
         0y0Q==
In-Reply-To: <20220421234426.3494842-2-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.or

On Thu, Apr 21, 2022 at 11:44:23PM +0000, Yosry Ahmed wrote:
> From: Shakeel Butt <shakeelb@google.com>
[...]
> 
> [yosryahmed@google.com: refreshed to current master, updated commit
> message based on recent discussions and use cases]
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

You should add "Co-developed-by" tag for yourself here.

> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Wei Xu <weixugc@google.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  
[...]
> +static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
> +			      size_t nbytes, loff_t off)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
> +	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
> +	unsigned long nr_to_reclaim, nr_reclaimed = 0;
> +	int err;
> +
> +	buf = strstrip(buf);
> +	err = page_counter_memparse(buf, "", &nr_to_reclaim);
> +	if (err)
> +		return err;
> +
> +	while (nr_reclaimed < nr_to_reclaim) {
> +		unsigned long reclaimed;
> +
> +		if (signal_pending(current))
> +			return -EINTR;
> +
> +		/* This is the final attempt, drain percpu lru caches in the

Fix the comment format. "/*" should be on its own line.

> +		 * hope of introducing more evictable pages for
> +		 * try_to_free_mem_cgroup_pages().
> +		 */

No need to send a new version if Andrew can fix these in the mm tree.
