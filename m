From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH 4/4] mm: memcontrol: fix swap uncharge on
 cgroup v2
Date: Mon, 15 Feb 2021 11:24:31 +0100
Message-ID: <YCpL357b8GFRYo1T@dhcp22.suse.cz>
References: <20210212170159.32153-1-songmuchun@bytedance.com>
 <20210212170159.32153-4-songmuchun@bytedance.com>
 <YCpDSnLSDoE/FHK5@dhcp22.suse.cz>
 <CAMZfGtVSXG5BRR9R3_+eeoCCWBW87GLVNLPwZCyDUHNeAPrXUw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613384672; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S/uXPqP/TPAc7XRGUiDHNcqY2NlR0ZY7sWeSVPIWRdU=;
        b=byxFEEer+FNeRJefGNaijsTv6q5BgfdLMmDFs1e5b857DcUUx1kH37qGAJaiZMlddjghyP
        v/1T9hEEquxK4/1h+tm8tkcdDWZSzsP2N4T6I6up164j8+LGl2u6O9G5c5eob7Wgm8P00B
        kRekUTvPEJESkt1i5RxABRMr6shqbVE=
Content-Disposition: inline
In-Reply-To: <CAMZfGtVSXG5BRR9R3_+eeoCCWBW87GLVNLPwZCyDUHNeAPrXUw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon 15-02-21 18:15:36, Muchun Song wrote:
> On Mon, Feb 15, 2021 at 5:47 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Sat 13-02-21 01:01:59, Muchun Song wrote:
> > > The swap charges the actual number of swap entries on cgroup v2.
> > > If a swap cache page is charged successful, and then we uncharge
> > > the swap counter. It is wrong on cgroup v2. Because the swap
> > > entry is not freed.
> >
> > Is there any actual problem though? Can you describe the specific
> > scenario please? Swap cache charge life time is a bit tricky and I have
> > to confess I have to relearn it every time I need to understand it. The
> > patch would be much more easier to review if the changelog was much more
> > specific.
> 
> I copied the reply to Shakeel here. :-)

Not helpful much. I have seen that reply before answering your patch.
I really have to say I find it rather annoying to constantly get unclear
and cryptic responses from you. This is a subtle area! Make your claims
clear and specific so they can be verified.

-- 
Michal Hocko
SUSE Labs
