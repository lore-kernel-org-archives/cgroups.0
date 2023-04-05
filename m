From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 6/8] workingset: memcg: sleep when flushing stats in workingset_refault()
Date: Wed, 5 Apr 2023 01:02:01 -0700
Message-ID: <CAJD7tkZ=o42N_45LxRPg=oOg56Lqn-wqT_0JJUPPoKOB+ig2JQ@mail.gmail.com>
References: <20230330191801.1967435-1-yosryahmed@google.com>
 <20230330191801.1967435-7-yosryahmed@google.com> <20230404165305.ffs7uscqpndnfytn@blackpad>
 <CAJD7tkb-0rXL9V2TX-Ax-3OkwJPYx_GaOT4D=VCA60riit+dOw@mail.gmail.com> <20230405080047.5omnatjbwz46f3y5@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680681758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pEwjzYcWs+Nq2B13OiqxRc4o61ZYX+Tx79hgu5r8M58=;
        b=RPHLXw9sSgwpHJr/+l3qfC5nPoEvslH4Vlvp7ZohRVeJUYUwEgpmuvPKwY6/LAXZ4c
         UOr2vNt2IlvzNfCaVQTdzSrG/5hklqwq4qvvOX5tzuKA2xdV4XLARc3NBhi1qSAOQjD1
         cAmoZtTp54aqHRdSbkkOPSuSe2DuJuiQ60d3rrjhRuEDjbeDCiCtdJofsgfVpbUXlEjX
         CQZYdJCMd59NPSp5JXIV8SyRsgFDebBJEr+pQBUnYDWZ3fuQ/FuyH+8DnTaPmUf7AJD/
         oDSYlI8G38WcKprwnEqQcqTjojvsHbIsQB/2aZR84YGGUdCVPwVqmG5BIFmMQrVLugm6
         fcSw==
In-Reply-To: <20230405080047.5omnatjbwz46f3y5@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

On Wed, Apr 5, 2023 at 1:00=E2=80=AFAM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org=
> wrote:
>
> On Tue, Apr 04, 2023 at 11:09:02AM -0700, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > IIUC there are multiple places where we can sleep in this path, we can
> > sleep waiting for a page to be read from disk, we can sleep during
> > allocating the page to read into, and IIUC the allocations on the
> > fault path can even run into reclaim, going into the vmscan code. So
> > there are precedents, but I am not sure if that's enough argument.
>
> I expect it'd depend on the proportion of the slow/fast paths.
> OK, let's see how it turns out in wider population.

Agreed. It also depends on the number of memcgs and how much the
periodic flusher is keeping up. I think no amount of testing will
cover all or even most workloads.

>
> Thanks,
> Michal
