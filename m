From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Mon, 6 Feb 2023 14:32:37 -1000
Message-ID: <Y+GcJQRhvjqFaaSp@mtj.duckdns.org>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <c7b5e502d1a3b9b8f6e96cbf9ca553b143c327e0.1675669136.git-series.apopple@nvidia.com>
 <Y+Fttp1ozejoSQzl@slm.duckdns.org>
 <CAJD7tkb_Cr7rTTpKc1VBpS8h=n3Hu+nGiV8dkLH-NdC1bSG9mg@mail.gmail.com>
 <Y+GA6Y7SVhAW5Xm9@slm.duckdns.org>
 <CAJD7tka6SC1ho-dffV0bK_acoZd-5DQzBOy0xg3TkOFG1zAPMg@mail.gmail.com>
 <Y+GMbWWP/YhtJQqe@slm.duckdns.org>
 <Y+GQB9I6MFN6BOFw@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yg/htWu0h5ky+EZYsIhtW9pYXyUpBD0h03Dnr/pHD7Y=;
        b=d2qVKAn3/FIUwu+zOygjEPGFy97MBnBGsttXg8EOJqeIM2iEvN2VFDmES4qVDmBv5i
         yGmrObVu2A6QXjJhUL7fHvZlbAg0b4cuS24cGrzzNjiEU3Cm/vgsztB9B98BvUrrC/y9
         byTpHLXW3xY7Tw6ESTfeCHNFETuNApMcEUJ91y+/cS+YPVtJswhVedc4VvBRSbOw48b2
         J0S/CO1py7yzLJbNh7fogdekTRrUb/4U3ggx6bNTaXX/OadYifqxCHOSkZSAg6UC4TvY
         2jHPBqS/DZE5LCIGRkv5WUE2C+t5DEfgqo4CqBDJQ8eRNXrgXzq6THP917nV+zL5I270
         QGiA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y+GQB9I6MFN6BOFw-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Mon, Feb 06, 2023 at 07:40:55PM -0400, Jason Gunthorpe wrote:
> (a) kind of destroys the point of this as a sandboxing tool
> 
> It is not so harmful to use memory that someone else has been charged
> with allocating.
> 
> But it is harmful to pin memory if someone else is charged for the
> pin. It means it is unpredictable how much memory a sandbox can
> actually lock down.
> 
> Plus we have the double accounting problem, if 1000 processes in
> different cgroups open the tmpfs and all pin the memory then cgroup A
> will be charged 1000x for the memory and hit its limit, possibly
> creating a DOS from less priv to more priv

Let's hear what memcg people think about it. I'm not a fan of disassociating
the ownership and locker of the same page but it is true that actively
increasing locked consumption on a remote cgroup is awkward too.

Thanks.

-- 
tejun
