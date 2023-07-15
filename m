From: Ivan Babrou <ivan@cloudflare.com>
Subject: Re: Expensive memory.stat + cpu.stat reads
Date: Fri, 14 Jul 2023 17:14:19 -0700
Message-ID: <CABWYdi2L_qp8SmZ_w3pSSracYHEVku3TaBoXL7E0Nzn7CN3neg@mail.gmail.com>
References: <CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com>
 <20230706062045.xwmwns7cm4fxd7iu@google.com> <CABWYdi2pBaCrdKcM37oBomc+5W8MdRp1HwPpOExBGYfZitxyWA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1689380070; x=1691972070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rHB6MmDpW6mOW/AgkDp+ObJjFMKRQPqgz5eDHwER+yU=;
        b=W6GGyrjngXNyfkKbzBP757uoR9/rxEagoiMv4f1IGMSJeGCDSjINCa5zj4OukJxmlx
         v8tWhz33W130IhEua5jQxOvZvUXYTWOPem8PhPVPjpiqqQoGCgraF3LsNYGKV4SQ/+Xn
         SbbRovXFK1Nzj4i3EBYMzf5xIjum6gRDURoHo=
In-Reply-To: <CABWYdi2pBaCrdKcM37oBomc+5W8MdRp1HwPpOExBGYfZitxyWA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Shakeel Butt <shakeelb@google.com>
Cc: cgroups@vger.kernel.org, Linux MM <linux-mm@kvack.org>, kernel-team <kernel-team@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, Jul 10, 2023 at 4:21=E2=80=AFPM Ivan Babrou <ivan@cloudflare.com> w=
rote:
> The fast one is v6.1.37 and the slow one is v6.1.25. I'm not sure if
> the kernel version makes a difference or if it's a matter of uptime /
> traffic profile. The data is from two different locations. The fast
> location has gone through an expansion, which meant a full reboot with
> a kernel upgrade, so maybe that affected things:
>
> * https://i.imgur.com/x8uyMaF.png
>
> Let me try to reboot the slow location and see if there's any lasting
> improvement.

There is no correlation with the kernel version, v6.1.38 is slow too:

completed: 23.09s [manual / cpu-stat + mem-stat]
completed:  0.30s [manual / mem-stat]
completed:  0.64s [manual / cpu-stat]
