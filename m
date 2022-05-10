From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH bpf-next 1/9] bpf: introduce CGROUP_SUBSYS_RSTAT
 program type
Date: Tue, 10 May 2022 09:59:09 -1000
Message-ID: <YnrEDfZs1kuB1gu5@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com>
 <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
 <CAJD7tkZVXJY3s2k8M4pcq+eJVD+aX=iMDiDKtdE=j0_q+UWQzA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ifWnOEmdxbqq+pQ/jtBb+5/wpjcSm5B451TRcuFaBz4=;
        b=XZ/MltcLn2qF6IyLMV0/mPQJt8rZIy78P4eJuB0QU2eaBVpsrZlP7tUoqmdrWS2yj+
         vWYqqnbf3lOc7b4Alt2qhyJUaB+lZ/zk+EnBC4TvVhuIhj34HNt5QemVHi1KSsjqRzFe
         P0ITuUVCOI+wGJdUKoLj4oBezceqxaYdMrEh/IHF63rcY106hyuIU8JMxTIbV6jyc9A2
         lHvnq+3XaMgyVMgK8rl+XNxLU1gWuiGjqS9c8zoMwwSdcGQ71842MoL5FoFtP/d+DM7f
         rGwMJU0Czi+8FTsBMFrke532nzjuPCm1UByIgY5efNQ/9kJVomOP6Lqfmoldu3AKaPmK
         AxzQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJD7tkZVXJY3s2k8M4pcq+eJVD+aX=iMDiDKtdE=j0_q+UWQzA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>

Hello,

On Tue, May 10, 2022 at 12:34:42PM -0700, Yosry Ahmed wrote:
> The rationale behind associating this work with cgroup_subsys is that
> usually the stats are associated with a resource (e.g. memory, cpu,
> etc). For example, if the memory controller is only enabled for a
> subtree in a big hierarchy, it would be more efficient to only run BPF
> rstat programs for those cgroups, not the entire hierarchy. It
> provides a way to control what part of the hierarchy you want to
> collect stats for. This is also semantically similar to the
> css_rstat_flush() callback.

Hmm... one major point of rstat is not having to worry about these things
because we iterate what's been active rather than what exists. Now, this
isn't entirely true because we share the same updated list for all sources.
This is a trade-off which makes sense because 1. the number of cgroups to
iterate each cycle is generally really low anyway 2. different controllers
often get enabled together. If the balance tilts towards "we're walking too
many due to the sharing of updated list across different sources", the
solution would be splitting the updated list so that we make the walk finer
grained.

Note that the above doesn't really affect the conceptual model. It's purely
an optimization decision. Tying these things to a cgroup_subsys does affect
the conceptual model and, in this case, the userland API for a performance
consideration which can be solved otherwise.

So, let's please keep this simple and in the (unlikely) case that the
overhead becomes an issue, solve it from rstat operation side.

Thanks.

-- 
tejun
