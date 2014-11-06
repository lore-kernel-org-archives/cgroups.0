From: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct page
Date: Thu, 6 Nov 2014 22:55:58 +0400
Message-ID: <CALYGNiO85ts2J_c8fiYHGDe5gEhb4QMB_HAsST3opdwumUptFg@mail.gmail.com>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=p80P8hC1BkQovDgSTUom2qQ4H1QoUkF3ZhQJ5rUAt/U=;
        b=nNd3mH54paWRf7SecfUuFuS2CqPYODqUGZ2tsFE9fle8r3IXkwnh6aIVV0b8CGc3ll
         rCBSwIgGyMc97SPpyWHr8ANYJtevwsBzxdUEsGV0RamGGWypsHkvR8q7XwdybXK1wUcv
         2Q2OaU1Lg30IV+8JrBl7egzJ61vp9f//ro81Fpxm+sUIX/Z5Tos/wABPRE/qeZ0M0uO+
         d7dyjK8F2eEgIInRR7kePZVYhI3o6F6osVDjUtTHhfOr2ccDWLnQTG4AxliQ5L6Ssd0W
         rOBqgkuJnPx8lgqGTWZvGLGB37L2Kh2qUjQmO0M58V1fVWoSI/tj3FcQrY3GO4MVnZqA
         /VDw==
In-Reply-To: <1414898156-4741-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, Nov 2, 2014 at 6:15 AM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> Memory cgroups used to have 5 per-page pointers.  To allow users to
> disable that amount of overhead during runtime, those pointers were
> allocated in a separate array, with a translation layer between them
> and struct page.
>
> There is now only one page pointer remaining: the memcg pointer, that
> indicates which cgroup the page is associated with when charged.  The
> complexity of runtime allocation and the runtime translation overhead
> is no longer justified to save that *potential* 0.19% of memory.  With
> CONFIG_SLUB, page->mem_cgroup actually sits in the doubleword padding
> after the page->private member and doesn't even increase struct page,
> and then this patch actually saves space.  Remaining users that care
> can still compile their kernels without CONFIG_MEMCG.
>
>    text    data     bss     dec     hex     filename
> 8828345 1725264  983040 11536649 b00909  vmlinux.old
> 8827425 1725264  966656 11519345 afc571  vmlinux.new
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Great! Never thought I'd see this. =)

Acked-by: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


> ---
>  include/linux/memcontrol.h  |   6 +-
>  include/linux/mm_types.h    |   5 +
>  include/linux/mmzone.h      |  12 --
>  include/linux/page_cgroup.h |  53 --------
>  init/main.c                 |   7 -
>  mm/memcontrol.c             | 124 +++++------------
>  mm/page_alloc.c             |   2 -
>  mm/page_cgroup.c            | 319 --------------------------------------------
>  8 files changed, 41 insertions(+), 487 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index d4575a1d6e99..dafba59b31b4 100644



> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
