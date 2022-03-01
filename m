From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] memcg: async flush memcg stats from perf sensitive
 codepaths
Date: Tue, 1 Mar 2022 10:05:35 +0100
Message-ID: <Yh3h33W45+YaMo92@dhcp22.suse.cz>
References: <20220226002412.113819-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646125536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wGg057MYVvEAycP3sfZdyFUbrSVStkSu0yUPk3uN7Bk=;
        b=PJoZmxdWQDxzOd6JDIbAkU3p3tENb3df9iSpKNeHZYe93Q99vfTMJarHj+aETJi22OlE5Q
        efK+c6N9PbE136rXo1pky4rH41gSHXh2m7J9RwIyMmRpO8MczpWn87pP2o6nC4Fl5P54lt
        Me2wF3cUpDucfbZcglIKYCU5DXTsEoQ=
Content-Disposition: inline
In-Reply-To: <20220226002412.113819-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, stable@vger.kernel.org

On Fri 25-02-22 16:24:12, Shakeel Butt wrote:
> Daniel Dao has reported [1] a regression on workloads that may trigger
> a lot of refaults (anon and file). The underlying issue is that flushing
> rstat is expensive. Although rstat flush are batched with (nr_cpus *
> MEMCG_BATCH) stat updates, it seems like there are workloads which
> genuinely do stat updates larger than batch value within short amount of
> time. Since the rstat flush can happen in the performance critical
> codepaths like page faults, such workload can suffer greatly.
> 
> The easiest fix for now is for performance critical codepaths trigger
> the rstat flush asynchronously. This patch converts the refault codepath
> to use async rstat flush. In addition, this patch has premptively
> converted mem_cgroup_wb_stats and shrink_node to also use the async
> rstat flush as they may also similar performance regressions.

Why do we need to trigger flushing in the first place from those paths.
Later in the thread you are saying there is a regular flushing done
every 2 seconds. What would happen if these paths didn't flush at all?
Also please note that WQ context can be overwhelmed by other work so
these flushes can happen much much later.

So in other words why does async work (that can happen at any time
without any control) make more sense than no flushing?
-- 
Michal Hocko
SUSE Labs
