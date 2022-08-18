From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH bpf-next v2 01/12] cgroup: Update the comment on cgroup_get_from_fd
Date: Thu, 18 Aug 2022 12:11:16 -0700
Message-ID: <CAJD7tkYGt9ej3ROWGAgG+9HFAN3fweRMtG9o+uhedJLRbUpFLA@mail.gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com> <20220818143118.17733-2-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UEM6xwL26wno309XpbhDNsg9frqzMJCiGi3REZwC0DM=;
        b=HeuOsZXmNcXgVKTTXFFcFjO113/PnINlhnItAs7AitwtBI6uKfgSxZnr23iW0cMQ2M
         qZe5Ce1QmdbYgYvOlxhFBGOL/XnFM1ot3f/gUC9tGtsFq2ysv1zb0hN0ysTow1YwW1JX
         FuQuCP1EjHzCbuuNrOvH8G45xwsXBGVar6TbfD2jxxryv0ItRyejdDxEdWv9ZetRjXZR
         i172u1ZhOfBz2fUdp4o/FFoOhkl/Ngb1Fs1BZcP8urMghqdSkkX+KEtVyclANwItuExU
         EVBDKeMoatrTl6DzQGsx4Kvzmt3UwBquZAlu99FB2BTx9Rrpf2tToJaAyg9pJbxAN0/T
         eRTA==
In-Reply-To: <20220818143118.17733-2-laoar.shao@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, john fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Cgroups <cgroups@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vge>

On Thu, Aug 18, 2022 at 7:31 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> After commit f3a2aebdd6fb ("cgroup: enable cgroup_get_from_file() on cgroup1")
> we can open a cgroup1 dir as well. So let's update the comment.

I missed updating the comment in my change. Thanks for catching this.

>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Cc: Hao Luo <haoluo@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  kernel/cgroup/cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 5f4502a..b7d2e55 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6625,7 +6625,7 @@ struct cgroup *cgroup_get_from_path(const char *path)
>
>  /**
>   * cgroup_get_from_fd - get a cgroup pointer from a fd
> - * @fd: fd obtained by open(cgroup2_dir)
> + * @fd: fd obtained by open(cgroup_dir)
>   *
>   * Find the cgroup from a fd which should be obtained
>   * by opening a cgroup directory.  Returns a pointer to the
> --
> 1.8.3.1
>
