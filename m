From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 8/9] sched/psi: add kernel cmdline parameter
 psi_inner_cgroup
Date: Wed, 3 Aug 2022 09:48:18 -1000
Message-ID: <YurRAnUEloaYMx0W@slm.duckdns.org>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-9-zhouchengming@bytedance.com>
 <Yt7KQc0nnOypB2b2@cmpxchg.org>
 <YuAqWprKd6NsWs7C@slm.duckdns.org>
 <5a3410d6-428d-9ad1-3e5a-01ca805ceeeb@bytedance.com>
 <Yuq3Q6Y9dRnjjcPt@slm.duckdns.org>
 <YurK6MXdJPrV2VYS@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=/TnexTjdFrc/Gu2edl42Moooc6kFX3TgYFD+N6FTpm4=;
        b=QDt3cfQte/Zl4k0s/nJQy5IJo4lGn44+dOrM6ddgvuwo9jKvKLbbnFoL0T8cgQYOoj
         uyUgupOxmCC9zuOi67Jlg1e05mjmaBm5vyCdVxr8VZ+3I3kbNaPxUxd5pndHkzsGdXVR
         n6bZmfKul/vPUIzryzxQ2Ft1gRS7bSyHNWqwz9AgtmOVYtR25fuSYtUDLA+QVH8PZ2Pk
         7HRvQUPlLZBaBFjljW4kobGO084v6+zwuGGUoLlSx6QX8wCQBzBMrxxbP81PFCwFzTvl
         8wxBz+pFiD2rTjn1YZJw3IIgfYhVurD3fyzwJJ324pEp5BArGPhMHE4/0WcYjnYCgi7v
         gV0w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YurK6MXdJPrV2VYS@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>, surenb@google.com, mingo@redhat.com, peterz@infradead.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org

Hello,

On Wed, Aug 03, 2022 at 03:22:16PM -0400, Johannes Weiner wrote:
> Where it gets trickier is also stopping the tracking of task counts in
> a cgroup. For re-enabling afterwards, we'd have to freeze scheduler
> and cgroup state and find all tasks of interest across all CPUs for
> the given cgroup to recreate the counts. I'm not quite sure whether
> that's feasible, and if so, whether it's worth the savings.

If this turns out to be necessary, I wonder whether we can just be
opportunistic. ie. don't bother with walking all the tasks but only remember
whether a task is accounted at a given level or not (this can be a bitmap
which is allocated at cgroup attach type and in most caess will be pretty
small). Then, maybe we can just start accounting them as they cycle through
state transitions - we ignore the ones leaving states that they weren't
accounted for and start remembering the new states they enter.

Thanks.

-- 
tejun
