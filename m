From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: freezer cgroups: Forcing frozen memory to swap
Date: Fri, 31 Mar 2023 12:25:49 -0700
Message-ID: <CAJD7tkZ+ZkQX01MHDGd0mT7=qt82VfJ_AAXA2xy1w35Drws-0g@mail.gmail.com>
References: <CAEeXeQLTQjt6O4C-_3dE63gPEgXU9qtdM2+XDxYemV9bsfq_pg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680290786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iu7s9DYyfZiIezMIZDBeMPsNtoiOPCl5mln2vnX6FPU=;
        b=Jh1exDm2YeiM89cAzqqWvMxVLriZxCQArLnH4Mf6OVhEcGsrWa67g4r4iY9GxBqbL4
         OwiVm/ocExjWSMEDP9eTxqD46U6I3d7SVjjjUi82zkGcqJI5cy9NeZDc2aVMrm+tu9D4
         2ihR1w8LzwPVi8V2GpLFeCJCC1+5Wib5Jjnd3W7a3/qpPLT61HDDmpxc1WBzkXj7GdjS
         c1V7ynE2tVtUYK2imikTkrZvZSfAfE1k58a/h1So+lVWALmAznug58niAX2/RU1yHRnX
         6j8J+n3+dwdR/5N3u5VPOS2w5wXbjINi/VhPfdgtNb3Syg0XszV+79drAnURLA3puqU3
         ithQ==
In-Reply-To: <CAEeXeQLTQjt6O4C-_3dE63gPEgXU9qtdM2+XDxYemV9bsfq_pg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tyler Rider <tylerjrider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Mar 31, 2023 at 11:49=E2=80=AFAM Tyler Rider <tylerjrider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
>
> Hi all,
>
> I've been trying to search for some mechanism(s) to reclaim resident
> memory of some frozen applications on a small embedded device. The
> typical use case is to bring up an app and once backgrounded/dismissed
> the idea is to freeze/thaw for faster resume/restart times.
>
> The issue is that after starting/pausing several of these applications
> (and subsequently freezing) memory begins dropping, and memory
> thrashing begins. (I can stop the apps of course, but then that leads
> to longer load times).
>
> I've already got memory constraint issues, which led to adding a swap
> partition. I've tried bumping the memory.swapiness to 100 within a
> memory cgroup, and waiting a few seconds for kswapd to kick in before
> freezing but since the app is running it only puts a handful of pages
> into swap.
>
> Some projects exist (crypopid(2) / CRIU) for dumping the process state
> in userspace, but unless I'm missing something, I'd imagine there must
> be some existing kernel mechanism (seems like a useful feature for
> small memory constrained devices) within the freezer/memory cgroups
> that can force all pages of the frozen process to a swap partition,
> and restore on thaw.
>
> Does this sort of  cgroup-level S4 (hibernate-to-disk) exist or even
> just a mechanism to force a frozen process's pages to swap?

In memory cgroups there is a memory.reclaim interface, where you can
request the kernel to reclaim X amount of memory from the cgroup. A
few things to keep in mind:

* This is per-cgroup, not per-process.

* This is irrelevant to freezing.

* This will try to reclaim all types of memory, not just swapbacked
(anon & tmpfs memory). So it may writeback file pages charged to the
cgroup, or shrink slabs.

* I am not aware of a mechanism to fault back in all the memory mapped
by processes in a cgroup to restore the pages. Perhaps you can use
MADV to do this per-process, or just let processes fault their memory
back in on-demand.

>
> Thanks,
> Tyler
