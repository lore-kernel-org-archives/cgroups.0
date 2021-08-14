From: yong w <yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1] mm: Add configuration to control whether vmpressure
 notifier is enabled
Date: Sat, 14 Aug 2021 16:00:59 +0800
Message-ID: <CAOH5QeDgyDfN2knD+HnfyvOQNbM_9Hz_i98BXF5LqNB33rd+Tw@mail.gmail.com>
References: <1628855870-5070-1-git-send-email-wang.yong12@zte.com.cn> <YRZnMYCN1ArhM3wE@chrisdown.name>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=M8zJWAK5zC502WBtr9TH/CUwQWjnvyStpDdJfvN9iH0=;
        b=nPEBvsm7bss9sW336uGhK2zgsPOoD4EhEfZqf8Z/GnAuZNvLXdGSvRYOfAdT0xbi+k
         MJL0JMED69nRCQZwCX2pLkomk7h0kKRwvDLM16ZeGiZrVwv+v0NbKYq9ewPu1SBx/FSk
         MMUf83twUNvZAL2GCzKiuo5v2Guxz+Xvr3swmLghVitINcXMKbKE8cbB3C3pitekzJlt
         iJMrxMT/2BeNod7KDbQt8Whd0QkAwS743hY1dIDppZhM/KfyrEC0uGEJqR94nKoRdxxX
         tYwrTq/IMmvRytbitlHcSyjHCXwP0xsnTnNZ2GeG6nV1rTNZwewsAJmAzkixM2KQj/ek
         IvoQ==
In-Reply-To: <YRZnMYCN1ArhM3wE-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, guro-b10kYP2dOMg@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sh_def-9Onoh4P/yGk@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org

Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> =E4=BA=8E2021=E5=B9=B48=E6=9C=8813=E6=97=
=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=888:36=E5=86=99=E9=81=93=EF=BC=9A
>
> yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org writes:
> >From: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> >Inspired by PSI features, vmpressure inotifier function should also be
> >configured to decide whether it is used, because it is an independent
> >feature which notifies the user of memory pressure.
> >
> >Since the vmpressure interface is used in kernel common code, for
> >users who do not use the vmpressure function, there will be
> >additional overhead.
>
> Could you please demonstrate this additional overhead with profiles or
> demonstrations of other real world effects? Thanks.

Thanks for your reply. In terms of code, it will reduce the operation
of some code.

To  demonstrate this additional overhead, It is planned to use lmbench and
Christoph Lamenter=E2=80=99s pagefault tool  (https://lkml.org/lkml/2006/8/=
29/294)
for comparative testing.

Thanks.
