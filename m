From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Tue, 21 Feb 2023 09:49:12 -1000
Message-ID: <Y/UgOEv2/KzapGPN@slm.duckdns.org>
References: <Y+0tWZxMUx/NZ3Ne@nvidia.com>
 <Y+3jcw9vo4ml5p0M@dhcp22.suse.cz>
 <Y+4lcq4Fge27TQIn@nvidia.com>
 <Y/T2pNQ70eMAl1sX@slm.duckdns.org>
 <Y/T+pw25oGmKqz1k@nvidia.com>
 <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
 <Y/UEkNn0O65Pfi4e@nvidia.com>
 <Y/UIURDjR9pv+gzx@slm.duckdns.org>
 <Y/Ua6VcNe/DFh7X4@nvidia.com>
 <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E6K/xl9e8Q8bnQo/ivH2EBeLdam1+5jz+038tWO9HPw=;
        b=o5K60sI+5b3Joc4VXeVEsRTLlEHrmHo5Gm6MHi2NP7SDV2A81z5eipAA9fm5uwEetY
         GBJ4jybLksDDpDVvHpL1gkdPkiSdY9KNYSnHlCdWWTo7pZsL7fP1jDUFx/7sMfYrWRcd
         OtyismMkU3X8VhAEWlZZ9PILlrAIfgFEU9yD39Nnsrux59EyB/mDrjYaSn7uOgkaodJm
         Cz2EAJgG19XlI7GL+Kjl0IU51wTslY3dBPCvHHsonTa9ZfKL0619LUHf5VMqnw3JC98g
         TnsITtSZFCp9FbjlgSL+PKOJRoks8jQMaEYlGQReJvGKABTS3rygU6XGL0HJ3JhGKi3N
         6dng==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Feb 21, 2023 at 09:45:15AM -1000, Tejun Heo wrote:
> > Multiple cgroup can pin the same page, so it is not as simple as just
> > transfering ownership, we need multi-ownership and to really fix the
> > memcg limitations with MAP_SHARED without an API impact.
> > 
> > You are right that pinning is really just a special case of
> > allocation, but there is a reason the memcg was left with weak support
> > for MAP_SHARED and changing that may be more than just hard but an
> > infeasible trade off..
> > 
> > At least I don't have a good idea how to even approach building a
> > reasonable datstructure that can track the number of
> > charges per-cgroup per page. :\
> 
> As I wrote above, I don't think the problem here is the case of pages being
> shared by multiple cgroups concurrently. We can leave that problem for
> another thread. However, if we want to support accounting and control of
> pinned memory, we really shouldn't introduce a fundmental discrepancy like
> the owner and pinner disagreeing with each other. At least conceptually, the
> solution is rather straight-forward - whoever pins a page should also claim
> the ownership of it.

Ah, sorry, I missed the part about multiple cgroups pinning the same page.
Yeah, I can't think of a good answer for that.

Thanks.

-- 
tejun
