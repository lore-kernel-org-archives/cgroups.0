From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 2/3] cgroup: add cgroup_all_get_from_[fd/file]()
Date: Mon, 10 Oct 2022 17:14:24 -0700
Message-ID: <CAJD7tkbDNqxE+bYQvo5YAbK01qz7UVd-s6bOf==Ao44bmNsk=Q@mail.gmail.com>
References: <20221010235845.3379019-1-yosryahmed@google.com>
 <20221010235845.3379019-3-yosryahmed@google.com> <Y0S0nFSyivpU4H0n@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5R0pinv45UAtKlsTkuyPxf0dfiwVu4saizyc4kXh9wE=;
        b=lGfVgp1V/sLVfhecIm+c3tVUQ/aewnQG+QaeaREAG03T7IfKe5Wj51TVbaJb0DEGfO
         P2/Wy1LvPnCEec4RYlwpoXU+cJjY55Ec22YsKV6eYGCaDYhGuy6QSOfT3Su2fMY1zuoS
         RHn+76zhnLPjuj8OvtNqmpkEJjsv3jYGeV492h5EDtL6dSFatrjP/EvAxWKbGRKs2qlT
         GKHFFBsAC2BF229tBT/fd1E448SyoC90xpjOLt/ignQoxHEZsYPTkQTLcgdGagMw4TNm
         XvlxgbbaSspLvA7HxxaSKLJOnhoP9PgZkTL/aGXyottUjVcnIiKlGA4oJbhkuJOuTjFN
         YdZg==
In-Reply-To: <Y0S0nFSyivpU4H0n-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 10, 2022 at 5:11 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Mon, Oct 10, 2022 at 11:58:44PM +0000, Yosry Ahmed wrote:
> > Add cgroup_all_get_from_fd() and cgroup_all_get_from_file() that
> > support both cgroup1 and cgroup2.
>
> Looks generally good. How about cgroup_v1v2_ as the prefix?

Thanks for taking a look.

I don't have a strong opinion here. I picked cgroup_all_* vs
cgroup12_* or cgroup_v1v2_* because it's easier on the eyes.

My preference would have been to rename the old versions to
cgroup_dfl_* instead, but like you said this might confuse existing
users.

Anyway, I am fine with whatever you choose. Let me know if you need me
to send a v2 for changing the prefix.

>
> Thanks.
>
> --
> tejun
