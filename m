From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Mon, 6 Feb 2023 14:32:10 -0800
Message-ID: <CAJD7tkb_Cr7rTTpKc1VBpS8h=n3Hu+nGiV8dkLH-NdC1bSG9mg@mail.gmail.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <c7b5e502d1a3b9b8f6e96cbf9ca553b143c327e0.1675669136.git-series.apopple@nvidia.com>
 <Y+Fttp1ozejoSQzl@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l7GqiDnnbtUw28nuIsiTOre+ZKz+TpI1lg7hwVstG3g=;
        b=bjqC5GS/eZCj8Q0tz1L7nhIPi+KBAKimBOQARz+19LvOTMg3hMzlZzkrgdDEO6xqTb
         B7RSKAxUSBQ5hXb3vPRlno1jQ2dpZDRN9VUVLwy02Qh424sdV3GZybk3TDAEj4DZiAFE
         r065BaTFJy8y+uMmf9W4ObmnllL8uoPjTyH7+iMmk8bf2TKfR6eMn2wGIaxPpVi5NtVU
         gZCa1vJ87AX5mxbHOJNqbU44FQI7mCgPPROEJrSQq4YL4mTjbMThGyFHIA6R3bcYqfnA
         1qUiLR04aRJKbuOqI21o9cr8g3s4afL6lwp8mHwwoD5Ap2cMEjB3r52ZQmSA0Q5hczb4
         e77w==
In-Reply-To: <Y+Fttp1ozejoSQzl-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, Feb 6, 2023 at 1:14 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Mon, Feb 06, 2023 at 06:47:51PM +1100, Alistair Popple wrote:
> > If too much memory in a system is pinned or locked it can lead to
> > problems such as performance degradation or in the worst case
> > out-of-memory errors as such memory cannot be moved or paged out.
> >
> > In order to prevent users without CAP_IPC_LOCK from causing these
> > issues the amount of memory that can be pinned is typically limited by
> > RLIMIT_MEMLOCK. However this is inflexible as limits can't be shared
> > between tasks and the enforcement of these limits is inconsistent
> > between in-kernel users of pinned memory such as mlock() and device
> > drivers which may also pin pages with pin_user_pages().
> >
> > To allow for a single limit to be set introduce a cgroup controller
> > which can be used to limit the number of pages being pinned by all
> > tasks in the cgroup.
>
> As I wrote before, I think this might fit better as a part of memcg than as
> its own controller.

I guess it boils down to which we want:
(a) Limit the amount of memory processes in a cgroup can be pinned/locked.
(b) Limit the amount of memory charged to a cgroup that can be pinned/locked.

The proposal is doing (a), I suppose if this was part of memcg it
would be (b), right?

I am not saying it should be one or the other, I am just making sure
my understanding is clear.

>
> Thanks.
>
> --
> tejun
