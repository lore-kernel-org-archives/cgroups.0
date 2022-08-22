From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Date: Mon, 22 Aug 2022 09:07:36 -0700
Message-ID: <CALvZod5mgn6eUaCBV3bNJKA8k_sOAYs5QKyX7at+2OW_+5GNGQ@mail.gmail.com>
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-4-shakeelb@google.com>
 <YwNe3HBxzF+fWb2n@dhcp22.suse.cz> <CALvZod5YGVSTvsg25P6goqyGEY21eVnahsXcs2BGsp6OXxLwsg@mail.gmail.com>
 <YwOfP/6PtS8BxNhz@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=gUVeYVstiPrcbddnMA7a91R1MVlm8VXe4cQjO+uITck=;
        b=qJU/J6milNR1oV5NO1gr1r9vhtxCS9d8ZKRW1oRrJmNJqHRx2lxTImH8vetGV6ilAh
         xUphI7Un4qyUSuEDND0A7UNpIdiG7vRWpyafS5+WDaQhQoAGAG+bLu1MvmhojfFqODDr
         E2t3KE+j4c9Q/2wqW9Adu8yQo2vKApYIwPjwoEFAVlrMSBiR+Iwkb5mq1xKM6v96mpv+
         50JdfOsjLfzxqZv7VnwabsQ0nGoiOw2s7iWe+FOic0ZSVUCpFyO7jFRxcGiKV62loMir
         cdsgS511CkPCukoKUkZNZhTCS8NPNZyo1mRO4Lk3b2TNTW9poBkTfUMYiZOcMyMOgoHn
         YziQ==
In-Reply-To: <YwOfP/6PtS8BxNhz-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Aug 22, 2022 at 8:22 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 22-08-22 08:09:01, Shakeel Butt wrote:
> > On Mon, Aug 22, 2022 at 3:47 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > [...]
> > >
> > > > To evaluate the impact of this optimization, on a 72 CPUs machine, we
> > > > ran the following workload in a three level of cgroup hierarchy with top
> > > > level having min and low setup appropriately. More specifically
> > > > memory.min equal to size of netperf binary and memory.low double of
> > > > that.
> > >
> > > a similar feedback to the test case description as with other patches.
> >
> > What more info should I add to the description? Why did I set up min
> > and low or something else?
>
> I do see why you wanted to keep the test consistent over those three
> patches. I would just drop the reference to the protection configuration
> because it likely doesn't make much of an impact, does it? It is the
> multi cpu setup and false sharing that makes the real difference. Or am
> I wrong in assuming that?
>

No, you are correct. I will cleanup the commit message in the next version.
