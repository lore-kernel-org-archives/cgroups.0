From: patchwork-bot+netdevbpf@kernel.org
Subject: Re: [PATCH bpf-next v9 0/5] bpf: rstat: cgroup hierarchical stats
Date: Thu, 25 Aug 2022 18:40:16 +0000
Message-ID: <166145281660.28094.16612223815048062311.git-patchwork-notify@kernel.org>
References: <20220824030031.1013441-1-haoluo@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661452816;
        bh=pGsnlrzUs9rFUKA1BHRL6k9aWIJQ/q1skMQLzZaS5rQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vM36CzAGqCstVAofRH9O8k5B6COSFFRc+vCFwFrBdU7R9OnoQVPqY0DkHa5JM9i8L
         TAUmmFH7jtb/DaN0+YZv+A86P9T8xmlwUyV0crgMZp3EBo85OOs9G6HFpqaCc9wHzW
         JdgQaq/7atIsuDMOw7T3hD2EobDzYo2LxLm6sf/ZTvbf2UNQ6CaUtiRhRWOcJK+WEf
         M96F91YU3Rc74GntKdLTgW1DaGTk0oq902MubZkNIfqsCb4p/D2G3wMNn81Icltbj2
         D86xRDTrAmLpl87DmyfAF/9VDG9/hdWmHmZpvS8ZPAtgF6GDy8dbsU3/XKus39XLq4
         NCKLF1zTG1Wdg==
In-Reply-To: <20220824030031.1013441-1-haoluo@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hao Luo <haoluo@google.com>
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, tj@kernel.org, lizefan.x@bytedance.com, kpsingh@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, john.fastabend@gmail.com, jolsa@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, rientjes@google.com, sdf@google.com, shakeelb@google.com, yosryahmed@google.com

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Tue, 23 Aug 2022 20:00:26 -0700 you wrote:
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
  - [bpf-next,v9,1/5] bpf: Introduce cgroup iter
    https://git.kernel.org/bpf/bpf-next/c/d4ccaf58a847
  - [bpf-next,v9,2/5] selftests/bpf: Test cgroup_iter.
    https://git.kernel.org/bpf/bpf-next/c/fe0dd9d4b740
  - [bpf-next,v9,3/5] cgroup: bpf: enable bpf programs to integrate with rstat
    https://git.kernel.org/bpf/bpf-next/c/a319185be9f5
  - [bpf-next,v9,4/5] selftests/bpf: extend cgroup helpers
    https://git.kernel.org/bpf/bpf-next/c/434992bb6037
  - [bpf-next,v9,5/5] selftests/bpf: add a selftest for cgroup hierarchical stats collection
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


