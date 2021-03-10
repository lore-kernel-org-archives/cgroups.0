From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/9] memcg: accounting for allocations called with
 disabled BH
Date: Wed, 10 Mar 2021 10:42:29 +0100
Message-ID: <YEiUhWjsC6HbYFpT@dhcp22.suse.cz>
References: <18a0ae77-89ff-2679-ab19-378e38ce2be2@virtuozzo.com>
 <CALvZod4QiAhjgQOGO4KYCs4-GjUmqb6th+4tr8nQ+bPumGFzNg@mail.gmail.com>
 <YEfYFIlRH0+0XWwT@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615369350; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8qLZFJropWuTtqmng7j/uyvEO07U2wdIf80qxM4muyg=;
        b=lSDSOY1L1zj619JWFQuby2KTVCU26IkluUftoipiD8kBZ1LPFlwt1muJ5NEedjn9QC6ilf
        rWkTetl8hkNmE3ozGWCjgdUIlKwqEPldWEixmPPq2A/sY+d96fK2bhje1TWQD+3g5v7th+
        c/t0DM9sMHrxxJW3Ni07ZgbOalDRRtA=
Content-Disposition: inline
In-Reply-To: <YEfYFIlRH0+0XWwT-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue 09-03-21 12:18:28, Roman Gushchin wrote:
> On Tue, Mar 09, 2021 at 11:39:41AM -0800, Shakeel Butt wrote:
> > On Tue, Mar 9, 2021 at 12:04 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> > >
> > > in_interrupt() check in memcg_kmem_bypass() is incorrect because
> > > it does not allow to account memory allocation called from task context
> > > with disabled BH, i.e. inside spin_lock_bh()/spin_unlock_bh() sections
> > >
> > > Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> > 
> > In that file in_interrupt() is used at other places too. Should we
> > change those too?
> 
> Yes, it seems so. Let me prepare a fix (it seems like most of them were
> introduced by me).

Does this affect any existing in-tree users?
-- 
Michal Hocko
SUSE Labs
