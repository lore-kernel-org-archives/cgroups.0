From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: fix missing wakeup oom task
Date: Fri, 5 Feb 2021 19:04:19 +0800
Message-ID: <CAMZfGtXXjXKoxbOSB9h6JvgZKEGBh2sCf34usJXcBXxGjU6k0w@mail.gmail.com>
References: <20210205062310.74268-1-songmuchun@bytedance.com>
 <YB0Ay+epP/hnFmDS@dhcp22.suse.cz> <CAMZfGtWKNNhc1Jy1jzp2uZU_PM6GNWup7d=yUVk9AehKFo_CRw@mail.gmail.com>
 <YB0cO7R1WtJgAxI2@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G84XgAXTIB9kxrWKppVfB7bhTavqUSYTbC5KVvLAP6g=;
        b=Gy+FulpQZ1ltev+PwnM5KcE1+7GoQk9sA8tu5+DNBMHtUciX/ITccny0i5NJW0w7eN
         lGEzSPoFo9+wKYG2McWRVBm1Kmpq6kfFh5PhvWeihcnbhdOKklU4ILERzeHkx8EzNmk9
         i2SQGg/4Ym7WsDWEKQLWRn9qEI/hHlU4td7Qd3EXvUsobrhBYid/LeaWZ8/UwedTf6ma
         cuUScuIGTGY4silbfwJ4wVkSA05+vDlJGfoGiUQxtRa8IE3fYnmbwWcJe/el4NjtD/TZ
         KJRYPc5ncLHX3SwjBYlcNGi3Yu6fkNMxVNmGirHAS1yqLnmZH4X5TSdL5U/T6iQGFG+N
         ToyA==
In-Reply-To: <YB0cO7R1WtJgAxI2-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 5, 2021 at 6:21 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Fri 05-02-21 17:55:10, Muchun Song wrote:
> > On Fri, Feb 5, 2021 at 4:24 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Fri 05-02-21 14:23:10, Muchun Song wrote:
> > > > We call memcg_oom_recover() in the uncharge_batch() to wakeup OOM task
> > > > when page uncharged, but for the slab pages, we do not do this when page
> > > > uncharged.
> > >
> > > How does the patch deal with this?
> >
> > When we uncharge a slab page via __memcg_kmem_uncharge,
> > actually, this path forgets to do this for us compared to
> > uncharge_batch(). Right?
>
> Yes this was more more or less clear (still would have been nicer to be
> explicit). But you still haven't replied to my question I believe. I
> assume you rely on refill_stock doing draining but how does this address
> the problem? Is it sufficient to do wakeups in the batched way?

Sorry, the subject title may not be suitable. IIUC, memcg_oom_recover
aims to wake up the OOM task when we uncharge the page.
I see uncharge_batch always do this. I am confused why
__memcg_kmem_uncharge does not. Both paths do the same
thing (uncharge pages). So actually, this patch want to keep
the two paths consistent. Thanks.

>
> > > > When we drain per cpu stock, we also should do this.
> > >
> > > Can we have anything the per-cpu stock while entering the OOM path. IIRC
> > > we do drain all cpus before entering oom path.
> >
> > You are right. I did not notice this. Thank you.
> >
> > >
> > > > The memcg_oom_recover() is small, so make it inline.
> > >
> > > Does this lead to any code generation improvements? I would expect
> > > compiler to be clever enough to inline static functions if that pays
> > > off. If yes make this a patch on its own.
> >
> > I have disassembled the code, I see memcg_oom_recover is not
> > inline. Maybe because memcg_oom_recover has a lot of callers.
> > Just guess.
> >
> > (gdb) disassemble uncharge_batch
> >  [...]
> >  0xffffffff81341c73 <+227>: callq  0xffffffff8133c420 <page_counter_uncharge>
> >  0xffffffff81341c78 <+232>: jmpq   0xffffffff81341bc0 <uncharge_batch+48>
> >  0xffffffff81341c7d <+237>: callq  0xffffffff8133e2c0 <memcg_oom_recover>
>
> So does it really help to do the inlining?

I just think memcg_oom_recover is very small, inline maybe
a good choice. Maybe I am wrong.

> --
> Michal Hocko
> SUSE Labs
