From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/3] mm/memcg: Simplify mem_cgroup_get_max()
Date: Mon, 14 Sep 2020 08:36:56 -0700
Message-ID: <CALvZod58vQ3hQAAwT8=7MO9-Xvnb=Fms37E0gW-qT746gS54uw@mail.gmail.com>
References: <20200914024452.19167-1-longman@redhat.com> <20200914150928.7841-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mzx2NgkB1nDMETbz5EDQ8LndFJVrNLUdv8ics0I+18I=;
        b=Afg6QaB+BSz1GeEiUUoLpaauFp1bmrgB23nL8XxTsNnVonXaOkJFrJd6jdtjqTM1E2
         7JlIwQwEe60FXwjMxUkjaSxnOKit5jPzs29jiYrCp0OR+JKTLAZo2LshQdwhiYtmKoC8
         WdYvMRlhRTD1XtrcSb9ed/dvOLW8xcU2pbsNRaRZCUaWe5ylREbLDrsLZAWV5/qDGTtF
         8tAyWxeapw0IfCZ42u/fmSTmHadUVsc2vCUD+EZtcKzXLTyAwFLHIzvaf/tr6Jml2BQF
         yU66ii6gQB4gOrHvnkv3KMBogvEKNyK99/NQLkPQtMVgWL47x9DfvCXSLlzYAOF6WuxX
         bPlg==
In-Reply-To: <20200914150928.7841-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Sep 14, 2020 at 8:09 AM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> The mem_cgroup_get_max() function used to get memory+swap max from
> both the v1 memsw and v2 memory+swap page counters & return the maximum
> of these 2 values. This is redundant and it is more efficient to just
> get either the v1 or the v2 values depending on which one is currently
> in use.
>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
