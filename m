From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: BUG: KASAN: null-ptr-deref in workingset_eviction+0xf2/0x1e0
Date: Tue, 1 Dec 2020 16:53:45 +0800
Message-ID: <CAMZfGtUQMmH566CTT2G0KugLsX_3ouOM_80Kqk1R6b1N_NGB-Q@mail.gmail.com>
References: <CA+G9fYtk3fKy7ct-rT=T8iFDhE4CbjGgdfxsOBrKT9y8ntwXyg@mail.gmail.com>
 <CAA5enKbujU+PRwA3qeYqx-Ydcj7owJnYkeTYJFdBweQJjWU78w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=niYaq/JRpKzB99MWM85q+70GJ2PSdrtB0S69IuuZNQw=;
        b=l0RgZkr/ooILtuQNf9RcVw8IoO2KP6POtGiNC/rcv5cNIRvSz9UPSEkkRN0q+ZduaQ
         pssQKPNZ79aC1+B83P54e2Du+lK6TMRWg2ZzIffub/R03C3mnsN5LA6VxjJi/J+PwSy8
         WwZ9X65aTRsj2ulLLDCFKXrkRHOMW/0yeb73X6TKbhFdHdcGOrnGcRQlnGlbAbbFViS7
         xEVIDudge5yRqV3e07lfxvmIVeoLZz9srEH1gVzQZV5yEiAweAq51wOv6eWi5nrDrs8h
         w8syYqUaaQ7WUfaRxU23EvFdAb4k0gTz0F8YDslH7Qwv4VHnGzCL+z0jvKcZyjCOtUmh
         4bjA==
In-Reply-To: <CAA5enKbujU+PRwA3qeYqx-Ydcj7owJnYkeTYJFdBweQJjWU78w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lorenzo Stoakes <lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, inux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkft-triage-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, richard.weiyang-Re5JQEeQqe8@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

On Tue, Dec 1, 2020 at 4:02 AM Lorenzo Stoakes <lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Mon, 30 Nov 2020 at 19:52, Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > [  285.863025] BUG: kernel NULL pointer dereference, address: 00000000000000c8
>
> This looks to be the same as
> https://lore.kernel.org/linux-mm/20201130132345.GJ17338-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org/T/#t

I am sure it is the same issue.



-- 
Yours,
Muchun
