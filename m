From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
Date: Wed, 13 Jan 2021 10:43:02 -0800
Message-ID: <20210113184302.GA355124@carbon.dhcp.thefacebook.com>
References: <20210112214105.1440932-1-shakeelb@google.com>
 <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com>
 <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
 <CALvZod4am_dNcj2+YZmraCj0+BYHB9PnQqKcrhiOnV8gzd+S3w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=LmOPinyKx8+8x52Th4DE4vt+lyMbSY2O2z3Pq7Ov4WQ=;
 b=MBrRSo97MoA0IaALi2Q5mdd8loBkX+gUGZBShyW4v4jTR4D3GTP4eZc3kZgJURK1y9Qh
 K1h5AVrQGEBHnNW321haB7o29qru8DLyMbzwLV/UD30SHzq72kaSxzy5k7n8nm6AB796
 o102NdaBhYNSI6fOsa6QRP43vj7zxj5yR5Q= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmOPinyKx8+8x52Th4DE4vt+lyMbSY2O2z3Pq7Ov4WQ=;
 b=i90H2L5DAEFMPBA5oVLwjZO0sOQYjczT3D9LpraG7EChgEUlTkLGz7A7SDhga6JpW5ekpdwijAPkEYoWCHDYwcAw5yvNKJHPttY5FuqP6+hpqd0rflJY2hZXYZn8mfniHYOFGzzglkTtl5a0kSGNjGQ+8HiuDneduEXTZrizO4c=
Content-Disposition: inline
In-Reply-To: <CALvZod4am_dNcj2+YZmraCj0+BYHB9PnQqKcrhiOnV8gzd+S3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jan 12, 2021 at 04:18:44PM -0800, Shakeel Butt wrote:
> On Tue, Jan 12, 2021 at 4:12 PM Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> > >
> [snip]
> > > Historically we have a corresponding vmstat counter to each charged page.
> > > It helps with finding accounting/stastistics issues: we can check that
> > > memory.current ~= anon + file + sock + slab + percpu + stack.
> > > It would be nice to preserve such ability.
> > >
> >
> > Perhaps one option would be to have it count as a file page, or have a
> > new category.
> >
> 
> Oh these are actually already accounted for in NR_FILE_MAPPED.

Well, it's confusing. Can't we fix this by looking at the new page memcg flag?
