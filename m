From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Fri, 17 Apr 2020 10:18:15 -0700
Message-ID: <CALvZod4ftvXCu8SbQUXwTGVvx5K2+at9h30r28chZLXEB1JdfQ@mail.gmail.com>
References: <20200417010617.927266-1-kuba@kernel.org> <CALvZod78ZUhU+yr2x1h_gv+VgVGTPnSSGKh_+fd+MeiAKreJvg@mail.gmail.com>
 <20200417162355.GA43469@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o4AxRTlVcgkXgmi2LH7FRSyDbtdJOdGOVjbxoP8py4E=;
        b=KN9L8a7H5um8chRLVRTdUiq5rDqyihp3g4hBvjZNc0rLhfvTvEUIR3bpd7TMO9YPh2
         DYhybPls3AOAIJuz2jJD64RiTxjWqpFqMpjJsf/IRALVWQmI/V51Xjv/LBHYwMADNnDD
         XGoYsVgvmvbxEQd94R6RjNSmKNtoj/BHwVCe5OE2kwdMzXWbkSJYVSmzwzZHr1If24JZ
         2CyUinq6W/uFHqjvQ756hZpIY6QMOqNIw3KRxW+AOe+SmoUc58AIPolI35skXhsCpazf
         Gwfc8LqFDsWpjZ7e5JpD1ZrLCRi2AwsyyUXqm8iTmYGXk5GdKBflHIfz7U0dB17m40AO
         SbzA==
In-Reply-To: <20200417162355.GA43469-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Tejun,

On Fri, Apr 17, 2020 at 9:23 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Fri, Apr 17, 2020 at 09:11:33AM -0700, Shakeel Butt wrote:
> > On Thu, Apr 16, 2020 at 6:06 PM Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > Tejun describes the problem as follows:
> > >
> > > When swap runs out, there's an abrupt change in system behavior -
> > > the anonymous memory suddenly becomes unmanageable which readily
> > > breaks any sort of memory isolation and can bring down the whole
> > > system.
> >
> > Can you please add more info on this abrupt change in system behavior
> > and what do you mean by anon memory becoming unmanageable?
>
> In the sense that anonymous memory becomes essentially memlocked.
>
> > Once the system is in global reclaim and doing swapping the memory
> > isolation is already broken. Here I am assuming you are talking about
>
> There currently are issues with anonymous memory management which makes them
> different / worse than page cache but I don't follow why swapping
> necessarily means that isolation is broken. Page refaults don't indicate
> that memory isolation is broken after all.
>

Sorry, I meant the performance isolation. Direct reclaim does not
really differentiate who to stall and whose CPU to use.

> > memcg limit reclaim and memcg limits are overcommitted. Shouldn't
> > running out of swap will trigger the OOM earlier which should be
> > better than impacting the whole system.
>
> The primary scenario which was being considered was undercommitted
> protections but I don't think that makes any relevant differences.
>

What is undercommitted protections? Does it mean there is still swap
available on the system but the memcg is hitting its swap limit?

> This is exactly similar to delay injection for memory.high. What's desired
> is slowing down the workload as the available resource is depleted so that
> the resource shortage presents as gradual degradation of performance and
> matching increase in resource PSI. This allows the situation to be detected
> and handled from userland while avoiding sudden and unpredictable behavior
> changes.
>

Let me try to understand this with an example. Memcg 'A' has
memory.high = 100 MiB, memory.max = 150 MiB and memory.swap.max = 50
MiB. When A's usage goes over 100 MiB, it will reclaim the anon, file
and kmem. The anon will go to swap and increase its swap usage until
it hits the limit. Now the 'A' reclaim_high has fewer things (file &
kmem) to reclaim but the mem_cgroup_handle_over_high() will keep A's
increase in usage in check.

So, my question is: should the slowdown by memory.high depends on the
reclaimable memory? If there is no reclaimable memory and the job hits
memory.high, should the kernel slow it down to crawl until the PSI
monitor comes and decides what to do. If I understand correctly, the
problem is the kernel slow down is not successful when reclaimable
memory is very low. Please correct me if I am wrong.

Shakeel
