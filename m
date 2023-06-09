From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH net-next] sock: Propose socket.urgent for sockmem isolation
Date: Fri, 9 Jun 2023 22:53:50 +0500
Message-ID: <CALvZod4BuY=kHnQov6Ho+UT0_0oG6nEX1Z-pU-f4Yt9w7-=5Hg@mail.gmail.com>
References: <20230609082712.34889-1-wuyun.abel@bytedance.com> <CANn89i+Qqq5nV0oRLh_KEHRV6VmSbS5PsSvayVHBi52FbB=sKA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686333242; x=1688925242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80A8FjuVOOa9xV5urorcQcKqtLHX/x3yj6q554YpmN4=;
        b=3aDAkRb3lc+9oQjqGBI7DxxQhUAZCXyJz4umZdc4T+QCL+WhlmT6IcVLQeZPvpuc1t
         WaMCCTXRNkd48dRGNKGZEyL3tawhP6gy7GZ/+mPabZRJ3ySOkh6qKrqMQU+9R2JSghhR
         dMi9fNhDt+RgOePLbLSV32bwAdP1jAaW1MU5HJwdU/m9ss40PrWSVoklPyaec+qBNwwy
         Ms+Eh1bui8+GG4xojnc/FFU18ZLKSBkS/7ywj8Tt5cWDQ5TF9MmwrGqNc/CtWDCgD5Jy
         k1YFAWQYH2r9Yj8cnmBMYIc3RV/2HP2lIoMdSHUYdbCW5r/DjAPhCqjvIoRpkaw7fJrB
         T36g==
In-Reply-To: <CANn89i+Qqq5nV0oRLh_KEHRV6VmSbS5PsSvayVHBi52FbB=sKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Warloe <cwarloe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Wang <weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Kuniyuki Iwashima <kuniyu-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, Martin KaFai Lau <martin.lau-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Xin Long <lucien.xin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason

On Fri, Jun 9, 2023 at 2:07=E2=80=AFPM Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> w=
rote:
>
> On Fri, Jun 9, 2023 at 10:28=E2=80=AFAM Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org=
> wrote:
> >
> > This is just a PoC patch intended to resume the discussion about
> > tcpmem isolation opened by Google in LPC'22 [1].
> >
> > We are facing the same problem that the global shared threshold can
> > cause isolation issues. Low priority jobs can hog TCP memory and
> > adversely impact higher priority jobs. What's worse is that these
> > low priority jobs usually have smaller cpu weights leading to poor
> > ability to consume rx data.
> >
> > To tackle this problem, an interface for non-root cgroup memory
> > controller named 'socket.urgent' is proposed. It determines whether
> > the sockets of this cgroup and its descendants can escape from the
> > constrains or not under global socket memory pressure.
> >
> > The 'urgent' semantics will not take effect under memcg pressure in
> > order to protect against worse memstalls, thus will be the same as
> > before without this patch.
> >
> > This proposal doesn't remove protocal's threshold as we found it
> > useful in restraining memory defragment. As aforementioned the low
> > priority jobs can hog lots of memory, which is unreclaimable and
> > unmovable, for some time due to small cpu weight.
> >
> > So in practice we allow high priority jobs with net-memcg accounting
> > enabled to escape the global constrains if the net-memcg itselt is
> > not under pressure. While for lower priority jobs, the budget will
> > be tightened as the memory usage of 'urgent' jobs increases. In this
> > way we can finally achieve:
> >
> >   - Important jobs won't be priority inversed by the background
> >     jobs in terms of socket memory pressure/limit.
> >
> >   - Global constrains are still effective, but only on non-urgent
> >     jobs, useful for admins on policy decision on defrag.
> >
> > Comments/Ideas are welcomed, thanks!
> >
>
> This seems to go in a complete opposite direction than memcg promises.
>
> Can we fix memcg, so that :
>
> Each group can use the memory it was provisioned (this includes TCP buffe=
rs)
>
> Global tcp_memory can disappear (set tcp_mem to infinity)

I agree with Eric and this is exactly how we at Google overcome the
isolation issue. We have set tcp_mem to unlimited and enabled memcg
accounting of network memory (by surgically incorporating v2 semantics
of network memory accounting in our v1 environment).

I do have one question though:

> This proposal doesn't remove protocal's threshold as we found it
> useful in restraining memory defragment.

Can you explain how you find the global tcp limit useful? What does
memory defragment mean?
