From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm-unstable RFC 3/5] memcg: calculate root usage from
 global state
Date: Thu, 20 Apr 2023 11:57:06 -0700
Message-ID: <CALvZod5WNiiV2NmikaGMPd62hiGtKWZrO0f2amk2HE8quBxkDQ@mail.gmail.com>
References: <20230403220337.443510-1-yosryahmed@google.com> <20230403220337.443510-4-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682017038; x=1684609038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PPC/T+cZBiALDJb1UQ+biPUmWPyQkwBmvhpGsYNp8Ec=;
        b=PkKT30pQsy0dCCBavAqHdYdEypziw027sTRPtrDqQEAdFY/TgNivu3OfPvntSwK5vh
         mU5R6qzBEL+qOULk/9IpVdRCuSYMJd/CzosuFnkJHrtdKzbtz0qrvCTLqa6YVYOFENL6
         eUbuwLtPygmsEnnix7qVPS4j+Mb06vn2kCVGU22IQ/QipOnHx3x30cc17Wf2V/b6eOQA
         FBcLvayQhbewEQqXjzzBGqjCWuPzVpydlIFaj667t12Zh2ffgrUquDBsin3Tzj+OScUJ
         BWjEbdTXXG4edmqIovf5NwazZ359XreOT3MIExV27wqDBPOW6JeKvDnWf6Vv752fS0yk
         hnzw==
In-Reply-To: <20230403220337.443510-4-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, Apr 3, 2023 at 3:03=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> Currently, we approximate the root usage by adding the memcg stats for
> anon, file, and conditionally swap (for memsw). To read the memcg stats
> we need to invoke an rstat flush. rstat flushes can be expensive, they
> scale with the number of cpus and cgroups on the system.
>
> mem_cgroup_usage() is called by memcg_events()->mem_cgroup_threshold()
> with irqs disabled, so such an expensive operation with irqs disabled
> can cause problems.
>
> Instead, approximate the root usage from global state. This is not 100%
> accurate, but the root usage has always been ill-defined anyway.
>
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
