From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcontrol: Export memcg->watermark via sysfs for
 v2 memcg
Date: Sat, 7 May 2022 08:33:46 -0700
Message-ID: <CALvZod6upThQzqDGs1DCG4GuSf=rhfOncMU5=_eEoX8HH5Ri_w@mail.gmail.com>
References: <20220507050916.GA13577@us192.sjc.aristanetworks.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RKIrTDgFPzQoY+nQlkFGe6GXuT/mXqMIOBgKZEviWa0=;
        b=mM/QEyG8NRrxogssx348Xw9iuXFePPCxz8tD/ChHoVABmGa9Gd4j9lTAsRGn3NNyDx
         lLE+53P1YvhbEKq8ks3ha7QiBoEPsulerpQIV3rs6YO1z3IU5EJy4WpgJ+OUlq8bApJl
         nq4qk70mU++hxHK+ppYFPS7ICMK32ngwAwwbAks2652HVZ5+YaeEJb+3VCHR9xheSxMo
         Jw0DPaLDO3mh0mYxsPZYnKKAJoYtaKKZDlWysgfuwZKr5ZNhUb5w21H6hwZI0gC5y4Yr
         C7UkSnjzkcDMxeGNk+Hw3/sIVo+WCABP0JJpxOWIkbwwQrQZlnjf8fOGHROhVY7vQcis
         W/Lw==
In-Reply-To: <20220507050916.GA13577-pF7uKtACKh3GmWBmRUYTj5O0Dwfk+90YVpNB7YpNyf8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, May 6, 2022 at 10:09 PM Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org> wrote:
>
> We run a lot of automated tests when building our software and run into
> OOM scenarios when the tests run unbounded. v1 memcg exports
> memcg->watermark as "memory.max_usage_in_bytes" in sysfs. We use this
> metric to heuristically limit the number of tests that can run in
> parallel based on per test historical data.
>
> This metric is currently not exported for v2 memcg and there is no
> other easy way of getting this information. getrusage() syscall returns
> "ru_maxrss" which can be used as an approximation but that's the max
> RSS of a single child process across all children instead of the
> aggregated max for all child processes. The only work around is to
> periodically poll "memory.current" but that's not practical for
> short-lived one-off cgroups.
>
> Hence, expose memcg->watermark as "memory.peak" for v2 memcg.
>
> Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
