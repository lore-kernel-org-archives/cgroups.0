From: patchwork-bot+netdevbpf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Subject: Re: [PATCH bpf-next v7 0/8] bpf: rstat: cgroup hierarchical stats
Date: Tue, 09 Aug 2022 16:20:14 +0000
Message-ID: <166006201418.29142.16195047594672738404.git-patchwork-notify@kernel.org>
References: <20220805214821.1058337-1-haoluo@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660062014;
        bh=ScEACFHLlKmH2umhHgKsjorXBX1s/jwBBv3ait+GCJM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gd+0JTLWdSDr1QAWnY2yZOr/xz/qgEsGQGGiFDTaFifk5SJSs9fOcqVFvgk9IW5xb
         /LGGFd7fPvFqNSgmxk8vrbZjv3/T7jeM42OL+5l8/C64BTWaG1p2saKNrCM7FRmFmv
         rEkVvoYJh+lDbloG6HsWTNoQQ/z6JZHKLWzw8XwSwHcR29V458YWlDuO8y/lGhhSNm
         QKmkQNl26KfpY4wVeJLftN5De0Xtq6kWxIoMAk3GlLkXasJ0Rn+UM6GuHNd74DrZmw
         2XZQ1ubBi8fzMFIHIOLQBTTxod7SJEdHtaL497tTxki40tVevXtBfZEVz4cGRCpxLD
         ARxcoAcICOPKg==
In-Reply-To: <20220805214821.1058337-1-haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:

On Fri,  5 Aug 2022 14:48:13 -0700 you wrote:
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
  - [bpf-next,v7,1/8] btf: Add a new kfunc flag which allows to mark a function to be sleepable
    https://git.kernel.org/bpf/bpf-next/c/fa96b24204af
  - [bpf-next,v7,2/8] cgroup: enable cgroup_get_from_file() on cgroup1
    https://git.kernel.org/bpf/bpf-next/c/f3a2aebdd6fb
  - [bpf-next,v7,3/8] bpf, iter: Fix the condition on p when calling stop.
    https://git.kernel.org/bpf/bpf-next/c/be3bb83dab2d
  - [bpf-next,v7,4/8] bpf: Introduce cgroup iter
    (no matching commit)
  - [bpf-next,v7,5/8] selftests/bpf: Test cgroup_iter.
    (no matching commit)
  - [bpf-next,v7,6/8] cgroup: bpf: enable bpf programs to integrate with rstat
    (no matching commit)
  - [bpf-next,v7,7/8] selftests/bpf: extend cgroup helpers
    (no matching commit)
  - [bpf-next,v7,8/8] selftests/bpf: add a selftest for cgroup hierarchical stats collection
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


