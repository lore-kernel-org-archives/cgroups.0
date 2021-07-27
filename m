From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v7 05/10] memcg: enable accounting for new namesapces and
 struct nsproxy
Date: Tue, 27 Jul 2021 14:51:43 -0700
Message-ID: <CALvZod5tfepT51EgUVX_Xq=2UykpGehNE5K3+K12OCwymi=-vQ@mail.gmail.com>
References: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
 <cover.1627362057.git.vvs@virtuozzo.com> <5525bcbf-533e-da27-79b7-158686c64e13@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LklRqbXMTEN/3IOARnfGCTnT/yEZVFwCJFDMkmvyYVo=;
        b=AbNu22X3Nmx8X2h+2ik7T5v6bU+CsbYIGQapGfDjCY/3r1jS9dwjHMGAsireZtJIzA
         W6vzg/MECVRzb0M3CzcIvMUeqvE7OFHKjzUu9Vc8EciMK4M22Lalr1SoxpUWAdaS0jas
         trp6Y9wm5/8rQ99XmOCezferLz9rqJpSR4qHfjYjK/VTc3I7BOoBPi0fzC9EwTD/nYHV
         8dAu/luh9QT3BGhD0+VcybrhasaOcPPohqRydoP5y/Vo5wWXp7PD1EhvztG+D5sonifC
         yAelkaCCnK3W8KrUX9cPBHBrruaxk+BOade7OJ7ssi7N40oIgkFN4GjiGFhdx1Vp7uI1
         EVLQ==
In-Reply-To: <5525bcbf-533e-da27-79b7-158686c64e13@virtuozzo.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Thomas Gleixner <tglx@linutronix.de>, Christian Brauner <christian.brauner@ubuntu.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, Serge Hallyn <serge@hallyn.com>, Andrei Vagin <avagin@gmail.com>, LKML <linux-kernel@vger.kernel.org>

On Mon, Jul 26, 2021 at 10:33 PM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> Container admin can create new namespaces and force kernel to allocate
> up to several pages of memory for the namespaces and its associated
> structures.
> Net and uts namespaces have enabled accounting for such allocations.
> It makes sense to account for rest ones to restrict the host's memory
> consumption from inside the memcg-limited container.
>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
