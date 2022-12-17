From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] Revert "mm: add nodes= arg to memory.reclaim"
Date: Sat, 17 Dec 2022 10:57:06 +0100
Message-ID: <Y52Scge3ynvn/mB4@dhcp22.suse.cz>
References: <20221202223533.1785418-1-almasrymina@google.com>
 <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
 <Y5xASNe1x8cusiTx@dhcp22.suse.cz>
 <20221216101820.3f4a370af2c93d3c2e78ed8a@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1671271027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SoLRNQRrRqUNC0cGrLyDcGJ7nXiwl9BQ5rqnla0AEQg=;
        b=LzEcwgGhGGz8nj03JB5W4TiSbEKztKdG7hrQa5MIO0bwc5t2NC30MAA0U3vd2UhSj4T2Pz
        Tx7x3OMd+ZGReDRDIwwbXqxis7W8upuGmgfxuw87vV+OuG3oq1SRHDCSet4bS0DJKP0ag6
        XpG0vDOWegM0J6b+oztGV495X5UdU2I=
Content-Disposition: inline
In-Reply-To: <20221216101820.3f4a370af2c93d3c2e78ed8a-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 16-12-22 10:18:20, Andrew Morton wrote:
> On Fri, 16 Dec 2022 10:54:16 +0100 Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> 
> > I have noticed that the patch made it into Linus tree already. Can we
> > please revert it because the semantic is not really clear and we should
> > really not create yet another user API maintenance problem.
> 
> Well dang.  I was waiting for the discussion to converge, blissfully
> unaware that the thing was sitting in mm-stable :(  I guess the
> 
> 	Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> 	Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 	Acked-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> fooled me.

Hmm, as pointed out in http://lkml.kernel.org/r/Y5bsmpCyeryu3Zz1-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org
I've failed to see through all the consequences of the implementation.
SO my bad here to add my ack before fully understanding all the
implications.

> I think it's a bit premature to revert at this stage.  Possibly we can
> get to the desired end state by modifying the existing code.  Possibly
> we can get to the desired end state by reverting this and by adding
> something new.

Sure if we can converge to a proper implementation during the rc phase
then it would be ok. I cannot speak for others but at least for me
upcoming 2 weeks would be mostly offline so I cannot really contribute
much. A revert would be much more easier from the coordination POV IMHO.

Also I do not think there is any strong reason to rush this in. I do not
really see any major problems to have this extension in 6.2

-- 
Michal Hocko
SUSE Labs
