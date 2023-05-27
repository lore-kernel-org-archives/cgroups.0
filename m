From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: remove unused mem_cgroup_from_obj()
Date: Sat, 27 May 2023 11:54:50 -0700
Message-ID: <CAJD7tkZ2Q1ZCqNchpiiC6FCE08dYH6tzANA=VqujeDgT8YhRUA@mail.gmail.com>
References: <20230527103126.398267-1-linmiaohe@huawei.com> <ZHGAcaqOx/e8lqwV@casper.infradead.org>
 <CAJD7tkYSrVkAONXko0eE6LWS__kK_Xeto9MVGwTxuqT5j6N8RQ@mail.gmail.com> <ZHIcnOV/mrkcerlG@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685213727; x=1687805727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=viejgcOJYhUdOPohgf97i0Wzf+D67gj8ZGmzRX0nO/k=;
        b=yoIXKiJP/PQuOCyvUbfZpPOpmciaL4BClmV5u9FWAJav2Ab8Fs/ZHqJC6/HGAiO13m
         ZIKUvlIZjCopV2HwNAgU5hBgWXN5Gx9UGuVLxhZwd1XDlIeFS7Tn4kU/+WQ1PkaFuTMY
         SeJaaK3wWFUBTd7wOLVlxB+V0ZsQNdY7xTCxKpHi8oVAv/QbU19qZaeZFlnP416z3z4Y
         97dqvyvsgJ/TPe+wKMayqSIW9aw2RQStv1GRQGRjUFhJpNPxuYp8wqTpzr5hv3o/Y/Od
         aGCh+n3C6XasvgpZvPguvSXjnuqn7Coq7+UHWRY1PscVJpDxDqfIBI/dDcKQ0EzCIj/p
         /PbA==
In-Reply-To: <ZHIcnOV/mrkcerlG-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, May 27, 2023 at 8:07=E2=80=AFAM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org=
> wrote:
>
> On Fri, May 26, 2023 at 09:13:05PM -0700, Yosry Ahmed wrote:
> > On Fri, May 26, 2023 at 9:01=E2=80=AFPM Matthew Wilcox <willy@infradead=
.org> wrote:
> > >
> > > On Sat, May 27, 2023 at 06:31:26PM +0800, Miaohe Lin wrote:
> > > > The function mem_cgroup_from_obj() is not used anymore. Remove it a=
nd
> > > > clean up relevant comments.
> > >
> > > You should have looked at the git history to see why it was created
> > > and who used it.
> > >
> > > Shakeel, Vasily, are you going to retry adding commit 1d0403d20f6c?
> >
> > That commit did not introduce the function though, no? It was
> > introduced before it and replaced by other variants over time (like
> > mem_cgroup_from_slab_obj()). It looks like that commit was reverted ~9
> > months ago. We can always bring it back if/when needed.
>
> The commit immediately preceding it is fc4db90fe71e.
>
> Of course we can bring it back.  It's just code.  But avoiding
> unnecessary churn is also good.  Let's wait to hear from Vasily.
>
> > It also looks to me that 1d0403d20f6c was using mem_cgroup_from_obj()
> > on a struct net object, which is allocated in net_alloc() from a slab
> > cache, so mem_cgroup_from_slab_obj() should be sufficient, no?
>
> Clearly not.

I dived deeper into the history on LKML, and you are right:
https://lore.kernel.org/all/Yp4F6n2Ie32re7Ed@qian/

I still do not understand why mem_cgroup_from_slab_obj() would not be
sufficient, so I am hoping Vasily or Shakeel can help me understand
here. Seems to be something arch-specific.

Thanks for digging this up, Matthew.
