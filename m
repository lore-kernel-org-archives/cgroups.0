From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v2 2/3] mm/memcg: __mem_cgroup_remove_exceeded could
 handle a !on-tree mz properly
Date: Wed, 16 Mar 2022 07:54:29 +0800
Message-ID: <CADZGycbApX1D8sn4kCXmpYoB2m3Ysn9Ew-6rmdr6Rfhfv6jRjw@mail.gmail.com>
References: <20220312071623.19050-1-richard.weiyang@gmail.com>
 <20220312071623.19050-2-richard.weiyang@gmail.com> <Yi8Qu/1V4H1M9qZV@dhcp22.suse.cz>
 <20220314225150.fhwny4yhxgjevwxx@master> <YjBT6emPlZD1lg5z@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0xlurKCUM4YSmUkIVypyj8embDeL9DxbXlFAmffyKHk=;
        b=YWSK8NXNXoQdi7hNWVycl/TbZbyaLklUKLlRfiKBEuWLOF0/L8MCT0qMoSamK0odp1
         j/F0IyEUGNK+I3IIPuzjui1frCebhVZ9JzC3hxOaH49yz/TV//yBMXsn3GwArjSJBjX/
         /szB69aoQsdlXaDuD9NLam6OVNouDpHdu8VHZOQfqsJz0CW1ouuoBlG2bMqGTzWer6Dq
         8zsJ9oBClj/hG+jKc0nVWkuyA//yiT9P1VXVfp/65DB3it2wGfiHtlJiItXbHWEY+8cy
         VXPi46LE0urxlF6Oqm2TONwHpQmLC01YM7qYzT34XlkZ+UHBpRfXX2py4hD9hjU2nwY6
         kuvw==
In-Reply-To: <YjBT6emPlZD1lg5z-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Mar 15, 2022 at 4:52 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 14-03-22 22:51:50, Wei Yang wrote:
> > On Mon, Mar 14, 2022 at 10:54:03AM +0100, Michal Hocko wrote:
> > >On Sat 12-03-22 07:16:22, Wei Yang wrote:
> > >> There is no tree operation if mz is not on-tree.
> > >
> > >This doesn't explain problem you are trying to solve nor does it make
> > >much sense to me TBH.
> > >
> >
> > This just tries to make the code looks consistent.
>
> I guess this is rather subjective. One could argue that the check is
> more descriptive because it obviously removes the node from the tree
> when it is on the tree.

Hmm... maybe yes.

If someone else prefer the original one, I am ok with it.

> --
> Michal Hocko
> SUSE Labs
