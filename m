From: yulei zhang <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/7] Introduce memory allocation speed throttle in memcg
Date: Fri, 4 Jun 2021 18:15:02 +0800
Message-ID: <CACZOiM03toiqcbtEd8LT26T2GtPsDaFj89o8rjEfELTw=KPvfg@mail.gmail.com>
References: <cover.1622043596.git.yuleixzhang@tencent.com> <CALvZod4SoCS6ym8ELTxWd6UwzUp8m_UUdw7oApAhW2WRq0BXqw@mail.gmail.com>
 <CACZOiM3VhYyzCTx4FbW=FF8WB=X46xaV53abqOVL+eHQOs8Reg@mail.gmail.com>
 <YLZIBpJFkKNBCg2X@chrisdown.name> <CACZOiM21STLrZgcnEwm8w2t82Qj3Ohy-BGbD5u62gTn=z4X3Lw@mail.gmail.com>
 <CALvZod7w1tzxvYCP54KHEo=k=qUd02UTkr+1+b5rTdn-tJt45w@mail.gmail.com>
 <CACZOiM3g6GhJgXurMPeE3A7zO8eUhoUPyUvyT3p2Kw98WkX8+g@mail.gmail.com> <YLi/UeS71mk12VZ3@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kXNZFynTVd7Tj+4yCTxPtCHUxkYVTA9YmlhLOcTv9i4=;
        b=dEDQHphBkeNVUUe/39lXpjzvRnF/sgMO3KCzRZcCyvEN5dcy6fameRkVnBdx5YMW9D
         F6S17iSrJMCDdY4PEat3HygCOzxMJQUYE/xZ2V/31MxzglUH8ATcba4Wj7BCxrlk3/jQ
         4lyIvJ8ao3l5q7NZQ0+z3C75iW9wobbdtOaZMNvT5RZUZHHiJbfREJoKWO8l8fdtUoNj
         0e8htveobhzcJ9iNG7nf6DYSY1sLMYNsnMcKkmxFHcMAdf6vUFLNau2pGGAjLegxisJQ
         K6Ai+UdGN9nQ8bh2lXQnzZaqMyDvE74QJXHgzVIbAcJsNQSFQ6Gh57SZPaBHxS/KBBxr
         fRvQ==
In-Reply-To: <YLi/UeS71mk12VZ3-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Wanpeng Li <kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Thu, Jun 3, 2021 at 7:38 PM Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
>
> yulei zhang writes:
> >Thanks. IMHO, there are differences between these two throttlings.
> >memory.high is a per-memcg throttle which targets to limit the memory
> >usage of the tasks in the cgroup. For the memory allocation speed throttle(MST),
> >the purpose is to avoid the memory burst in cgroup which would trigger
> >the global reclaim and affects the timing sensitive workloads in other cgroup.
> >For example, we have two pods with memory overcommit enabled, one includes
> >online tasks and the other has offline tasks, if we restrict the memory usage of
> >the offline pod with memory.high, it will lose the benefit of memory overcommit
> >when the other workloads are idle. On the other hand, if we don't
> >limit the memory
> >usage, it will easily break the system watermark when there suddenly has massive
> >memory operations. If enable MST in this case, we will be able to
> >avoid the direct
> >reclaim and leverage the overcommit.
>
> Having a speed throttle is a very primitive knob: it's hard to know what the
> correct values are for a user. That's one of the reasons why we've moved away
> from that kind of tunable for blkio.
>
> Ultimately, if you want work-conserving behaviour, why not use memory.low?

Thanks. But currently low and high are for cgroup v2 setting, do you
think we'd better
extend the same mechanism to cgroup v1?
