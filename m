From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: remove unused mem_cgroup_from_obj()
Date: Fri, 26 May 2023 21:13:05 -0700
Message-ID: <CAJD7tkYSrVkAONXko0eE6LWS__kK_Xeto9MVGwTxuqT5j6N8RQ@mail.gmail.com>
References: <20230527103126.398267-1-linmiaohe@huawei.com> <ZHGAcaqOx/e8lqwV@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685160822; x=1687752822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2CLI5dDlGRzvV0LMDARHxx4pfVRGX/zlI8ZJMCOjbQM=;
        b=00i267X+Zy5eHdWjx6icwa/P4rEW82q+O0IlAkQOt+vbOOfMFcbzvHAqzdv5/FL6Tn
         NGyG8n911S2yL4hThaPoslwa2Yp0aWDGMz1hzLFHXKZNQaQomJqFbN/bS3kmfm5rIZEH
         E/kTKAFGZMSFyjfPuX0trHV8y4SyOcNW4XxXMuPtsqKb75/O/An4NBcrABlt0E7wYMco
         +6FcgBKaPsFKWh5JEpm8ONiFvKFQDl0Z6axXQIodaarTWfRB4M4czFFJCh4bzCIgMf9j
         bD4/klzy5Hx1YNAZL/T64uaDacPyph4Z2wiGMe9lX4Xx5acRCtSdJ+H+JROb8oV2xle7
         wg0w==
In-Reply-To: <ZHGAcaqOx/e8lqwV-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 26, 2023 at 9:01=E2=80=AFPM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org=
> wrote:
>
> On Sat, May 27, 2023 at 06:31:26PM +0800, Miaohe Lin wrote:
> > The function mem_cgroup_from_obj() is not used anymore. Remove it and
> > clean up relevant comments.
>
> You should have looked at the git history to see why it was created
> and who used it.
>
> Shakeel, Vasily, are you going to retry adding commit 1d0403d20f6c?

That commit did not introduce the function though, no? It was
introduced before it and replaced by other variants over time (like
mem_cgroup_from_slab_obj()). It looks like that commit was reverted ~9
months ago. We can always bring it back if/when needed.

It also looks to me that 1d0403d20f6c was using mem_cgroup_from_obj()
on a struct net object, which is allocated in net_alloc() from a slab
cache, so mem_cgroup_from_slab_obj() should be sufficient, no?

>
>
