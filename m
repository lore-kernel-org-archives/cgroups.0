From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 6/7] workingset: memcg: sleep when flushing stats in
 workingset_refault()
Date: Thu, 23 Mar 2023 11:50:40 -0400
Message-ID: <20230323155040.GB739026@cmpxchg.org>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-7-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1679586641;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MgbjNxnbkhKxp3ayTqCe/JjU9SvNsSkqQJ2eCY+DMZI=;
        b=Uax95WAssNXE3MIDqKKB3u/nqAPCZSxTVSddkIH48B1KHmuIotqFwdvX5KENELaT+e
         srIzL8LklW2Ssqy1T23s3P4A7Rbrwc7/2yIjR9CSxZFKptYFPEBvPh7JwY7gaMOp6w9N
         FojxMBtSySjPkBprMQil3VsaB32A1a94++3AgzvX44rNqNkl9uduUufYh1DyMwtlafgk
         0nO9yh1udd1cAqnMBwDvHsl7/slURj+lRn5rIZtNHBwsOQfAB+bjCzuke3CE1Sje0C5q
         +vS4rnZ/lpITkAcIgL5Cs5+LDhdOP+yzSSHCyKfUF8EepIy2Cfeo4UXGo9FZbR6oDODF
         5qKA==
Content-Disposition: inline
In-Reply-To: <20230323040037.2389095-7-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu, Mar 23, 2023 at 04:00:36AM +0000, Yosry Ahmed wrote:
> In workingset_refault(), we call mem_cgroup_flush_stats_delayed() to
> flush stats within an RCU read section and with sleeping disallowed.
> Move the call to mem_cgroup_flush_stats_delayed() above the RCU read
> section and allow sleeping to avoid unnecessarily performing a lot of
> work without sleeping.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
> 
> A lot of code paths call into workingset_refault(), so I am not
> generally sure at all whether it's okay to sleep in all contexts or not.
> Feedback here would be very helpful.

Yes, it's safe.
