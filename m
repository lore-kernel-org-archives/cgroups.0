From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 0/2] memcontrol: support cgroup level OOM protection
Date: Wed, 17 May 2023 01:09:50 -0700
Message-ID: <CAJD7tkbHKQBoz7kn6ZjMTMoxLKYs7x9w4uRGWLvuyOogmBkZ_g@mail.gmail.com>
References: <CAJD7tkYPGwAFo0mrhq5twsVquwFwkhOyPwsZJtECw-5HAXtQrg@mail.gmail.com>
 <09A746CC-E38D-4ECA-B0F4-862EC6229A0F@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684311027; x=1686903027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M/JbPTvNpjTaAOSiw7cq2XUFwTTZo3maiLd9kZ3gbPY=;
        b=E/nQr0TtAbvKOJgpRKAM1JVFuP/MwUX23KxLMaK9E935LDpjE6s9HpTk6zcktHzA3V
         lVxuSKWxkpaEF/0X7X4fb0A2wQtR+BP46udE3XC2KotT4N3Y20wucgNCN5myvUQPrgYm
         hf8qXaIk4/mtVqOzBMdebf1uOebU+yZFQwgKC0uSR7A2S8DJaBgTCt2tXTRjmHgu9gTl
         He1rqLvC6itIyQX551xHdP0ntcFbz4HClZ9Wg7mkLnBAKGlfTSh3/2KEYLgKR0024kd1
         FZk9gcyZUQemmV3CyHP8mGDAj9j4MwZkxgKrt5y90zAG/N8tFGr657bHQAGYojKPXnWN
         MoDw==
In-Reply-To: <09A746CC-E38D-4ECA-B0F4-862EC6229A0F-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?56iL5Z6y5rabIENoZW5na2FpdGFvIENoZW5n?= <chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
Cc: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org" <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org" <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, May 17, 2023 at 1:01=E2=80=AFAM =E7=A8=8B=E5=9E=B2=E6=B6=9B Chengka=
itao Cheng
<chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org> wrote:
>
> At 2023-05-17 14:59:06, "Yosry Ahmed" <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >+David Rientjes
> >
> >On Tue, May 16, 2023 at 8:20=E2=80=AFPM chengkaitao <chengkaitao@didiglo=
bal.com> wrote:
> >>
> >> Establish a new OOM score algorithm, supports the cgroup level OOM
> >> protection mechanism. When an global/memcg oom event occurs, we treat
> >> all processes in the cgroup as a whole, and OOM killers need to select
> >> the process to kill based on the protection quota of the cgroup.
> >>
> >
> >Perhaps this is only slightly relevant, but at Google we do have a
> >different per-memcg approach to protect from OOM kills, or more
> >specifically tell the kernel how we would like the OOM killer to
> >behave.
> >
> >We define an interface called memory.oom_score_badness, and we also
> >allow it to be specified per-process through a procfs interface,
> >similar to oom_score_adj.
> >
> >These scores essentially tell the OOM killer the order in which we
> >prefer memcgs to be OOM'd, and the order in which we want processes in
> >the memcg to be OOM'd. By default, all processes and memcgs start with
> >the same score. Ties are broken based on the rss of the process or the
> >usage of the memcg (prefer to kill the process/memcg that will free
> >more memory) -- similar to the current OOM killer.
>
> Thank you for providing a new application scenario. You have described a
> new per-memcg approach, but a simple introduction cannot explain the
> details of your approach clearly. If you could compare and analyze my
> patches for possible defects, or if your new approach has advantages
> that my patches do not have, I would greatly appreciate it.

Sorry if I was not clear, I am not implying in any way that the
approach I am describing is better than your patches. I am guilty of
not conducting the proper analysis you are requesting.

I just saw the thread and thought it might be interesting to you or
others to know the approach that we have been using for years in our
production. I guess the target is the same, be able to tell the OOM
killer which memcgs/processes are more important to protect. The
fundamental difference is that instead of tuning this based on the
memory usage of the memcg (your approach), we essentially give the OOM
killer the ordering in which we want memcgs/processes to be OOM
killed. This maps to jobs priorities essentially.

If this approach works for you (or any other audience), that's great,
I can share more details and perhaps we can reach something that we
can both use :)

>
> >This has been brought up before in other discussions without much
> >interest [1], but just thought it may be relevant here.
> >
> >[1]https://lore.kernel.org/lkml/CAHS8izN3ej1mqUpnNQ8c-1Bx5EeO7q5NOkh0qrY=
_4PLqc8rkHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/#t
>
> --
> Thanks for your comment!
> chengkaitao
>
