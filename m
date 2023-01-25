From: Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Wed, 25 Jan 2023 08:06:46 -0300
Message-ID: <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
References: <20230125073502.743446-1-leobras@redhat.com>
         <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674644814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kGyxR4QjlvV59Dun3XoNVcSY9X+5yxzcZa0pgXIqYKk=;
        b=CVrJQR+jUmAmjeYhXbJ57y6uz+YKFzSC8NjpviCW0rpJQcPJC+wUDmXofV13UmFmlA8/Fg
        wm5K5y4Bzk24aLFmmKrweq2TxgBzr6fGmZzomd/LQ4cG//A1XX+BmTqC/DmERdKENt7Zff
        K9mwQZj9H6zzJe49zrbAAn2kv8zDVjg=
In-Reply-To: <Y9DpbVF+JR/G+5Or-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2023-01-25 at 09:33 +0100, Michal Hocko wrote:
> On Wed 25-01-23 04:34:57, Leonardo Bras wrote:
> > Disclaimer:
> > a - The cover letter got bigger than expected, so I had to split it in
> >     sections to better organize myself. I am not very confortable with =
it.
> > b - Performance numbers below did not include patch 5/5 (Remove flags
> >     from memcg_stock_pcp), which could further improve performance for
> >     drain_all_stock(), but I could only notice the optimization at the
> >     last minute.
> >=20
> >=20
> > 0 - Motivation:
> > On current codebase, when drain_all_stock() is ran, it will schedule a
> > drain_local_stock() for each cpu that has a percpu stock associated wit=
h a
> > descendant of a given root_memcg.
> >=20
> > This happens even on 'isolated cpus', a feature commonly used on worklo=
ads that
> > are sensitive to interruption and context switching such as vRAN and In=
dustrial
> > Control Systems.
> >=20
> > Since this scheduling behavior is a problem to those workloads, the pro=
posal is
> > to replace the current local_lock + schedule_work_on() solution with a =
per-cpu
> > spinlock.
>=20
> If IIRC we have also discussed that isolated CPUs can simply opt out
> from the pcp caching and therefore the problem would be avoided
> altogether without changes to the locking scheme. I do not see anything
> regarding that in this submission. Could you elaborate why you have
> abandoned this option?

Hello Michal,

I understand pcp caching is a nice to have.
So while I kept the idea of disabling pcp caching in mind as an option, I f=
irst
tried to understand what kind of impacts we would be seeing when trying to
change the locking scheme.

After I raised the data in the cover letter, I found that the performance i=
mpact
appears not be that big. So in order to try keeping the pcp cache on isolat=
ed
cpus active, I decided to focus effort on the locking scheme change.

I mean, my rationale is: if is there a non-expensive way of keeping the fea=
ture,
why should we abandon it?

Best regards,
Leo







