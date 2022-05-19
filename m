From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Thu, 19 May 2022 05:08:35 +0000
Message-ID: <20220519050835.ebpiukexgiys6t57@google.com>
References: <20220518223815.809858-1-vaibhav@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ssVw9Fz9ZtI8VSN2PnnCy16Ie6cjZqhXq7jkPcwK+VI=;
        b=p1NA6cOyXSw5ouGNdhysoNKwpC+u544fyrDYu0KRc2c2e3ge13jLIY2R6C9yI7FNxq
         lvhOpidQwLWrlHfaI75+qsSfVYwYmwzwxfCSsYuVmW20p+OGVFMJ11n4krPvP+4y4yQ3
         ArzvvSz0qUdPdAjWkkkdSdgrgz6lcxZrq3hcwLXfVX1xbuRBis2dKkf871l1prfl+BVv
         o7GhGIaYR4wz+MT62Ioh36TOJ/bKjcTPUZdj+8zF3R3erlBHaKgbD6RpGxh8SAEJFC1I
         DBj+/pEpHKZXlI9DEH4YqWzNp7m8KXD40ml1jejz/hE/UOXcup3+tYdHpbBarswgdd+m
         TrBw==
In-Reply-To: <20220518223815.809858-1-vaibhav@linux.ibm.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Yosry Ahmed <yosryahmed@google.com>

On Thu, May 19, 2022 at 04:08:15AM +0530, Vaibhav Jain wrote:
> [1] Provides a way for user-space to trigger proactive reclaim by introducing
> a write-only memcg file 'memory.reclaim'. However reclaim stats like number
> of pages scanned and reclaimed is still not directly available to the
> user-space.
> 
> This patch proposes to extend [1] to make the memcg file 'memory.reclaim'
> readable which returns the number of pages scanned / reclaimed during the
> reclaim process from 'struct vmpressure' associated with each memcg. This should
> let user-space asses how successful proactive reclaim triggered from memcg
> 'memory.reclaim' was ?
> 
> With the patch following command flow is expected:
> 
>  # echo "1M" > memory.reclaim
> 
>  # cat memory.reclaim
>    scanned 76
>    reclaimed 32
> 

Yosry already mentioned the race issue with the implementation and I
would prefer we don't create any new dependency on vmpressure which I
think we should deprecate.

Anyways my question is how are you planning to use these metrics i.e.
scanned & reclaimed? I wonder if the data you are interested in can be
extracted without a stable interface. Have you tried BPF way to get
these metrics? We already have a tracepoint in vmscan tracing the
scanned and reclaimed. 
