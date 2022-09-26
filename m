From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [sparc64] fails to boot, (was: Re: [PATCH memcg v6] net: set
 proper memcg for net_init hooks allocations)
Date: Mon, 26 Sep 2022 10:36:31 -0700
Message-ID: <20220926103631.8cb144a6d0b683915b0ecb10@linux-foundation.org>
References: <6b362c6e-9c80-4344-9430-b831f9871a3c@openvz.org>
        <f9394752-e272-9bf9-645f-a18c56d1c4ec@openvz.org>
        <20220918092849.GA10314@u164.east.ru>
        <CADxRZqyyHAtzaaPjcKi8AichGew2yi-_vQcKoLoxPanLvXZL0g@mail.gmail.com>
        <20220921170259.GI8331@blackbody.suse.cz>
        <CADxRZqyAG5Co9hLEp6p8vPC9WyGERR6un-3Rqapyv14G4vPXJw@mail.gmail.com>
        <20220926102812.2b0696a7@kernel.org>
        <CALvZod5QProaWZgT9ykb-vrrRHBpLfqVGgW2jd-Td8aX5MBZFw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664213795;
        bh=d8R/sf+/F1E5Bfqo0FLK1XydgttpS5flZpUHlwRHdYE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sq2/cFT6vMw7tZBcj6VZqz7Qxjm497e4Rfi0bSbjdsEpmM/a7gJQRHzuOsBjEPAkO
         q7nDzwvBxRYhQQm4B57MbY8PHjVI7RTULXUEEJDyw+kraeZ88Vi/+zrdU4knn3NjbI
         bffaPRaZmNma6nbfMDj1PMjC28BOYFqKynVRkWgs=
In-Reply-To: <CALvZod5QProaWZgT9ykb-vrrRHBpLfqVGgW2jd-Td8aX5MBZFw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Anatoly Pugachev <matorola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sparc kernel list <sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, 26 Sep 2022 10:32:49 -0700 Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> > Forgive my uniformed chime-in but Linus seemed happy with the size of
> > -rc7 and now I'm worried there won't be an -rc8. AFAICT this is a 6.0
> > regression. Vasily, Shakeel, do we have a plan to fix this?
> 
> I was actually waiting for Vasily to respond. Anyways, I think the
> easiest way to proceed is to revert the commit 1d0403d20f6c ("net: set
> proper memcg for net_init hooks allocations"). We can debug the issue
> in the next cycle.

If agreeable, could someone please send along a tested and changelogged
patch to do this?

