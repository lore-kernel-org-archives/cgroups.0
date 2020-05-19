From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v4 3/4] mm: move cgroup high memory limit setting
 into struct page_counter
Date: Tue, 19 May 2020 16:14:38 -0700
Message-ID: <20200519161438.4f11ddec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200519171938.3569605-1-kuba@kernel.org>
        <20200519171938.3569605-4-kuba@kernel.org>
        <CALvZod4i2sBWcbKe3MHMuSMV3ywWwQx1Xr-abEqPS6n8vioC7w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589930081;
        bh=kFVmk07C+lCDPUldrdSqVB+RgnW09KwNynO8E7jgKP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CPvadw6o4TkrMm6zhPGc/Fm7a62w+1BbAGeTO3S9haFDCVPS7RIna8lD5ssh74RjP
         t+aMesV4qDTyelgVbrAZFZ5m76cba3pUP5ZgvDc+UiLt5BRCjEKdpmGFWbeBiBkng6
         PD9W9jab6gryKkZMUotBU+FXCbEVp9YXN/5Ma6RA=
In-Reply-To: <CALvZod4i2sBWcbKe3MHMuSMV3ywWwQx1Xr-abEqPS6n8vioC7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, 19 May 2020 15:15:41 -0700 Shakeel Butt wrote:
> > --- a/mm/page_counter.c
> > +++ b/mm/page_counter.c
> > @@ -198,6 +198,11 @@ int page_counter_set_max(struct page_counter *counter, unsigned long nr_pages)
> >         }
> >  }
> >
> > +void page_counter_set_high(struct page_counter *counter, unsigned long nr_pages)
> > +{
> > +       WRITE_ONCE(counter->high, nr_pages);
> > +}
> > +  
> 
> Any reason not to make this static inline like
> page_counter_is_above_high() and in page_counter.h?

My reason was consistency with other page_counter_set_xyz() helpers,
but obviously happy to change if needed...
