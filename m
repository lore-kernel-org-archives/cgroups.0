From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Tue, 21 Feb 2023 06:51:48 -1000
Message-ID: <Y/T2pNQ70eMAl1sX@slm.duckdns.org>
References: <CAJD7tkb_Cr7rTTpKc1VBpS8h=n3Hu+nGiV8dkLH-NdC1bSG9mg@mail.gmail.com>
 <Y+GA6Y7SVhAW5Xm9@slm.duckdns.org>
 <CAJD7tka6SC1ho-dffV0bK_acoZd-5DQzBOy0xg3TkOFG1zAPMg@mail.gmail.com>
 <Y+GMbWWP/YhtJQqe@slm.duckdns.org>
 <Y+GQB9I6MFN6BOFw@nvidia.com>
 <Y+GcJQRhvjqFaaSp@mtj.duckdns.org>
 <Y+0rxoM4w9nilUMZ@dhcp22.suse.cz>
 <Y+0tWZxMUx/NZ3Ne@nvidia.com>
 <Y+3jcw9vo4ml5p0M@dhcp22.suse.cz>
 <Y+4lcq4Fge27TQIn@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=paiWRoNE8g4hLYXHv2XDWIFqYN/iFdKjh/xR/nU7dP0=;
        b=QJFpoZExKw/R6r2PUd+5zNoa5+G7LbcTOlmyv9bYwCRc5oRXqPs0cXfyZrDZQvOx5r
         NJwt1nZDhqLQfxwo2fy2XfsfqJSQj6w2qwIqL9JLosB3hr5ZTjA00J3/L4I8NI3vUVxt
         V09PAMnguaISmOA7ewfvBPUYM8fkT7FPC5ugQakxDemwbkvtugIo9X6re+G8cbC7ifSa
         zL15HNoHTariSPDw/igK8OFTfJvpTkPGAD6iLlY07tZ96GfsOO3H6JEURvDtL26TDdJV
         /WbjWfu1QRSWfVBytw5xsskhhfDzZE5KaqhgaGo+JJT2i3CilKr+EujAv5TgMBjZVmPD
         Ge7w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y+4lcq4Fge27TQIn-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Thu, Feb 16, 2023 at 08:45:38AM -0400, Jason Gunthorpe wrote:
> On Thu, Feb 16, 2023 at 09:04:03AM +0100, Michal Hocko wrote:
> 
> > > In most cases the ownship traces back to a file descriptor. When the
> > > file is closed the pin goes away.
> > 
> > This assumes a specific use of {un}pin_user_page*, right? IIUC the
> > cgroup charging is meant to be used from vm_account but that doesn't
> > really tell anything about the lifetime nor the ownership. Maybe this is
> > just a matter of documentation update...
> 
> Yes documentation.
> 
> > > > The interface itself doesn't talk about
> > > > anything like that and so it seems perfectly fine to unpin from a
> > > > completely different context then pinning. 
> > > 
> > > Yes, concievably the close of the FD can be in a totally different
> > > process with a different cgroup.
> > 
> > Wouldn't you get an unbalanced charges then? How can admin recover that
> > situation?
> 
> No, the approach in this patch series captures the cgroup that was
> charged and stores it in the FD until uncharge.
> 
> This is the same as we do today for rlimit. The user/process that is
> charged is captured and the uncharge always applies to user/process
> that was charged, not the user/process that happens to be associated
> with the uncharging context.
> 
> cgroup just add another option so it is user/process/cgroup that can
> hold the charge.
> 
> It is conceptually similar to how each struct page has the memcg that
> its allocation was charged to - we just record this in the FD not the
> page.

I don't have a lot of context here but it looks like the problem here is
that the newly proposed controller is introducing an ownership discrepancy.
If a memory which is pinned by a cgroup is to be charged to the owner of the
fd, the memory which isn't pinned should be charged to the memcg of the same
cgroup, right? It makes little sense to me to separate the owner of the
memory page and the pinner of it. They should be one and the same.

Alistair, can you please elaborate how these pages are allocated, charged
and used?

Thanks.

-- 
tejun
