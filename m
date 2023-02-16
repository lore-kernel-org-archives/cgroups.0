From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Thu, 16 Feb 2023 08:45:38 -0400
Message-ID: <Y+4lcq4Fge27TQIn@nvidia.com>
References: <Y+Fttp1ozejoSQzl@slm.duckdns.org>
 <CAJD7tkb_Cr7rTTpKc1VBpS8h=n3Hu+nGiV8dkLH-NdC1bSG9mg@mail.gmail.com>
 <Y+GA6Y7SVhAW5Xm9@slm.duckdns.org>
 <CAJD7tka6SC1ho-dffV0bK_acoZd-5DQzBOy0xg3TkOFG1zAPMg@mail.gmail.com>
 <Y+GMbWWP/YhtJQqe@slm.duckdns.org>
 <Y+GQB9I6MFN6BOFw@nvidia.com>
 <Y+GcJQRhvjqFaaSp@mtj.duckdns.org>
 <Y+0rxoM4w9nilUMZ@dhcp22.suse.cz>
 <Y+0tWZxMUx/NZ3Ne@nvidia.com>
 <Y+3jcw9vo4ml5p0M@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dueX91XBPxeg3KkiY0Sk6ldj36DhXEK4K7I69eP3Ybs=;
 b=X71sqwUEX9xGSBw9vUgX1TE1rviSXoyGnsvaC32q5bW3vZmdhrJNa95st8ls2sFoJVEEZsHyv+2sjRN8lQFz9BpFQRKYzM8XiepQkwLP4r6sR+fbIrKlcxT0nJHhsqkbxR4wcDFZ+VMUiR1tJ1drUmH4qL62PWSXZjGDo/f0q1XNROrc14V3FynZ9W1sWGVlBKkUbSysJWUXpjEnTtTyjXNthcLh2Bdw9BePTY4+LSItLP7ALYep+qXyJ84d/GsboIepPdStPHYHvMr4Esl3c2IYaKiOtX+vnzfgWMBkwaFWQvvDEZzE7Lsn+JN0d4uEgK3GcKRcMeHDjDWC6/9XqA==
Content-Disposition: inline
In-Reply-To: <Y+3jcw9vo4ml5p0M-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Feb 16, 2023 at 09:04:03AM +0100, Michal Hocko wrote:

> > In most cases the ownship traces back to a file descriptor. When the
> > file is closed the pin goes away.
> 
> This assumes a specific use of {un}pin_user_page*, right? IIUC the
> cgroup charging is meant to be used from vm_account but that doesn't
> really tell anything about the lifetime nor the ownership. Maybe this is
> just a matter of documentation update...

Yes documentation.

> > > The interface itself doesn't talk about
> > > anything like that and so it seems perfectly fine to unpin from a
> > > completely different context then pinning. 
> > 
> > Yes, concievably the close of the FD can be in a totally different
> > process with a different cgroup.
> 
> Wouldn't you get an unbalanced charges then? How can admin recover that
> situation?

No, the approach in this patch series captures the cgroup that was
charged and stores it in the FD until uncharge.

This is the same as we do today for rlimit. The user/process that is
charged is captured and the uncharge always applies to user/process
that was charged, not the user/process that happens to be associated
with the uncharging context.

cgroup just add another option so it is user/process/cgroup that can
hold the charge.

It is conceptually similar to how each struct page has the memcg that
its allocation was charged to - we just record this in the FD not the
page.

> > > Another thing that is not really clear to me is how the limit is
> > > actually going to be used in practice. As there is no concept of a
> > > reclaim for pins then I can imagine that it would be quite easy to
> > > reach the hard limit and essentially DoS any further use of pins. 
> > 
> > Yes, that is the purpose. It is to sandbox pin users to put some limit
> > on the effect they have on the full machine.
> > 
> > It replaces the rlimit mess that was doing the same thing.
> 
> arguably rlimit has a concept of the owner at least AFAICS. I do realize
> this is not really great wrt a high level resource control though.

rlimit uses either the user or the process as the "owner". In this
model we view a cgroup as the "owner". The lifetime logic is all the
same, you figure out the owner (cgroup/user/process) when the charge
is made and record it, when the uncharge comes the recorded owner is
uncharged.

It never allows unbalanced charge/uncharge because that would be a
security problem even for rlimit cases today.

Jason
