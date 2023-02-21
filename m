From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Tue, 21 Feb 2023 07:29:18 -1000
Message-ID: <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
References: <CAJD7tka6SC1ho-dffV0bK_acoZd-5DQzBOy0xg3TkOFG1zAPMg@mail.gmail.com>
 <Y+GMbWWP/YhtJQqe@slm.duckdns.org>
 <Y+GQB9I6MFN6BOFw@nvidia.com>
 <Y+GcJQRhvjqFaaSp@mtj.duckdns.org>
 <Y+0rxoM4w9nilUMZ@dhcp22.suse.cz>
 <Y+0tWZxMUx/NZ3Ne@nvidia.com>
 <Y+3jcw9vo4ml5p0M@dhcp22.suse.cz>
 <Y+4lcq4Fge27TQIn@nvidia.com>
 <Y/T2pNQ70eMAl1sX@slm.duckdns.org>
 <Y/T+pw25oGmKqz1k@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CtEZ/7pnoyH06jUq+fgMxtlXiNC1jdAF93zVpBlKNvs=;
        b=mwAbh7M9wX3g1OzbvYABaL+kfK7rqeaqAMqPsEu9mPBCxmgk1N5zZECvq0Ss/MlzOD
         ROLyIRXLTZkTovztN4E21qQcT7ddYAkDbnNUlyw53talFh762BRNcyOyVpEDMg8g3B9u
         jykabVaGMXGLfiUat5SxJsNSFyraLPtDLRf+ITb5xxLKY4PASUCZnIOs3hjg1YPRk5Lt
         0kEytg6sLdm3KQTD0RbRdQ0Zm2BEY5TX6QXhIGu5FQTJpNtpNF2huHAdKOHpLei2igGJ
         C3rfRljyrxSRtoCGlF1kUWXRKEvfveiSGOD1SFYBImSqr3JJOlxH2edGQ7qtWRbXCZIO
         FyZQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y/T+pw25oGmKqz1k-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Feb 21, 2023 at 01:25:59PM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 21, 2023 at 06:51:48AM -1000, Tejun Heo wrote:
> > cgroup, right? It makes little sense to me to separate the owner of the
> > memory page and the pinner of it. They should be one and the same.
> 
> The owner and pinner are not always the same entity or we could just
> use the page's cgroup.

Yeah, so, what I'm trying to say is that that might be the source of the
problem. Is the current page ownership attribution correct given that the fd
for whatever reason is determining the pinning ownership or should the page
ownership be attributed the same way too? If they indeed need to differ,
that probably would need pretty strong justifications.

Thanks.

-- 
tejun
