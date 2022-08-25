From: patchwork-bot+netdevbpf@kernel.org
Subject: Re: [RESEND PATCH bpf-next v9 0/5] bpf: rstat: cgroup hierarchical
Date: Thu, 25 Aug 2022 18:40:16 +0000
Message-ID: <166145281665.28094.14483828352332763496.git-patchwork-notify@kernel.org>
References: <20220824233117.1312810-1-haoluo@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661452816;
        bh=oy+NBN9E7Uaxy3eSfIAa1sdIgOULz1blQP0IjoBk3Vg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FDmdjJgqyelrTfZ0uschjSe0H9q5nw0oYruPp6vBbi97OophCphclgyVWMYbT2aEU
         4rVZNUdQXuFqyTHfLNaoxJgThH1E6Gqf2tsU4zjR8dwQkCbzxD7NTkVNFTtfx0JsWu
         nNMDG8nEsgEV0x1hPLMw0NpRrCvZ00tDPvQrh0nQxaBQmMEKbehU8fxd07uQHpktAy
         Fe4IEDfC/28kHjBhHxEPQITJ8CuJyoZGEmZm60Jc7engXUckPrYawLLDX7UcdI+XSQ
         5xm77dyPuBVsUT7poQpZnt7e4NdMuGl4xjmYddh791Tyek9pFMh77+jOyS3l9i0IVf
         0xUx4GZ2isY1w==
In-Reply-To: <20220824233117.1312810-1-haoluo@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hao Luo <haoluo@google.com>
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, tj@kernel.org, lizefan.x@bytedance.com, kpsingh@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, john.fastabend@gmail.com, jolsa@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, rientjes@google.com, sdf@google.com, shakeelb@google.com, yosryahmed@google.com

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed, 24 Aug 2022 16:31:12 -0700 you wrote:
> This patch series allows for using bpf to collect hierarchical cgroup
> stats efficiently by integrating with the rstat framework. The rstat
> framework provides an efficient way to collect cgroup stats percpu and
> propagate them through the cgroup hierarchy.
> 
> The stats are exposed to userspace in textual form by reading files in
> bpffs, similar to cgroupfs stats by using a cgroup_iter program.
> cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
> - walking a cgroup's descendants in pre-order.
> - walking a cgroup's descendants in post-order.
> - walking a cgroup's ancestors.
> - process only a single object.
> 
> [...]

Here is the summary with links:
  - [RESEND,bpf-next,v9,1/5] bpf: Introduce cgroup iter
    https://git.kernel.org/bpf/bpf-next/c/d4ccaf58a847
  - [RESEND,bpf-next,v9,2/5] selftests/bpf: Test cgroup_iter.
    https://git.kernel.org/bpf/bpf-next/c/fe0dd9d4b740
  - [RESEND,bpf-next,v9,3/5] cgroup: bpf: enable bpf programs to integrate with rstat
    https://git.kernel.org/bpf/bpf-next/c/a319185be9f5
  - [RESEND,bpf-next,v9,4/5] selftests/bpf: extend cgroup helpers
    https://git.kernel.org/bpf/bpf-next/c/434992bb6037
  - [RESEND,bpf-next,v9,5/5] selftests/bpf: add a selftest for cgroup hierarchical stats collection
    https://git.kernel.org/bpf/bpf-next/c/88886309d2e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


