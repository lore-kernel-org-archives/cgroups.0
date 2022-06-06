From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH bpf-next v1 0/5] bpf: rstat: cgroup hierarchical stats
Date: Mon, 6 Jun 2022 14:32:09 +0200
Message-ID: <20220606123209.GE6928@blackbody.suse.cz>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220603162247.GC16134@blackbody.suse.cz>
 <CAJD7tkbp9Tw4oGtxsnHQB+5VZHMFa4J0qvJGRyj3VuuQ4UPF=g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654518731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QmnQvelulN9ISJl++c1aKnCaY5Y/JjxqU7vIBDvzm3w=;
        b=MwHhGVS1WO72E8CSbOvvz7pMIKubeYL4Ju+e8htY06tSlEPcNG9Ywrq92+6BEYUlqG3M1C
        68EmP9B6vOmAU4fTcCbXDh8q1bnGbCeY9LnC3kV2HxIYSs5qB5XmUqeb8zI7AvhBKgnH4z
        /P+WXycLAm7EQ5lm1ROAwJhKcDHvrNs=
Content-Disposition: inline
In-Reply-To: <CAJD7tkbp9Tw4oGtxsnHQB+5VZHMFa4J0qvJGRyj3VuuQ4UPF=g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jun 03, 2022 at 12:47:19PM -0700, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> In short, think of these bpf maps as equivalents to "struct
> memcg_vmstats" and "struct memcg_vmstats_percpu" in the memory
> controller. They are just containers to store the stats in, they do
> not have any subgraph structure and they have no use beyond storing
> percpu and total stats.

Thanks for the explanation.

> I run small microbenchmarks that are not worth posting, they compared
> the latency of bpf stats collection vs. in-kernel code that adds stats
> to struct memcg_vmstats[_percpu] and flushes them accordingly, the
> difference was marginal.

OK, that's a reasonable comparison.

> The main reason for this is to provide data in a similar fashion to
> cgroupfs, in text file per-cgroup. I will include this clearly in the
> next cover message.

Thanks, it'd be great to have that use-case captured there.

> AFAIK loading bpf programs requires a privileged user, so someone has
> to approve such a program. Am I missing something?

A sysctl unprivileged_bpf_disabled somehow stuck in my head. But as I
wrote, this adds a way how to call cgroup_rstat_updated() directly, it's
not reserved for privilged users anyhow.

> bpf_iter_run_prog() is used to run bpf iterator programs, and it grabs
> rcu read lock before doing so. So AFAICT we are good on that front.

Thanks for the clarification.


Michal
