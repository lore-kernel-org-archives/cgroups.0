From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH 4/5] mm: memcg/slab: Fix root memcg vmstats
Date: Tue, 10 Nov 2020 10:57:16 +0800
Message-ID: <CAMZfGtUC63W3PYE8QwoNgxCvuyHBnvuzL3i8--873AYKmncAfg@mail.gmail.com>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
 <20201027080256.76497-5-songmuchun@bytedance.com> <20201027184835.GB827280@carbon.dhcp.thefacebook.com>
 <CAMZfGtU1aViokYk1hkHbYEiqW5QNi49UTd-QTrkycLqj6Q+-8g@mail.gmail.com>
 <20201029001408.GF827280@carbon.dhcp.thefacebook.com> <CAMZfGtW9wa=S7+OQw_R+4LU5VzcN0H0OUPw-2XfTAJFniQN3TA@mail.gmail.com>
 <20201110013236.GB2612097@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I5rP8g6hbwpalFY9R3djgaCnvHELnDvXyVufjhRMTp4=;
        b=SajSFgVHD3t008BCAfms7vYRMyHVUNzVRoA9PWFZhXui2O65vHkM6DHm76/JFdYwd0
         Ao1jHwv2xVK7DR+x9csXBc4CgxDrYzZa3pmQThaX6k5GCMWtjXcEfOclD/YCPx+bD/V/
         8GoKyIpwouyJ9qZhDEjPxCEFAdDiQ2Vi/wZJD0Y3y5sOG0ILsxFZo2b90YigtXRCw514
         3UxAGOMfv4mUYklolS4667iUrk8HLWMrCIwuv091M1pJA+PeL/L9qb+WVvEsF//ZW1DK
         86t/cwgS059JrMj9k5kPJaS7bn/qeTnp9LTbRi+rZ7LvPPy/tw1ShgVSm5jsl49b0DvM
         1dqQ==
In-Reply-To: <20201110013236.GB2612097-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Nov 10, 2020 at 9:33 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> On Thu, Oct 29, 2020 at 02:15:43PM +0800, Muchun Song wrote:
> > On Thu, Oct 29, 2020 at 8:14 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> > >
> > > On Wed, Oct 28, 2020 at 10:56:20AM +0800, Muchun Song wrote:
> > > > On Wed, Oct 28, 2020 at 2:48 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> > > > >
> > > > > On Tue, Oct 27, 2020 at 04:02:55PM +0800, Muchun Song wrote:
> > > > > > If we reparent the slab objects to the root memcg, when we free
> > > > > > the slab object, we need to update the per-memcg vmstats to keep
> > > > > > it correct for the root memcg. Now this at least affects the vmstat
> > > > > > of NR_KERNEL_STACK_KB for !CONFIG_VMAP_STACK when the thread stack
> > > > > > size is smaller than the PAGE_SIZE.
> > > > > >
> > > > > > Fixes: ec9f02384f60 ("mm: workingset: fix vmstat counters for shadow nodes")
> > > > > > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > > > >
> > > > > Can you, please, drop this patch for now?
> > > > >
> > > > > I'm working on a bigger cleanup related to the handling of the root memory
> > > > > cgroup (I sent a link earlier in this thread), which already does a similar change.
> > > > > There are several issues like this one, so it will be nice to fix them all at once.
> > > >
> > > > I have read the patch of https://lkml.org/lkml/2020/10/14/869. You
> > > > mean this patch
> > > > fixes this issue? It chooses to uncharge the root memcg. But here we may need to
> > > > uncharge the root memcg to keep root vmstats correct. If we do not do
> > > > this, we can
> > > > see the wrong vmstats via root memory.stat(e.g. NR_KERNEL_STACK_KB).
> > >
> > > I pointed at a different patch in the same thread (it looks like you read the first one):
> > > https://lkml.org/lkml/2020/10/21/612
>
> Hi Muchun!
>
> Can you please, resend your patch? The planned cleanup of the root memory cgroup
> is more complex than expected, so I think it makes sense to merge your patch without
> waiting for it. I'm sorry for delaying it initially.

OK, I will do that. Thanks.

>
> Please, feel free to add
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
>
> Thank you!
>
> Roman



-- 
Yours,
Muchun
