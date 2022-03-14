From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC bpf-next] Hierarchical Cgroup Stats Collection Using BPF
Date: Sun, 13 Mar 2022 19:35:42 -1000
Message-ID: <Yi7ULpR70HatVP/8@slm.duckdns.org>
References: <CAJD7tkbQNpeX8MGw9dXa5gi6am=VNXwgwUoTd6+K=foixEm1fw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C2/3lb1hdkF97hNbei7dfXomt9xkrDDtfYf9ru8Gdm4=;
        b=oNVR0qUtUkejwD2PE40U3m3bOfecNXxVeKkVp9fOm+3Me77M45+NPeo55ubqZlKq7r
         MB7tiA63/q1i44rKG6d5ltclJzQv3Qz6hhh3RVq9xq7IO4ncnICocd4C9j5XVYHLTf1H
         0t37CbsvKjlG0aLe8uQgii2HaQrObeg3Am1odGPvV1Uc+c31V9C/Ju30rReVHe8B7ESC
         epUdibdIm8U4Wa6yuG/J9mGpJ520zSl63IpEll5h0ZCNatE7cUD1FFvlYx5LP4BamLZT
         MjTkoUVR2DYc65MSqHiATmVgOUcADjVgzLehE3W1M6UCy8UGQSH8LXrnv7gEq+fTE4Gr
         17Kw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJD7tkbQNpeX8MGw9dXa5gi6am=VNXwgwUoTd6+K=foixEm1fw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Johannes Weiner <hannes@cmpxchg.org>, Hao Luo <haoluo@google.com>, Shakeel Butt <shakeelb@google.com>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, bpf@vger.kernel.org, KP Singh <kpsingh@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org

Hello,

On Wed, Mar 09, 2022 at 12:27:15PM -0800, Yosry Ahmed wrote:
...
> These problems are already addressed by the rstat aggregation
> mechanism in the kernel, which is primarily used for memcg stats. We

Not that it matters all that much but I don't think the above statement is
true given that sched stats are an integrated part of the rstat
implementation and io was converted before memcg.

> - For every cgroup, we will either use flags to distinguish BPF stats
> updates from normal stats updates, or flush both anyway (memcg stats
> are periodically flushed anyway).

I'd just keep them together. Usually most activities tend to happen
together, so it's cheaper to aggregate all of them in one go in most cases.

> - Provide flags to enable/disable using per-cpu arrays (for stats that
> are not updated frequently), and enable/disable hierarchical
> aggregation (for non-hierarchical stats, they can still make benefit
> of the automatic entries creation & deletion).
> - Provide different hierarchical aggregation operations : SUM, MAX, MIN, etc.
> - Instead of an array as the map value, use a struct, and let the user
> provide an aggregator function in the form of a BPF program.

I'm more partial to the last option. It does make the usage a bit more
compilcated but hopefully it shouldn't be too bad with good examples.

I don't have strong opinions on the bpf side of things but it'd be great to
be able to use rstat from bpf.

Thanks.

-- 
tejun
