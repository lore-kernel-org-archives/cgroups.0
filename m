From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Add swappiness argument to memory.reclaim
Date: Tue, 17 May 2022 11:06:36 -0700
Message-ID: <CAJD7tkYnBjuwQDzdeo6irHY=so-E8z=Kc_kZe52anMOmRL+8yA@mail.gmail.com>
References: <CAJD7tkbDpyoODveCsnaqBBMZEkDvshXJmNdbk51yKSNgD7aGdg@mail.gmail.com>
 <YoNHJwyjR7NJ5kG7@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f5miC2kWn/l2e0BUuAIeZlYgpjUY+Gi8Grdp3KqcrK8=;
        b=UXqcmaywsD5AB9IxCHPt0Uzp0QohHozlmtmz6BUjExY3c7FuVDvcAcFQPalL4lBncW
         HtxU2aNWgnohBNpUkXNy+DMO7+l8Aegg71l0oKsr2IbYmOXivgmCvqYeFrXCGjan04ps
         ZvtMyokVjpdqSs/XCEBXmjvND+xdFFHhS4+8FmNzP0sffxiidGouM1ciTVqvVK8lMe4I
         zEcOxXsXYwHSqvRi89rmltszgIXa2B2qqfRRhcat7Zq59yG6GNoXxAFvzvqtctcP9Mmp
         fIJIGOBXKWXzGaWOqzbGojB9SYCA0y6yoI2nss/O5wQvCxq6wXVn5a4cAlRTGeth+PyV
         Bkcg==
In-Reply-To: <YoNHJwyjR7NJ5kG7-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Mon, May 16, 2022 at 11:56 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 16-05-22 15:29:42, Yosry Ahmed wrote:
> > The discussions on the patch series [1] to add memory.reclaim has
> > shown that it is desirable to add an argument to control the type of
> > memory being reclaimed by invoked proactive reclaim using
> > memory.reclaim.
> >
> > I am proposing adding a swappiness optional argument to the interface.
> > If set, it overwrites vm.swappiness and per-memcg swappiness. This
> > provides a way to enforce user policy on a stateless per-reclaim
> > basis. We can make policy decisions to perform reclaim differently for
> > tasks of different app classes based on their individual QoS needs. It
> > also helps for use cases when particularly page cache is high and we
> > want to mainly hit that without swapping out.
>
> Can you be more specific about the usecase please? Also how do you

For example for a class of applications it may be known that
reclaiming one type of pages anon/file is more profitable or will
incur an overhead, based on userspace knowledge of the nature of the
app. If most of what an app use for example is anon/tmpfs then it
might be better to explicitly ask the kernel to reclaim anon, and to
avoid reclaiming file pages in order not to hurt the file cache
performance.

It could also be a less aggressive alternative to /proc/sys/vm/drop_caches.

> define the semantic? Behavior like vm_swappiness is rather vague because
> the kernel is free to ignore (and it does indeed) this knob in many
> situations. What is the expected behavior when user explicitly requests
> a certain swappiness?

My initial thoughts was to have the same behavior as vm_swappiness,
but stateless. If a user provides a swappiness value then we use it
instead of vm_swappiness. However, I am aware that the definition is
vague and there are no guarantees here, the only reason I proposed
swappiness vs. explicit type arguments (like the original RFC and
Roman's reply) is flexibility. It looks like explicit type arguments
would be more practical though. I will continue the discussion
replying to Roman.

> --
> Michal Hocko
> SUSE Labs
