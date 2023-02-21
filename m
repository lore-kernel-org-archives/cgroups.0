From: Martin Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Wed, 22 Feb 2023 01:00:00 +0800
Message-ID: <CADfL_jBSMyi_19qHHuai910L0eu+gq7aV9YEDV5fqB8XfBZ7HA@mail.gmail.com>
References: <20230220151638.1371-1-findns94@gmail.com> <Y/PhmEPc/qYeZ52T@P9FQF9L96D>
 <20230220230624.lkobqeagycx7bi7p@google.com> <Y/SAHfHsljuIRBJm@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676998853;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bzbHZtMVTbCokAydXsy5m0utnYmreRbdGfN2F9U7y6M=;
        b=QzL49iKVV0NXrLXOI5t613DcnDYuBlQessXmxJP1FHor/KKL06T6K+7pamcGPiPvdk
         jTOq5b6Skaz5NR4hmdR8cAIK4lxfvrD+PpynxhvhWugv9jZ6gjQdDSNqUe4r40WbI1CR
         gybjHq52mP/3r122fbF+exWScCx3lGh1pJplnRnsQ/2ySBZ50qRGQlB2eIo4hYB/Loui
         vLRm653Vww0sbcX56Xvt/KmMhWWD6GwyAJoOvmB/mYV5NtTecohDHu7okcPKyBtKrWv+
         4CaUnNZNvl/3t8wb+xqXiUmfVVv39CFp7YcCq02AQghG9WCkViwrI+WuYQyYDMRbA/Lv
         k5Gw==
In-Reply-To: <Y/SAHfHsljuIRBJm-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Tue, Feb 21, 2023 at 4:26 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 20-02-23 23:06:24, Shakeel Butt wrote:
> > On Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushchin wrote:
> > > On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
> > > > The knob for cgroup v2 memory controller: memory.oom.group
> > > > will be read and written simultaneously by user space
> > > > programs, thus we'd better change memcg->oom_group access
> > > > with atomic operations to avoid concurrency problems.
> > > >
> > > > Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > >
> > > Hi Yue!
> > >
> > > I'm curious, have any seen any real issues which your patch is solving?
> > > Can you, please, provide a bit more details.
> > >
> >
> > IMHO such details are not needed. oom_group is being accessed
> > concurrently and one of them can be a write access. At least
> > READ_ONCE/WRITE_ONCE is needed here. Most probably syzbot didn't
> > catch this race because it does not know about the memory.oom.group
> > interface.
>
> I do agree with Roman here. It is _always_ good to mention whether this
> is a tool/review or actual bug triggered fix. Also {READ,WRITE}_ONCE doesn't
> guarantee atomicity so it would be good to rephrase the changelog.
> Something like:
> The knob for cgroup v2 memory controller: memory.oom.group
> is not protected by any locking so it can be modified while it is used.
> This is not an actual problem because races are unlikely (the knob is
> usually configured long before any workloads hits actual memcg oom)
> but it is better to use READ_ONCE/WRITE_ONCE to prevent compiler from
> doing anything funky.

Thanks a lot, I will rephrase and update my patch later.

>
> This patch is not fixing any actual user visible bug but it is in line
> of a standard practice.
> --
> Michal Hocko
> SUSE Labs
