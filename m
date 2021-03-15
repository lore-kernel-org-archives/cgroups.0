From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v2 8/8] memcg: accounting for ldt_struct objects
Date: Mon, 15 Mar 2021 16:59:55 +0100
Message-ID: <20210315155955.GD20497@zn.tnic>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
 <360b4c94-8713-f621-1049-6bc0865c1867@virtuozzo.com>
 <20210315132740.GB20497@zn.tnic>
 <CALvZod7aT7t_Yp67CaECbCSzk8CuqBRMUBccthLCpz4osqDLKw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1615824000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=UQyudUKROkDbmPUGp2F469Qw909qU2BXgba4Lf8+Rbg=;
        b=lAuVjuSQt7FfMhcsmV9hb4GxqYSIK2AZRTB1qZtn/llQxanjeQQyy7OLI+P2d3OSM2XlAO
        r3yluYprLAXbsxZJX0Ug2qUcLxXRlu7X29/lTuno/uaYmIg1k7uCY3JmtBxr6MLV+xV6DA
        glLhN1+8nGcWQuoFWhe+Oo2s9PiErBY=
Content-Disposition: inline
In-Reply-To: <CALvZod7aT7t_Yp67CaECbCSzk8CuqBRMUBccthLCpz4osqDLKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Mon, Mar 15, 2021 at 08:48:26AM -0700, Shakeel Butt wrote:
> Let me try to provide the reasoning at least from my perspective.
> There are legitimate workloads with hundreds of processes and there
> can be hundreds of workloads running on large machines. The
> unaccounted memory can cause isolation issues between the workloads
> particularly on highly utilized machines.

Good enough for me, as long as that is part of the commit message.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
