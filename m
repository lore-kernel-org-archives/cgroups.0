From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: mm/memcontrol.c:5364:1: warning: the frame size of 1032 bytes is
 larger than 1024 bytes [-Wframe-larger-than=]
Date: Thu, 14 Dec 2017 13:16:08 -0500
Message-ID: <20171214181608.GA2476@cmpxchg.org>
References: <a16d8181-3bb4-90cc-3c4b-ac44529494ed@molgen.mpg.de>
 <20171214091917.GE16951@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g2P+v0TzO+TXFgVlnualDwOql9JeYFvsGqvHxHnoApM=; b=IIV7FQcXYFhDluPblnUHVE4yuv
        9Ew8fcAZWBK8jZ89V91MZ9zEBJm9YDaN8DmEaDgcqaldTsf6cYPlkN+qdzfSQNzuU6D4UCnKaLQNb
        NXoqrjmI1cf2qpDKc7an8vGiuWVpJKltg/0C16sFDDO+L/KrcCUEOU7XaL2m/DXG3zow=;
Content-Disposition: inline
In-Reply-To: <20171214091917.GE16951-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paul Menzel <pmenzel+linux-cgroups-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, it+linux-cgroups-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org

On Thu, Dec 14, 2017 at 10:19:17AM +0100, Michal Hocko wrote:
> On Thu 14-12-17 07:49:29, Paul Menzel wrote:
> > I enabled the undefined behavior sanitizer, and built Linus=E2=80=99 ma=
ster branch
> > under Ubuntu 17.10 with gcc (Ubuntu 7.2.0-8ubuntu3) 7.2.0.
> >=20
> > ```
> > $ grep UBSAN /boot/config-4.15.0-rc3+
> > CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=3Dy
> > # CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
> > CONFIG_UBSAN=3Dy
> > CONFIG_UBSAN_SANITIZE_ALL=3Dy
> > # CONFIG_UBSAN_ALIGNMENT is not set
> > CONFIG_UBSAN_NULL=3Dy

> But this depends on the configuration because NR_VM_EVENT_ITEMS enables
> some counters depending on the config. The stack is really large but
> this is a function which is called from a shallow context wrt. stack so
> we should fit into a single page. One way we could do, though, is to
> make those large arrays static and use a internal lock around them.
> Something like the following. What do you think Johannes?

As you said, this is a very shallow stack. Why introduce a global lock
to save memory, when we have a statically allocated 16k kernel stack
which we know is plenty for that call chain? It introduces a potential
bottleneck for nothing in return.
