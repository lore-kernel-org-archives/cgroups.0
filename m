From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] mm/memcg: Clean up obsolete enum charge_type
Date: Thu, 20 Aug 2020 14:16:59 -0700
Message-ID: <CALvZod7=aENT98Lrm6UvDnUrtG8ZT5FosUNb=+EmCkZag3=8GA@mail.gmail.com>
References: <20200820130350.3211-1-longman@redhat.com> <20200820130350.3211-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dhaGrKUZGrplU3FJ6j8umgFZML1T4Qnjaml2sZz9odo=;
        b=ZuKqiQ3xaX3Lfh2PTU894rP8VOkqmdcx27cCOxnOBt7xEFAEjJ3CC+ln9bLTpy1WsS
         yTEtdUEhIi4Pea02zFDTl3ALkkvTjqUWMzXNZ27pIiYWx6639XGiDITdyKKBsKFk6WzV
         4T+Vrvw7laL+WCnbgP38MWDiqXy3tS1pSiGWzbDlvNJU0rOgM6+rqQf2Zsi8qxF+nezl
         yl0Qn5djgLqI+x4v39W8REzYFed8KfpkMY3tBiFZ3HIPBGmxHylg70foADv47+UiJqzG
         UK5kl+J9T4QE48lfZ5x5QZOXuJoapDUsHiQaoneEpuMBzXrlRbgMZKaIQN7LPkErMG7P
         TQaw==
In-Reply-To: <20200820130350.3211-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Aug 20, 2020 at 6:04 AM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Since commit 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API") and
> commit 00501b531c47 ("mm: memcontrol: rewrite charge API") in v3.17, the
> enum charge_type was no longer used anywhere. However, the enum itself
> was not removed at that time. Remove the obsolete enum charge_type now.
>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
