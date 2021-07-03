From: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Question] Do we need remote charging for cpu and cpuacct subsys?
Date: Sun, 4 Jul 2021 00:18:22 +0800
Message-ID: <CA+PpKPmN2E5zCjP3mkurNA2GANtLCUmoPG+_4mUq3E8cxOhuhQ@mail.gmail.com>
References: <60decdb6.1c69fb81.6130e.7642@mx.google.com> <20210702200742.wuhdg4dhpolher3t@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/SFx0l3EFfXNlGfyI4GVdZzRabxV5Q5+sQtiSDXNWyA=;
        b=Y89WEwsifC2v0VdErRLJjYeyJmIWBXHrtZzhT6IZHQdx/2Nsemmeil8SulvH9KRj22
         A0Z4KglyhDv0BfV7EQtbvIGrJd6mAagDmlsICgrwU5UCwcSFBcz/ZNLIh/YNAaxYbqM0
         7Y3SJFoXL6FokOSyo/uTlcMKTOk+lfmlRIn6oDp9MqwiiFZRpYHHtcaceEaWiTrKZxQj
         clRa0/2TAIx0uSBeawIVdmNqtU2GiIjfR6AQBbCIZIR1+tayHXy02exYi5VQNqPzKnbU
         fBY3jKfCTAPHStRotUekp2kOWYZ3Ml8xGNHDMLpd7CRelawB2FnloxzSY0Opt5YAojyg
         UpKQ==
In-Reply-To: <20210702200742.wuhdg4dhpolher3t-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Sat, Jul 3, 2021 at 4:07 AM Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> Hello,
>
> On Fri, Jul 02, 2021 at 08:26:27AM -0000, Hao Lee wrote:
> > memcg currently has a remote charging mechanism that can charge usage to other
> > memcg instead of the one the task belongs to.
> >
> > In our environment, we need to account the cpu usage consumed by some kworkers
> > to a specific cgroup. Thus, we want to introduce a remote-charging mechanism to
> > cpu and cpuacct subsys in our kernel.
>
> I also want to see this upstream, and am actually working on it right
> now, have been for some time.
>
> So far, this is needed to properly account multithreaded padata jobs,
> memory reclaim, and net rx. Android folks have raised this issue in the
> past too, though I'm not aware of the specific kthreads that are giving
> them problems.
>
> So naturally, I'm curious about your use case and how it may be
> different from these others. What kworkers would you like to account?

Thanks. We use a workqueue to perform asynchronous reclaim for cgroups.
The kworker may consume lots of CPU cycles if the cgroup memory pressure
is extremely high, so we want to charge the cpu usage to the related
cgroup for which the kworker works. Otherwise, the reclaim kworker will
steal cpu time from the system level, which breaks the resource isolation.

>
> > I want to know if the community has a plan to do this?
> > What will the community approach look like?
>
> There has been discussion about this here,
>
>    https://lore.kernel.org/lkml/20200219214112.4kt573kyzbvmbvn3-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org/
>

Yes, our work is very similar to Johannes'.

> more recently here,
>
>    https://lore.kernel.org/lkml/YGxjwKbec68sCcqo-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/
>
> and we may talk about it at LPC:
>
>    https://www.linuxplumbersconf.org/event/11/page/104-accepted-microconferences#cont-perform

I also found that you posted a patchset in 2019 to introduce a
cgroup-aware workqueue. In that discussion, back-charging is considered
to be a suitable solution.
    https://lore.kernel.org/lkml/20190611195549.GL3341036-LpCCV3molIbIZ9tKgghJQw2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org/

I also have a question here. Are the back-charging and remote charging
the same thing?

>
> > I think we need to move the active_memcg to a separated active_cgroup struct,
> > and the latter will contain active_memcg, active_tg, and active_cpuacct.
>
> I'm not seeing how that could work for cases that don't know the cgroup
> when the remote charging period begins.

This is indeed a problem. Neither cgroup-aware kthread nor remote
charging can address this. Maybe this is the biggest obstacle hindering
fine-grained charging.

> The only one I'm aware of
> that's like that is net rx, where the work to process packets has to
> start before their ultimate destination, and therefore cgroup, is known.

Sorry. Is this a typo? It seems the word "known" should be "unknown"...


Regards,
Hao Lee

>
> thanks,
> Daniel
