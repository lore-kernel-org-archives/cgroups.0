From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 00/12] bpf: Introduce selectable memcg for bpf map
Date: Fri, 19 Aug 2022 09:09:25 +0800
Message-ID: <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com> <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=a+4YJ1LhJSNyK/sLr7JdvqPtNEtaZ4Z5AzpDGJs51kw=;
        b=h+9pelx8eiiyd0IkVd1BlXhfKkkVTdikoxVEKKTeMkhxIYLKe9yfAYzjs4f1ZmtKrU
         AoIO1SoacdD8rFz8JbEeRcVXK+nyPNnmo9MuTYvBPQi0wq1e2UIUwVL+wNpCpTvqPBvw
         6HiikZi3QWNvcmRMnTEuua2YNoKu0s2gQqiqh+E/IH+HSL8s7GbQtAnN9kQPx1uZxF/n
         g/1vQg5vuVOfW/XT0wbQtQ148FtewpbQ3dV/NKwl+wU0yzni5gqS2EpN1SuhoQAUNx6v
         sBY81kKYi4HXys1m7OQpV6+gybAhuqRD1NmMJZ9kgHuwLGW/vdVmmBGbEw4Wk5QYRd6p
         uoMA==
In-Reply-To: <Yv6+HlEzpNy8y5kT-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, john fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, Aug 19, 2022 at 6:33 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Thu, Aug 18, 2022 at 12:20:33PM -1000, Tejun Heo wrote:
> > We have the exact same problem for any resources which span multiple
> > instances of a service including page cache, tmpfs instances and any other
> > thing which can persist longer than procss life time. My current opinion is
>
> To expand a bit more on this point, once we start including page cache and
> tmpfs, we now get entangled with memory reclaim which then brings in IO and
> not-yet-but-eventually CPU usage.

Introduce-a-new-layer vs introduce-a-new-cgroup, which one is more overhead?

> Once you start splitting the tree like
> you're suggesting here, all those will break down and now we have to worry
> about how to split resource accounting and control for the same entities
> across two split branches of the tree, which doesn't really make any sense.
>

The k8s has already been broken thanks to the memcg accounting on  bpf memory.
If you ignored it, I paste it below.
[0]"1. The memory usage is not consistent between the first generation and
new generations."

This issue will persist even if you introduce a new layer.

> So, we *really* don't wanna paint ourselves into that kind of a corner. This
> is a dead-end. Please ditch it.
>

It makes non-sensen to ditch it.
Because, the hierarchy I described in the commit log is *one* use case
of the selectable memcg, but not *the only one* use case of it. If you
dislike that hierarchy, I will remove it to avoid misleading you.

Even if you introduce a new layer, you still need the selectable memcg.
For example, to avoid the issue I described in [0],  you still need to
charge to the parent cgroup instead of the current cgroup.

That's why I described in the commit log that the selectable memcg is flexible.

-- 
Regards
Yafang
