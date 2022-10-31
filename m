From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Mon, 31 Oct 2022 09:40:15 +0100
Message-ID: <Y1+J7+1V1nJXF+3b@dhcp22.suse.cz>
References: <Y1j7tsj5M0Md/+Er@dhcp22.suse.cz>
 <Y1kl8VbPE0RYdyEB@feng-clx>
 <Y1lZV6qHp3gIINGc@dhcp22.suse.cz>
 <87wn8lkbk5.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1ou5DGHrEsKnhri@dhcp22.suse.cz>
 <87o7txk963.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1o63SWD2KmQkT3v@dhcp22.suse.cz>
 <87fsf9k3yg.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1p5vaN1AWhpNWZx@dhcp22.suse.cz>
 <87bkpwkg24.fsf@yhuang6-desk2.ccr.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667205616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oDEy5wBGcubkZlsFmF0w8hivt9UAci8jukyyYE9ExMU=;
        b=nABlSHmlvMJc1IRbGJhLSNRm6p/PCFEi8GtWySPQrJFa/sZrFVgXIIT0AWemOZuR95acsO
        iriPwjPf8LkiW1s5C6wbMWrf9qL3cyIAou5wla7XaGcxceT2C1DIH9TFH1I/UDevFIPmcf
        p98aKgK331X4lRdAgWidMVmrEqnErX0=
Content-Disposition: inline
In-Reply-To: <87bkpwkg24.fsf-fFUE1NP8JkzwuUmzmnQr+vooFf0ArEBIu+b9c/7xato@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Fri 28-10-22 07:22:27, Huang, Ying wrote:
> Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> writes:
> 
> > On Thu 27-10-22 17:31:35, Huang, Ying wrote:
[...]
> >> I think that it's possible for different processes have different
> >> requirements.
> >> 
> >> - Some processes don't care about where the memory is placed, prefer
> >>   local, then fall back to remote if no free space.
> >> 
> >> - Some processes want to avoid cross-socket traffic, bind to nodes of
> >>   local socket.
> >> 
> >> - Some processes want to avoid to use slow memory, bind to fast memory
> >>   node only.
> >
> > Yes, I do understand that. Do you have any specific examples in mind?
> > [...]
> 
> Sorry, I don't have specific examples.

OK, then let's stop any complicated solution right here then. Let's
start simple with a per-mm flag to disable demotion of an address space.
Should there ever be a real demand for a more fine grained solution
let's go further but I do not think we want a half baked solution
without real usecases.

-- 
Michal Hocko
SUSE Labs
