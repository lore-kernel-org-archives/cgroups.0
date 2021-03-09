From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 1/9] memcg: accounting for allocations called with
 disabled BH
Date: Tue, 9 Mar 2021 12:18:28 -0800
Message-ID: <YEfYFIlRH0+0XWwT@carbon.dhcp.thefacebook.com>
References: <18a0ae77-89ff-2679-ab19-378e38ce2be2@virtuozzo.com>
 <CALvZod4QiAhjgQOGO4KYCs4-GjUmqb6th+4tr8nQ+bPumGFzNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=b15VZGEsdp5KSPZp6Etr9P3PCYHsVwaLa8IbfsH2JCA=;
 b=qxZ58tPkhB+nrGTHC8LN/W2p21Ciw2FgEWUrH6AvT9Qu3eAhFk2bYZyKlk/YIJaBK3Dt
 ctsm/lkG36VvTv8TzSJZkJ4X3b76mdB0q1BeRT4/vua9PQJ/6x8DD56BXRH3D4gOZYwv
 omobY96LMmAYygxy7nSFYvpmSBWIP/85U8k= 
Content-Disposition: inline
In-Reply-To: <CALvZod4QiAhjgQOGO4KYCs4-GjUmqb6th+4tr8nQ+bPumGFzNg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Mar 09, 2021 at 11:39:41AM -0800, Shakeel Butt wrote:
> On Tue, Mar 9, 2021 at 12:04 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> >
> > in_interrupt() check in memcg_kmem_bypass() is incorrect because
> > it does not allow to account memory allocation called from task context
> > with disabled BH, i.e. inside spin_lock_bh()/spin_unlock_bh() sections
> >
> > Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> 
> In that file in_interrupt() is used at other places too. Should we
> change those too?

Yes, it seems so. Let me prepare a fix (it seems like most of them were
introduced by me).

Thanks!
