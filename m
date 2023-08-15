From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Mon, 14 Aug 2023 14:47:55 -1000
Message-ID: <ZNrLO5PAEZw4yjI9@slm.duckdns.org>
References: <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
 <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
 <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
 <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew@mail.gmail.com>
 <ZNdEaw2nktq1NfmH@dhcp22.suse.cz>
 <CAJD7tkaFHgc3eN1K1wYsQFWMLu4+Frf9DJ-5HOja2nC20Es9Dw@mail.gmail.com>
 <ZNrDWqfjXtAYhnvT@slm.duckdns.org>
 <CAJD7tkYBFz-gZ2QsHxUMT=t0KNXs66S-zzMPebadHx9zaG0Q3w@mail.gmail.com>
 <ZNrITZVTf2EILRJq@slm.duckdns.org>
 <CAJD7tkaXwoF-faApweAmm7Db7jAuS3EO7hVvdyVtqW_rE+T9Vg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692060477; x=1692665277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nNEJH3hSSRRHyRk+tOxvRsyumLi4vURSWSdvolmYkGg=;
        b=BFRuwagfFi9+OedefmC8mcbgzAetuiMxU/z+Brfx5yvijvQeffS9HYxWoftGxN0iAn
         XlpfCa1jBU1A2gAAU0DqCZlvtCCvqBOfZ5jnQ/QP6hAYNDNPFcw8PHQ1r7QAaGH/rYBL
         pyar1XexlSvHmjHuilFQEuVejUCSSY14DcGnPOkG8G/kisQw5MPaUrlKsK/cSFlGvx52
         5KdNvhtEDXpB5vKzIeIj8GXhVLyuS5AI6K5AY2NZcdTxn5++l8bcL6j6s+xcwAcSvJ4x
         UEAf/nH9NkphyEM+A6WsCS7/d5up3bJXvnJbuZiE/HEag9ZlIpWaIftXFL+auU873v54
         WS+w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkaXwoF-faApweAmm7Db7jAuS3EO7hVvdyVtqW_rE+T9Vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Aug 14, 2023 at 05:39:15PM -0700, Yosry Ahmed wrote:
> I believe dropping unified flushing, if possible of course, may fix
> both problems.

Yeah, flushing the whole tree for every stat read will push up the big O
complexity of the operation. It shouldn't be too bad because only what's
updated since the last read will need flushing but if you have a really big
machine with a lot of constantly active cgroups, you're still gonna feel it.
So, yeah, drop that and switch the global lock to mutex and we should all be
good?

Thanks.

-- 
tejun
