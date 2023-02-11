From: patchwork-bot+netdevbpf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Subject: Re: [PATCH bpf-next v2 0/4] bpf, mm: introduce cgroup.memory=nobpf
Date: Sat, 11 Feb 2023 07:10:18 +0000
Message-ID: <167609941850.20060.1828725334029145544.git-patchwork-notify@kernel.org>
References: <20230210154734.4416-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676099418;
        bh=IYS1UXEO949wArIgsINV5rvcHrLkfM5cJb+SmCbKbNQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=umY86AB+wKf1J1/6UxDpMDn9AlI7GSQ3rBUJM7bEi9PlHfypfObSTswAiVI5/TEXw
         9mAbkPULSOM3rHA1GDLSyNXB+/KUyS1LvHZ/MlsXOQPYLyrBq6zw7f/laBFFMO18yu
         mPn39/vQRRbMnWu1vJyihtpBHnq4AZuxn2E/O6s4uPftzgS/QhqiCOeV211rrzVEzE
         essChqKwfnA2gfwrXgA+naR41bkJf7U+qu0j3KbVg5LDgDWHubjAips6gFE5GTlZiw
         MornHY3KRSrrokdDqguozFg6+whdbnMwYm8OfBT1KO06/d1kLyJfRHiWS9VVEaY5W+
         8hbUNrLEA02zA==
In-Reply-To: <20230210154734.4416-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:

On Fri, 10 Feb 2023 15:47:30 +0000 you wrote:
> The bpf memory accouting has some known problems in contianer
> environment,
> 
> - The container memory usage is not consistent if there's pinned bpf
>   program
>   After the container restart, the leftover bpf programs won't account
>   to the new generation, so the memory usage of the container is not
>   consistent. This issue can be resolved by introducing selectable
>   memcg, but we don't have an agreement on the solution yet. See also
>   the discussions at https://lwn.net/Articles/905150/ .
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/4] mm: memcontrol: add new kernel parameter cgroup.memory=nobpf
    https://git.kernel.org/bpf/bpf-next/c/b6c1a8af5b1e
  - [bpf-next,v2,2/4] bpf: use bpf_map_kvcalloc in bpf_local_storage
    https://git.kernel.org/bpf/bpf-next/c/ddef81b5fd1d
  - [bpf-next,v2,3/4] bpf: allow to disable bpf map memory accounting
    https://git.kernel.org/bpf/bpf-next/c/ee53cbfb1ebf
  - [bpf-next,v2,4/4] bpf: allow to disable bpf prog memory accounting
    https://git.kernel.org/bpf/bpf-next/c/bf3965082491

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


