From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v5 00/11] Use obj_cgroup APIs to charge the LRU pages
Date: Thu, 9 Jun 2022 11:09:50 +0800
Message-ID: <CAMZfGtUqMfhSLLDLO6Dnj9+1HNM1jNTqDZN5higNoR1gRYnbbQ@mail.gmail.com>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <CAMZfGtX4hseDnJA9JrsXDG=nu28h+9UMMpKFnBZCL47Re1OvUg@mail.gmail.com> <YqFgt6nZn78euEb/@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=prJZ/uo7UIALihmdPzzIspieUD/287bdX03VvGNkEtE=;
        b=REUWSS+ZiecOI0jFJ+1hDHJWaaNE+Uma0xvvhpPRCKbT3/8Wub2DzjO90JbYnUOBky
         qiNoFUI0Acou00j/JzbGRebEl06K0lRV5oG+kaZIAqOBG3INGWR28oj1ifMGH8DS4ZOv
         s/1cp4XxA1i5QEJvF0dnO+CRR1q20nsbIkzczmGdunl5zMxzGxzZzIOMzC2enKeEP7SO
         knvk8yK3HJJwDj+bW7FsUoFaveNOZrg3LxaFHDSZlx2A4rV/rmSjblb8OLVVQ6/+WOUO
         x04hz9I92bnFYhEsJTQb2RtL8mO2io8GYmtHw31ieV++wckU1ZDCLM9RX3QsCOtgsP3J
         /2xA==
In-Reply-To: <YqFgt6nZn78euEb/@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Xiongchun duan <duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Jun 9, 2022 at 10:53 AM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
>
> On Thu, Jun 09, 2022 at 10:43:24AM +0800, Muchun Song wrote:
> > Hi,
> >
> > Friendly ping. Any comments or objections?
>
> I'm sorry, I was recently busy with some other stuff, but it's on my todo list.
> I'll try to find some time by the end of the week.

Got it. Thanks Roman. Looking forward to your reviews.

>
> Thanks!
>
> >
> > Thanks.
> >
> > On Mon, May 30, 2022 at 3:50 PM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> > >
> > > This version is rebased on v5.18.
> > >
> > > Since the following patchsets applied. All the kernel memory are charged
> > > with the new APIs of obj_cgroup.
> > >
> > >         [v17,00/19] The new cgroup slab memory controller [1]
> > >         [v5,0/7] Use obj_cgroup APIs to charge kmem pages [2]
>
> Btw, both these patchsets were merged a long time ago, so you can refer
> to upstream commits instead.

Will do.

Thanks.
