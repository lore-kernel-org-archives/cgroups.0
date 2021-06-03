From: yulei zhang <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/7] Introduce memory allocation speed throttle in memcg
Date: Thu, 3 Jun 2021 18:19:18 +0800
Message-ID: <CACZOiM3g6GhJgXurMPeE3A7zO8eUhoUPyUvyT3p2Kw98WkX8+g@mail.gmail.com>
References: <cover.1622043596.git.yuleixzhang@tencent.com> <CALvZod4SoCS6ym8ELTxWd6UwzUp8m_UUdw7oApAhW2WRq0BXqw@mail.gmail.com>
 <CACZOiM3VhYyzCTx4FbW=FF8WB=X46xaV53abqOVL+eHQOs8Reg@mail.gmail.com>
 <YLZIBpJFkKNBCg2X@chrisdown.name> <CACZOiM21STLrZgcnEwm8w2t82Qj3Ohy-BGbD5u62gTn=z4X3Lw@mail.gmail.com>
 <CALvZod7w1tzxvYCP54KHEo=k=qUd02UTkr+1+b5rTdn-tJt45w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6RNWFHjnK95WvTFB33SdSxX9jSbolNBF1nLUGKTdCNQ=;
        b=jF+aXbEyX05XO3P7/FYCOozuLw09MHxAlxMp9y0xUT5WS5Sl5zBKk6ndg8Dzvmwxn4
         0R0MrBJrEkfpDnnEMEUCH66SjMuvRwBvxCI62/0C19KDtXmexOMCXpS5cDpbT90O9jep
         87qA24eUczfRMT6kiKYDCFb39Kw29iLJzn8k5O36SR4j/NQq0ODZlwj27jWfyqqldqz2
         hNGkhrLTf7bplojEx5pTL+HDi6NZsJcJ+WMCX5LSLz/osvmuGaZ4+/eOQKqvDuURYX36
         f0iSR6wNaH62+K8S4DpimTW/uDPObdY+Q2mxWIq5JN9taHqJcnl8uqJjj364DLaE47FS
         IWaQ==
In-Reply-To: <CALvZod7w1tzxvYCP54KHEo=k=qUd02UTkr+1+b5rTdn-tJt45w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Wanpeng Li <kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Wed, Jun 2, 2021 at 11:39 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, Jun 2, 2021 at 2:11 AM yulei zhang <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Tue, Jun 1, 2021 at 10:45 PM Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
> > >
> > > yulei zhang writes:
> > > >Yep, dynamically adjust the memory.high limits can ease the memory pressure
> > > >and postpone the global reclaim, but it can easily trigger the oom in
> > > >the cgroups,
> > >
> > > To go further on Shakeel's point, which I agree with, memory.high should
> > > _never_ result in memcg OOM. Even if the limit is breached dramatically, we
> > > don't OOM the cgroup. If you have a demonstration of memory.high resulting in
> > > cgroup-level OOM kills in recent kernels, then that needs to be provided. :-)
> >
> > You are right, I mistook it for max. Shakeel means the throttling
> > during context switch
> > which uses memory.high as threshold to calculate the sleep time.
> > Currently it only applies
> > to cgroupv2.  In this patchset we explore another idea to throttle the
> > memory usage, which
> > rely on setting an average allocation speed in memcg. We hope to
> > suppress the memory
> > usage in low priority cgroups when it reaches the system watermark and
> > still keep the activities
> > alive.
>
> I think you need to make the case: why should we add one more form of
> throttling? Basically why memory.high is not good for your use-case
> and the proposed solution works better. Though IMO it would be a hard
> sell.

Thanks. IMHO, there are differences between these two throttlings.
memory.high is a per-memcg throttle which targets to limit the memory
usage of the tasks in the cgroup. For the memory allocation speed throttle(MST),
the purpose is to avoid the memory burst in cgroup which would trigger
the global reclaim and affects the timing sensitive workloads in other cgroup.
For example, we have two pods with memory overcommit enabled, one includes
online tasks and the other has offline tasks, if we restrict the memory usage of
the offline pod with memory.high, it will lose the benefit of memory overcommit
when the other workloads are idle. On the other hand, if we don't
limit the memory
usage, it will easily break the system watermark when there suddenly has massive
memory operations. If enable MST in this case, we will be able to
avoid the direct
reclaim and leverage the overcommit.
.
