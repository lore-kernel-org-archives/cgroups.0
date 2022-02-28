From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH] memcg: async flush memcg stats from perf sensitive
 codepaths
Date: Mon, 28 Feb 2022 19:46:53 +0100
Message-ID: <20220228184653.GA1812@blackbody.suse.cz>
References: <20220226002412.113819-1-shakeelb@google.com>
 <20220225165842.561d3a475310aeab86a2d653@linux-foundation.org>
 <CALvZod7SA17vounKnq1KX23172rztNN_Oo0K1XaeEuS4JVEhMw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646074015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XFD/luhJC8LruRYLMs0gTooM9kEU0Vb0THBd4sc3pRA=;
        b=KRyo6rUkMNul2GZJKG7Kx0l4Nw4gD3yieyj/lCJCTigs5UFZ978tEqO1/WbNe75Q6r5PU/
        jEvk+0GNiPgx1SINVBkCHyUeG/o7df+NptnWhTTZ+74gBbV0gL7jhYSV9B5RCwwVVOAH9R
        vHSGjFMxoT/+7S52NU/YCFOvI+99ku4=
Content-Disposition: inline
In-Reply-To: <CALvZod7SA17vounKnq1KX23172rztNN_Oo0K1XaeEuS4JVEhMw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Daniel Dao <dqminh@cloudflare.com>, stable <stable@vger.kernel.org>

On Fri, Feb 25, 2022 at 05:42:57PM -0800, Shakeel Butt <shakeelb@google.com> wrote:
> Yes, the right fix would be to optimize the flushing code (but that
> would require more work/time). However I still think letting
> performance critical code paths to skip the sync flush would be good
> in general. So, if the current patch is not to your liking we can
> remove mem_cgroup_flush_stats() from workingset_refault().

What about flushing just the subtree of the memcg where the refault
happens?
It doesn't reduce the overall work and there's still full-tree
cgroup_rstat_lock but it should make the chunks of work smaller
durations more regular.


Michal

