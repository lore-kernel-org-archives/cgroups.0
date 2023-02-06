From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Mon, 6 Feb 2023 14:39:17 -0800
Message-ID: <CAJD7tka6SC1ho-dffV0bK_acoZd-5DQzBOy0xg3TkOFG1zAPMg@mail.gmail.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <c7b5e502d1a3b9b8f6e96cbf9ca553b143c327e0.1675669136.git-series.apopple@nvidia.com>
 <Y+Fttp1ozejoSQzl@slm.duckdns.org> <CAJD7tkb_Cr7rTTpKc1VBpS8h=n3Hu+nGiV8dkLH-NdC1bSG9mg@mail.gmail.com>
 <Y+GA6Y7SVhAW5Xm9@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vBYiMptRxwrwyAIJqR0DNTAcDHviyisXsjkfb23ttq0=;
        b=pYHUFJ0huOMCZRpFmAWdIqONn14zA0VKbs7NoBaHhiULeZuC89C4qTp2OSmh6X976F
         yVcFimguUqPFHl/SznKsQVSmGwZRfLdQMKYJzZEqkjTtedvKDBwT9lrBEGqnmaZaLdeG
         y842Az3T6cDJi0wgY4LCjXFCH0hhuDBGf1H07fqf5oR4UwMBQCd5DSl+RARf+VdlcP93
         c0TIB8jLJoy5Zh8XGOkuf9UaZarBJ29WCX4QLVCFfuW97x+8Ijf58B/MDlZP1nB3nw/Y
         /FrOaYPtqQyC6hVkOi7YG6WvfkfrRvS5hy8VE/sTaFdZwRQ5NlADn6nfO5bszi2N2+O/
         +WSA==
In-Reply-To: <Y+GA6Y7SVhAW5Xm9-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, Feb 6, 2023 at 2:36 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Mon, Feb 06, 2023 at 02:32:10PM -0800, Yosry Ahmed wrote:
> > I guess it boils down to which we want:
> > (a) Limit the amount of memory processes in a cgroup can be pinned/locked.
> > (b) Limit the amount of memory charged to a cgroup that can be pinned/locked.
> >
> > The proposal is doing (a), I suppose if this was part of memcg it
> > would be (b), right?
> >
> > I am not saying it should be one or the other, I am just making sure
> > my understanding is clear.
>
> I don't quite understand what the distinction would mean in practice. It's
> just odd to put locked memory in a separate controller from interface POV.

Assume we have 2 cgroups, A and B. A process in cgroup A creates a
tmpfs file and writes to it, so the memory is now charged to cgroup A.
Now imagine a process in cgroup B tries to lock this memory.
- With (a) the amount of locked memory will count toward's cgroup A's
limit, because cgroup A is charged for the memory.
- With (b) the amount of locked memory will count toward's cgroup B's
limit, because a process in cgroup B is locking the memory.

I agree that it is confusing from an interface POV.

>
> Thanks.
>
> --
> tejun
