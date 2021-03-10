From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 1/9] memcg: accounting for allocations called with
 disabled BH
Date: Wed, 10 Mar 2021 11:09:04 -0800
Message-ID: <YEkZUGc/Kw56MwwA@carbon.dhcp.thefacebook.com>
References: <18a0ae77-89ff-2679-ab19-378e38ce2be2@virtuozzo.com>
 <CALvZod4QiAhjgQOGO4KYCs4-GjUmqb6th+4tr8nQ+bPumGFzNg@mail.gmail.com>
 <YEfYFIlRH0+0XWwT@carbon.dhcp.thefacebook.com>
 <YEiUhWjsC6HbYFpT@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=SqrnM5rUjX4Rc9LZhCE/7SAx5fRzevVuNPcpF1zfDD4=;
 b=fGeXerzzx5wAmKbDRy14oL0y8MUXL4x/NKc6/WSqZx/+1JtNIHb4ZLeYtylsbgYiS2xp
 hGI+zWWeOeGBMx97GlYHlxKAhp5Oyo4JnZLO3nwyh9WRjAc7WUdOAe+wa089KnZPWoMr
 QgAacUAmtDZ2F9pZacz14fXar6QNhrE3b1c= 
Content-Disposition: inline
In-Reply-To: <YEiUhWjsC6HbYFpT-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Mar 10, 2021 at 10:42:29AM +0100, Michal Hocko wrote:
> On Tue 09-03-21 12:18:28, Roman Gushchin wrote:
> > On Tue, Mar 09, 2021 at 11:39:41AM -0800, Shakeel Butt wrote:
> > > On Tue, Mar 9, 2021 at 12:04 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> > > >
> > > > in_interrupt() check in memcg_kmem_bypass() is incorrect because
> > > > it does not allow to account memory allocation called from task context
> > > > with disabled BH, i.e. inside spin_lock_bh()/spin_unlock_bh() sections
> > > >
> > > > Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> > > 
> > > In that file in_interrupt() is used at other places too. Should we
> > > change those too?
> > 
> > Yes, it seems so. Let me prepare a fix (it seems like most of them were
> > introduced by me).
> 
> Does this affect any existing in-tree users?

I'll double check this, but I doubt. We should fix it anyway, but I don't think
we need any stable backports.
