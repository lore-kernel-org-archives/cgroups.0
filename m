From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [RFC PATCH v2 5/7] mm, oom: introduce oom_score_adj for memory
 cgroups
Date: Sun, 4 Jun 2017 22:39:54 +0300
Message-ID: <20170604193954.GC19980@esperanza>
References: <1496342115-3974-1-git-send-email-guro@fb.com>
 <1496342115-3974-6-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D1HQpiFSLHvtjyRSWm4YcxPQ/MCgxwCo03azrlarHaY=;
        b=b0rUayvrrudKO+sjgpWQ96TeTddZU9TdaOxQFUJg17bhsr/ZCk32+WC5PCrlj+sdV2
         ppSRY40anv0r6/6ebqikA5ffIBUWrZlEsI8dq1Es1h91jO1sBcJ7Y8jUbZKmtx4lj1Pl
         uuggI0++R+6bvovJkGu5YwWUTHwrtR6MK5Nt+kfTjqoNaj/OAA6Xe362ogCfTc9dbO8M
         pVB9g9tqCF5KUKgqSm2iziehdjJFhJmE2m5GoMY0Lku4kD7Z64QiIW/cmH3NhNjFAoF4
         o1nQg/vGPLnXusBJRz8Iduy69lWwpGDepikCKJX0uOgISKetLuu8bcnTZk+UJRQ3LNCU
         FYHg==
Content-Disposition: inline
In-Reply-To: <1496342115-3974-6-git-send-email-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jun 01, 2017 at 07:35:13PM +0100, Roman Gushchin wrote:
> Introduce a per-memory-cgroup oom_score_adj setting.
> A read-write single value file which exits on non-root
> cgroups. The default is "0".
> 
> It will have a similar meaning to a per-process value,
> available via /proc/<pid>/oom_score_adj.
> Should be in a range [-1000, 1000].

IMHO OOM scoring (not only the user API, but the logic as well) should
be introduced by a separate patch following the main one (#6) in the
series. Rationale: we might want to commit the main patch right away,
while postponing OOM scoring for later, because some people might find
the API controversial and needing a further, deeper discussion.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
