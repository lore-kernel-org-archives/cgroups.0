From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] Revert "mm: add nodes= arg to memory.reclaim"
Date: Mon, 19 Dec 2022 14:42:52 -0800
Message-ID: <20221219144252.f3da256e75e176905346b4d1@linux-foundation.org>
References: <20221202223533.1785418-1-almasrymina@google.com>
        <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
        <Y5xASNe1x8cusiTx@dhcp22.suse.cz>
        <20221216101820.3f4a370af2c93d3c2e78ed8a@linux-foundation.org>
        <Y52Scge3ynvn/mB4@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671489773;
        bh=BGre2r5SHKHnb8b4Q50Q+a/dxymK6XCdQgeYGSWrbak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lpbVP7fJ/uOaGEd9aeQZ3P2o/kt4VheUXmT+dpCikhKJTLyA5nZhN69lTh+1W5j/d
         qcDyiIudJ3f7/d8OI3zQmbTIiBqFrdiZTeEfCcpiXrHtRWQxjBK5P9AVk4mTHu/NqH
         JSYoHx0maXMcg7CuyoiiZnQARL/sW0ZOGa8qWNEY=
In-Reply-To: <Y52Scge3ynvn/mB4-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sat, 17 Dec 2022 10:57:06 +0100 Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:

> > I think it's a bit premature to revert at this stage.  Possibly we can
> > get to the desired end state by modifying the existing code.  Possibly
> > we can get to the desired end state by reverting this and by adding
> > something new.
> 
> Sure if we can converge to a proper implementation during the rc phase
> then it would be ok. I cannot speak for others but at least for me
> upcoming 2 weeks would be mostly offline so I cannot really contribute
> much. A revert would be much more easier from the coordination POV IMHO.
> 
> Also I do not think there is any strong reason to rush this in. I do not
> really see any major problems to have this extension in 6.2

I'll queue the revert in mm-unstable with a plan to merge it upstream
around the -rc5 timeframe if there hasn't been resolution.

Please check Mina's issues with this revert's current changelog and
perhaps send along a revised one.

