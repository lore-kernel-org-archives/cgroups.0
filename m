From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 5/8] memcg: sleep during flushing stats in safe
 contexts
Date: Thu, 30 Mar 2023 15:30:13 -0400
Message-ID: <ZCXjRYASA+Cjomlx@cmpxchg.org>
References: <20230330191801.1967435-1-yosryahmed@google.com>
 <20230330191801.1967435-6-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1680204618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Khpw7ou3XcOkEyyu20b7pCpZUxpOS3o1zWL8rB8cIWg=;
        b=EBZ5RSwu7qAxwJOxXP+VV5tCHAvd597imHWQHEOpyHjV99Yma2yYj2+GVrBE3CvEYu
         j8GOYLIo/8V6p01dDFwWDz0SuE7pJ9ps3e/uuV/vrp+Efny6FMlE8BM6+lrA9yui5XXy
         BP6sOtWFiXcCali8wq+wJ3ZeGb16MFGin5/zucLqAsEfB6IkgmUZYUNLVZS0o4LTsQYV
         p4WDiyCZ5dD1Xl6y5Lz0GhJWbb1bQHZ85QIJV0Hj8hcm7nUsFbYsfBttw01lkBWhwMDp
         adaoaJrHF1Tqpn0MyPd0QZKQohCtbf0gRnsrAsPTFufImEuTtaA7mENwlPt7Do/NeuEl
         4V8A==
Content-Disposition: inline
In-Reply-To: <20230330191801.1967435-6-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>

On Thu, Mar 30, 2023 at 07:17:58PM +0000, Yosry Ahmed wrote:
> Currently, all contexts that flush memcg stats do so with sleeping not
> allowed. Some of these contexts are perfectly safe to sleep in, such as
> reading cgroup files from userspace or the background periodic flusher.
> Flushing is an expensive operation that scales with the number of cpus
> and the number of cgroups in the system, so avoid doing it atomically
> where possible.
> 
> Refactor the code to make mem_cgroup_flush_stats() non-atomic (aka
> sleepable), and provide a separate atomic version. The atomic version is
> used in reclaim, refault, writeback, and in mem_cgroup_usage(). All
> other code paths are left to use the non-atomic version. This includes
> callbacks for userspace reads and the periodic flusher.
> 
> Since refault is the only caller of mem_cgroup_flush_stats_ratelimited(),
> change it to mem_cgroup_flush_stats_atomic_ratelimited(). Reclaim and
> refault code paths are modified to do non-atomic flushing in separate
> later patches -- so it will eventually be changed back to
> mem_cgroup_flush_stats_ratelimited().
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Acked-by: Shakeel Butt <shakeelb@google.com>
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
