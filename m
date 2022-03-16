From: Song Liu <song@kernel.org>
Subject: Re: [RFC bpf-next] Hierarchical Cgroup Stats Collection Using BPF
Date: Tue, 15 Mar 2022 23:04:56 -0700
Message-ID: <CAPhsuW5qHSZNSEh8CQK3wYqtJ4XB+EwFEJWKA9SkA+wGFbvNCg@mail.gmail.com>
References: <CAJD7tkbQNpeX8MGw9dXa5gi6am=VNXwgwUoTd6+K=foixEm1fw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647410708;
        bh=9u56X5trjDPRUeXIbiXX2WgWMHiQeCwaMD920ZfRi8s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kc/I2DRyrHvrgXU4oXkzFIkF9sFInZFOl+OfPblLYNxgfZbu4INP1YHZgxKSlgVTY
         jOZ+3aH9aLNfZLH8TSfxhdoz2+IRoL9KQWru0qiP3xt8Bd3N3XBDQF9mWN8KsDteTB
         SGwlr1EtPeo1r9XqiLJnBiZs2nysC41wMtI7VoOaN7BtI6CYW4DRuRoP/lp1vNfpKk
         yJccTxZdroLG7a8zFUBdTbVUgQQab2HUgS3gX5MTK0lCEGF/w6CYMEbG9rUmPOaAFL
         lP8OJpOfAbyNXEzqw5Mo2NzyRCY+rzAZzc3/39F0eaLDUWvFTEpHCClOPC+D0zjfnu
         UD4RFJxxNoc8Q==
In-Reply-To: <CAJD7tkbQNpeX8MGw9dXa5gi6am=VNXwgwUoTd6+K=foixEm1fw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Johannes Weiner <hannes@cmpxchg.org>, Hao Luo <haoluo@google.com>, Shakeel Butt <shakeelb@google.com>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, bpf <bpf@vger.kernel.org>, KP Singh <kpsingh@kernel.org>, cgroups@vger.kernel.org, Linux-MM <linux-mm@kvack.org>

On Wed, Mar 9, 2022 at 12:27 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
[...]
>
> The map usage by BPF programs and integration with rstat can be as follows:
> - Internally, each map entry has per-cpu arrays, a total array, and a
> pending array. BPF programs and user space only see one array.
> - The update interface is disabled. BPF programs use helpers to modify
> elements. Internally, the modifications are made to per-cpu arrays,
> and invoke a call to cgroup_bpf_updated()  or an equivalent.
> - Lookups (from BPF programs or user space) invoke an rstat flush and
> read from the total array.

Lookups invoke a rstat flush, so we still walk every node of a subtree for
each lookup, no? So the actual cost should be similar than walking the
subtree with some BPF program? Did I miss something?

Thanks,
Song

> - In cgroup_rstat_flush_locked() flush BPF stats as well.
>
[...]
