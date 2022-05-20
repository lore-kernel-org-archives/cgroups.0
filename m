From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
Date: Fri, 20 May 2022 02:13:03 -0700
Message-ID: <CAJD7tkYDLc9irHLFROcYSg1shwCw+Stt5HTS08FW3ceQ5b8vqQ@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com> <YodCPWqZodr7Shnj@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jKOS1vGID3J/FbD4HTDSZ/zk/t5PNErFudLDsYqbEjw=;
        b=eDW10/xIZg8sKzudeh/BQlWYLaGFZPTtoK3i1FcF+DsZPu/Efolmt5EniRfWlxNt0U
         1E5gvYAaXaVKbbbLyyZb2ZO39bU4ZOxFU3e2Ym62AKSjgXikXJhtQhGwqCVuFX44ejAd
         J4UmnsgvvSAb7eGxKalw2dogjSyRPfi6njZRCzVXqWmzyEB6jXIs94KOiRVbBqj4aLEk
         0MiGWxbyjTLm5IQQ6Y0UeFAN1GaH6hBiKI6NxT3uwI8kst31koBe3moFLywILByhvGqB
         8oED5ZAcd0gKNKtzQw4OvyR4foQ+7pqiTGoq0HEA/+WCZ+AwzGkTtA08XRS7ALuhVWrP
         LaiQ==
In-Reply-To: <YodCPWqZodr7Shnj-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 20, 2022 at 12:24 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Fri, May 20, 2022 at 01:21:30AM +0000, Yosry Ahmed wrote:
> > Add cgroup_rstat_updated() and cgroup_rstat_flush() kfuncs to bpf
> > tracing programs. bpf programs that make use of rstat can use these
> > functions to inform rstat when they update stats for a cgroup, and when
> > they need to flush the stats.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Do patch 1 and 2 need to be separate? Also, can you explain and comment why
> it's __weak?

I will squash them in the next version.

As for the declaration, I took the __weak annotation from Alexei's
reply to the previous version. I thought it had something to do with
how fentry progs attach to functions with BTF and all.
When I try the same code with a static noinline declaration instead,
fentry attachment fails to find the BTF type ID of bpf_rstat_flush.
When I try it with just noinline (without __weak), the fentry program
attaches, but is never invoked. I tried looking at the attach code but
I couldn't figure out why this happens.

In retrospect, I should have given this more thought. It would be
great if Alexei could shed some light on this.

>
> Thanks.


>
> --
> tejun
