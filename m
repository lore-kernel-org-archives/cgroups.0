From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] Revert "mm: add nodes= arg to memory.reclaim"
Date: Fri, 16 Dec 2022 10:18:20 -0800
Message-ID: <20221216101820.3f4a370af2c93d3c2e78ed8a@linux-foundation.org>
References: <20221202223533.1785418-1-almasrymina@google.com>
        <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
        <Y5xASNe1x8cusiTx@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671214701;
        bh=vRbKCiLdExOTUt5BW7wyrYFNrRg54Ri2oAjQj3d/9yk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bln6FejpwP8y1LDhKqmy+1hWW84LthPXn0iMaqmr7jjsV8vUCNoa3AbTP6gTXvcnt
         5k1MnZzSKSjSw8zGq4T3SDYvSuIrSIPn0I5ykHvHgLObdmF1BnKHrl2EV/YTJxvSLm
         jUEqZ7JjMxY2xhleRkc/9KbfpeUuDBAyINIcUquE=
In-Reply-To: <Y5xASNe1x8cusiTx-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, 16 Dec 2022 10:54:16 +0100 Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:

> I have noticed that the patch made it into Linus tree already. Can we
> please revert it because the semantic is not really clear and we should
> really not create yet another user API maintenance problem.

Well dang.  I was waiting for the discussion to converge, blissfully
unaware that the thing was sitting in mm-stable :(  I guess the

	Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
	Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
	Acked-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

fooled me.


I think it's a bit premature to revert at this stage.  Possibly we can
get to the desired end state by modifying the existing code.  Possibly
we can get to the desired end state by reverting this and by adding
something new.

If we can't get to the desired end state at all then yes, I'll send
Linus a revert of this patch later in this -rc cycle.

