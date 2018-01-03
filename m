From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroup.stat
Date: Wed, 3 Jan 2018 13:59:04 +0000
Message-ID: <20180103135858.GA15200@castle.DHCP.thefacebook.com>
References: <196c0cca-b573-8c65-2b5f-66376f79a836@gmail.com>
 <20180102215726.GA2606@castle>
 <7cfbf94e-71c8-b49e-7483-79c3fa363191@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=MGCWPAzxmQbQMMJCcovBrCXpF+sK6UnvTHY90djvrVc=;
 b=EJ5bJQ8k1uhrF2u10x5Bs8X2GzO04TivhPMOmXSuLOVuKbPnXvE0O2oj/FqyVWvpgssZ
 T0IqNi59SDa3eBipxXD0ryZqGdiKqMNwodljgsPCopkuFsDNSOIEuhk0KuXM/Cmbzvdf
 zJHER5J8kGdPBkRab1rv9rXvBLpfBB7Upy0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MGCWPAzxmQbQMMJCcovBrCXpF+sK6UnvTHY90djvrVc=;
 b=YhDYu5ZRB104pTaEhnDZH5paN6397gz5D62JSi1a6S9uSPmeEpNGw6IaGPR5D1+mpjTOEJr2CGsf2JyG8f2HD7hzn0Mi9xGuP64CT9cw1igO8/EF9CbNQ/tgnszP3hkhD5IfhdeVuo3lZptNXPjG+qAPu8heT+lrowexYquQklo=
Content-Disposition: inline
In-Reply-To: <7cfbf94e-71c8-b49e-7483-79c3fa363191-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Michael!

> > Hm, basically any cgroup which had some pagecache, associated during the
> > lifetime, will spend some time in the dying state. This means that for
> > most cgroups this number will be non-zero for some amount of time,
> > which depends on global memory pressure.
> > It's also very implementation-defined, and will be likely changed
> > in the following kernel versions.
> > 
> > So, I'm not sure, that such an example will be useful for a user.
> > Until this number is huge and constantly growing, it shouldn't be
> > interesting for an user at all.
> 
> Fair enough. I added some vague text about resources needing to be freed
> before the cgroup is destroyed. See below.
> 
> 
> >>        nr_dying_descendants
> >>               This is the total number  of  dying  descendant  cgroups
> >>               underneath this cgroup.  A cgroup enters the dying state
> >>               after being deleted.  It remains in that  state  for  an
> >>               undefined  period  (which  will  depend  on system load)
> >>               before being destroyed.
> >>
> >>               A process can't be made a member of a dying cgroup,  and
> >>               a dying cgroup can't be brought back to life.
> > 
> > So, maybe it worth it to add a statement, that some amount of dying cgroups
> > is normal and it's not a signal of any problem?
> 
> Okay, I added some text along those lines. The first paragraph now reads:
> 
>        nr_dying_descendants
>               This is the total number  of  dying  descendant  cgroups
>               underneath this cgroup.  A cgroup enters the dying state
>               after being deleted.  It remains in that  state  for  an
>               undefined  period  (which  will  depend  on system load)
>               while  resources  are  freed  before   the   cgroup   is
>               destroyed.   Note  that  the presence of some cgroups in
>               the dying state is normal, and is not indicative of  any
>               problem.

Looks good to me!

Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thank you!
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
