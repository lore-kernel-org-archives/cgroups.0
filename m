From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: use rstat for non-hierarchical stats
Date: Tue, 25 Jul 2023 12:25:03 -0700
Message-ID: <CAJD7tkb47j48TkpH=zwdJZqo5QBehVmyeMMekd6JSbNbR7XLMw@mail.gmail.com>
References: <20230719174613.3062124-1-yosryahmed@google.com>
 <20230725140435.GB1146582@cmpxchg.org> <20230725104310.ac652a03ab92357a162b1f92@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690313140; x=1690917940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gccFtzx/Ez7hMBziN2qyyxk5R7pKLnaq2lGrOQwbiIg=;
        b=k0n6UJsh+lZ+hTFQLHMj4us4wXltqc2G5v/vYmRmdyhuGwj/r3CqrJQDQxYE7M80HV
         wCdCAHYMJw9hGgaxndA5Yw5povenCAxQCF3buKcM3DMGQeQ/QkKeRqwsSoWAxirUzBFu
         UkmK/vSMxzsFGgwBVpCUK57IAtboaemAE7ebrGWETSgDp9xmV0NDxqEsx/W/U8ADDfcD
         5HNiz8T5RsSwulHQJVJMRYhWuv5n78tVzHmeurEiseDIKMSTADQIF9p6LCbuFCjM3uuJ
         O3Lp/YaO+gnCWAMU/TpQ63dzghPVFrKFG0NlQ7eRmy7GbIg85NO/vUpytbZsiSXE3FIh
         M8/w==
In-Reply-To: <20230725104310.ac652a03ab92357a162b1f92-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Jul 25, 2023 at 10:43=E2=80=AFAM Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Tue, 25 Jul 2023 10:04:35 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> w=
rote:
>
> > > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> >
> > But I want to be clear: this isn't a regression fix. It's a new
> > performance optimization for the deprecated cgroup1 code. And it comes
> > at the cost of higher memory footprint for both cgroup1 AND cgroup2.
>
> Thanks.
>
> Yosry, could you please send along a suitably modified changelog?

I will send a v2 once we agree on the history story and whether or not
this fixes a regression.

Thanks!
