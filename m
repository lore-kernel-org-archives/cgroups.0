From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: export workingset refault stats for cgroup v1
Date: Wed, 17 Aug 2022 14:15:31 -0700
Message-ID: <CALvZod5kbOf+-jVWBhb1ior0oyWUKjMT57bip_eGGxWwSDVf=A@mail.gmail.com>
References: <20220816185801.651091-1-shy828301@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=W68mRWKkzm4aDvuZ9fpamtsHCYcoX/l6oOU0+8H2cO4=;
        b=ghlXe6amfyyPTIvD8h2OzBZpSNxzzwySTwBtK1UPSmnioTgnh6ix6wHqO5kkTg0id+
         msSOuCmLyksrTHImHfmjouS47CtMFxITU5gi9f9dvldGB5A+XaCdOygO9Wk1kI2fG01k
         mnkM6RBrYtjI5H9PhOLA9YFlbm3DdpnK9Iq/2bqLHlbzzTpDQvfbmoKgltQTn0/p6NAc
         DCKybAFDCfMwKpL/UM2ZDY1iiUGT/jsB60Wt2vXKlXfCy4i8Axz5tjYLUI3gqKqx83+P
         WiTAExMVQs73pP/z+J3YbTy8VXkGUNvfdnVY18SLK8UfHsWoced8Q2a6VlJc/8tg5gh3
         g7ng==
In-Reply-To: <20220816185801.651091-1-shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Aug 16, 2022 at 11:58 AM Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Workingset refault stats are important and usefule metrics to measure

*useful

> how well reclaimer and swapping work and how healthy the services are,
> but they are just available for cgroup v2.  There are still plenty users
> with cgroup v1, export the stats for cgroup v1.
>
> Signed-off-by: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
