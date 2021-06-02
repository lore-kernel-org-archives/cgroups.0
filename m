From: yulei zhang <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/7] Introduce memory allocation speed throttle in memcg
Date: Wed, 2 Jun 2021 17:11:32 +0800
Message-ID: <CACZOiM21STLrZgcnEwm8w2t82Qj3Ohy-BGbD5u62gTn=z4X3Lw@mail.gmail.com>
References: <cover.1622043596.git.yuleixzhang@tencent.com> <CALvZod4SoCS6ym8ELTxWd6UwzUp8m_UUdw7oApAhW2WRq0BXqw@mail.gmail.com>
 <CACZOiM3VhYyzCTx4FbW=FF8WB=X46xaV53abqOVL+eHQOs8Reg@mail.gmail.com> <YLZIBpJFkKNBCg2X@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jiAxINQdIi7+HKRfHkFG9l2vkzASih/fGHAjPl9o30o=;
        b=Lfml9qG8E5om9EGGt1K9NrtEPh3JmhHemfh/T9ecn4hRxiACaf+qtqZDkwaOb9trMG
         ixX+y+wRuf9EwKeYGeMFgWmTx4j4EFKRvSYA0T9z4yZrOudlee98LFKNYwrCY3zjbdkC
         yQQQEGXE9yiZwWEN3sZma/nlj+w6IZ+I+qQMga77fgthsNu9DMlV21wJIUt5FhABt4JQ
         8HcqQe7gyou6nJbv/rShsG5Mf/3ioXoGQkS3DDgwQ54l46DBN0WZbM8JMiodb55t0ppq
         I9dFPFDNvA7BTLTCQVG/Q3qItNTBfcihwoRp5Zum/8gMvXIPSUYGLALNE+vB3aSk88YP
         KodA==
In-Reply-To: <YLZIBpJFkKNBCg2X-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Wanpeng Li <kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Tue, Jun 1, 2021 at 10:45 PM Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
>
> yulei zhang writes:
> >Yep, dynamically adjust the memory.high limits can ease the memory pressure
> >and postpone the global reclaim, but it can easily trigger the oom in
> >the cgroups,
>
> To go further on Shakeel's point, which I agree with, memory.high should
> _never_ result in memcg OOM. Even if the limit is breached dramatically, we
> don't OOM the cgroup. If you have a demonstration of memory.high resulting in
> cgroup-level OOM kills in recent kernels, then that needs to be provided. :-)

You are right, I mistook it for max. Shakeel means the throttling
during context switch
which uses memory.high as threshold to calculate the sleep time.
Currently it only applies
to cgroupv2.  In this patchset we explore another idea to throttle the
memory usage, which
rely on setting an average allocation speed in memcg. We hope to
suppress the memory
usage in low priority cgroups when it reaches the system watermark and
still keep the activities
alive.
