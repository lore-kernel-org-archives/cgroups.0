From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: page_counter: mitigate consequences of a page_counter underflow
Date: Thu, 8 Apr 2021 09:24:45 -0700
Message-ID: <CALvZod4W+7_EZUmUQLoz-9-C2LeMtqbdvFxK31m4qV6qHOrejQ@mail.gmail.com>
References: <20210408143155.2679744-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OhP7GymXFSKtZlfnt0/yi6SF4MHiLfNobLLfZttkPNg=;
        b=pNP3+nw0beqqrktG7Qie1dyDV4VmIMTq0UwmxM/5Sy5GbRLRfwgh+YWj0pIv0+jMw9
         9WCqIIzsivso6CM/3M1eM/MyxDQaZtoRm3iZj8GpXZGLq6USw578MYrsIwfXNlFIulIW
         +n/4hMXYlP5tphCL1r7xo3d4yFIedzoQ0a+4oFS8tmLcnsC0sIEBa1ZY7vW5CXPGFLzJ
         XiT4U5W3LAeXk/7KXilNkSqdc/gXcnKNG6GNEyGR/lbZJB1QcGjyTjAad7FcLS7ZJMWB
         4RMNOqfrgOqnCQ/w7oNhEe3XoBeJqmHp2rYfhs3bNxY8mlIWL6O4nxCOB7PN7PhBZgbM
         XaBg==
In-Reply-To: <20210408143155.2679744-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Thu, Apr 8, 2021 at 7:31 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> When the unsigned page_counter underflows, even just by a few pages, a
> cgroup will not be able to run anything afterwards and trigger the OOM
> killer in a loop.
>
> Underflows shouldn't happen, but when they do in practice, we may just
> be off by a small amount that doesn't interfere with the normal
> operation - consequences don't need to be that dire.
>
> Reset the page_counter to 0 upon underflow. We'll issue a warning that
> the accounting will be off and then try to keep limping along.
>
> [ We used to do this with the original res_counter, where it was a
>   more straight-forward correction inside the spinlock section. I
>   didn't carry it forward into the lockless page counters for
>   simplicity, but it turns out this is quite useful in practice. ]
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
