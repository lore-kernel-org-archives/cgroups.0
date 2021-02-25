From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] memcg: enable memcg oom-kill for __GFP_NOFAIL
Date: Thu, 25 Feb 2021 13:36:06 -0800 (PST)
Message-ID: <f9a2aff-727b-445c-f6bd-613fc8725a@google.com>
References: <20210223204337.2785120-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=/U0ItIv10awr48o0Xr67ORIR0R4cpmrKcS939Ry0u60=;
        b=aM51O6VgHioWd7XkWW6peAD4fP73FQxRl9onjbsDlp5Blv8GVDlbHlQ+bVRRjiux/q
         VIxiQcJR41IkzBS8pG7heU8OynV6hjepxqvlstpyFvUkQWJhAnBl+a6tpRtBk+ZyE13j
         zVdDJdwPN3PqFz/Ss1XlFCxH4TSZowvWFTJivJL+xB/l89cEcHmp/rYKIVkSu4LT8hga
         5nSYNt+3RUeWL1/NWf0uHLE+a5HhUal3ERbcabQPkwbKuVJfkwuRGqyfFarm3LfwfI8M
         Mj5tmQZmj/xixxD5TIyQNEkHBfKvZEGwiP/SS9Cz6oyw1sHAzZLiS2+UfBZj5WuIOQA8
         iO3Q==
In-Reply-To: <20210223204337.2785120-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue, 23 Feb 2021, Shakeel Butt wrote:

> In the era of async memcg oom-killer, the commit a0d8b00a3381 ("mm:
> memcg: do not declare OOM from __GFP_NOFAIL allocations") added the code
> to skip memcg oom-killer for __GFP_NOFAIL allocations. The reason was
> that the __GFP_NOFAIL callers will not enter aync oom synchronization
> path and will keep the task marked as in memcg oom. At that time the
> tasks marked in memcg oom can bypass the memcg limits and the oom
> synchronization would have happened later in the later userspace
> triggered page fault. Thus letting the task marked as under memcg oom
> bypass the memcg limit for arbitrary time.
> 
> With the synchronous memcg oom-killer (commit 29ef680ae7c21 ("memcg,
> oom: move out_of_memory back to the charge path")) and not letting the
> task marked under memcg oom to bypass the memcg limits (commit
> 1f14c1ac19aa4 ("mm: memcg: do not allow task about to OOM kill to bypass
> the limit")), we can again allow __GFP_NOFAIL allocations to trigger
> memcg oom-kill. This will make memcg oom behavior closer to page
> allocator oom behavior.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Acked-by: David Rientjes <rientjes@google.com>
