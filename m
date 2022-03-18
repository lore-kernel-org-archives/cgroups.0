From: Song Liu <song@kernel.org>
Subject: Re: [RFC bpf-next] Hierarchical Cgroup Stats Collection Using BPF
Date: Fri, 18 Mar 2022 12:59:14 -0700
Message-ID: <CAPhsuW6QTaCVekkT8Ah0N2K4JY7yiiO2wZjk6pVKuraEqjkoXQ@mail.gmail.com>
References: <CAJD7tkbQNpeX8MGw9dXa5gi6am=VNXwgwUoTd6+K=foixEm1fw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647633566;
        bh=Q/AneTN6VK0FKM8VUMmAL24sxlKXjApD+7URsOBBLys=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fzwYuq1QWgluY2rLULh5F1cIB7CH4nKOrZPexeaBZc3eqdzDEUv+4hdZPHE/gD7lm
         AAWg2sHe+IiUwHYpGjhmmFn5/PJ2zjgbwMhfdLGS2H4SxfTP4N/NOfvFRAMnW8VWFy
         yimWypwcTTA3MjnqBAZ/RlnvhG/U3n37aFDxPygWEA81gV6QKBLBs2RYCQF9DB2v91
         DGKG6Ks4/cjqlRTweaFd53BWPIsYf+32FeAKYmVzVF6K4w3tUr6MFX6ZQbUEMbqBe0
         bYnXIIXo0to0tqAWBxdDupDHEA7/xxy6GoWnuMHPSl0tcZIz3z+LTQEt8ewmEK/H4d
         SXiYQbiRZVVrg==
In-Reply-To: <CAJD7tkbQNpeX8MGw9dXa5gi6am=VNXwgwUoTd6+K=foixEm1fw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>, Namhyung Kim <namhyung@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Johannes Weiner <hannes@cmpxchg.org>, Hao Luo <haoluo@google.com>, Shakeel Butt <shakeelb@google.com>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, bpf <bpf@vger.kernel.org>, KP Singh <kpsingh@kernel.org>, cgroups@vger.kernel.org, Linux-MM <linux-mm@kvack.org>

On Wed, Mar 9, 2022 at 12:27 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> Hey everyone,
>
> I would like to discuss an idea to facilitate collection of
> hierarchical cgroup stats using BPF programs. We want to provide a
> simple interface for BPF programs to collect hierarchical cgroup stats
> and integrate with the existing rstat aggregation mechanism in the
> kernel. The most prominent use case is the ability to extend memcg
> stats (and histograms) by BPF programs.
>

+ Namhyung,

I forgot to mention this in the office hour. The aggregation efficiency
problem is actually similar to Namhyung's work to use BPF programs
to aggregate perf counters. Check:
     tools/perf/util/bpf_skel/bperf_cgroup.bpf.c

Namhyung's solution is to walk up the cgroup tree on cgroup switch
events. This may not be as efficient as rstat flush logic, but I think it
is good enough for many use cases (unless the cgroup tree is very
deep). It also demonstrates how we can implement some cgroup
logic in BPF.

I hope this helps.

Thanks,
Song

[...]
