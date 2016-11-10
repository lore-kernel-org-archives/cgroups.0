From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 10 Nov 2016 14:23:44 -0500
Message-ID: <20161110192344.GA4805@htj.duckdns.org>
References: <CAG53R5UyZPh9wduPZGRg2P09n2Og8oODqb+QW=7ryAPqJDa6Vw@mail.gmail.com>
 <AM4PR0501MB28025BE002CBA9D04675A5A5B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5WdauHpML66g-O6zj+j_DUYWJMPjmL1xDaSxwDmPPYm2A@mail.gmail.com>
 <HE1PR0501MB2812298C05431B08B0F408EEB1A60@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <CAG53R5XqZwrYsdX=JQ1D4cDB0h65RDQVb=VCiaR5TXuf_uoO0Q@mail.gmail.com>
 <20161110163837.GE28957@leon.nu>
 <20161110164638.GC26105@htj.duckdns.org>
 <CAG53R5UGfhGHc3-jgUjH5taFzTHg3BOgXi25QjuQfUFc0U7tgw@mail.gmail.com>
 <20161110173217.GD26105@htj.duckdns.org>
 <CAG53R5Wk2zbL=0_EcYCOXQ4dK-k_w=sLOFAKD98NnnbAAnu2=A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TfOtgVyrbrExVbRZ7Ju3xM0SpihFKE12gyCY5t/1bUM=;
        b=Owv7hawhgdY9nGXtabmcZ6l3mdt+gLYpwAcokpjTP52iuSYxBDzRnMytChUyJPigt3
         a3YrkkTmUuJaS6QqsPwzdNUdexTQfG1MDEI6KtmWqxB6Hl42E+29OPIeY3iW3w7YWRoE
         MgMpLRzYZHK6Ilc5Rvg5BUFhLbrtsFSDv0M2Z1ferHC4SqhPbf/fYXD/Qt4TXXUGULKg
         jmoF5gPl5EW7gzKzIuPDiJ6A2fZSNdLYdgJ1r214RpqNyjUTBoEF1GtZ/U+MrNIIdneL
         hwCb8E5BA/hBHHMaZT2ht+HDcn1i3NIUnG3Ko2c4qqIwjnIBY85WMPbtTC58jlVOy8J1
         D1Pw==
Content-Disposition: inline
In-Reply-To: <CAG53R5Wk2zbL=0_EcYCOXQ4dK-k_w=sLOFAKD98NnnbAAnu2=A@mail.gmail.com>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hello, Parav.

On Thu, Nov 10, 2016 at 11:26:28PM +0530, Parav Pandit wrote:
> > That looks great to me from cgroup side.  Do you have plans for
> > exposing the maximum numbers available?
>
> If I have to expose max limits, I need new file interface as rdma.limit.
> Because once rdma.max is set, user space cannot get back the old value.
> It needs to cache it. user space tools might have been restarted and
> so on, so store in other file etc.
> So such user space solutions are just ugly.
> 
> Getting and setting values in device agnostic way, through cgroup
> files is desirable, however its not must. It can fallback on using
> verb based API.
> 
> So if there is no objection, I prefer to have rdma.limit file as
> incremental patch once base version is merged.

How about something like RESOURCE.available field in rdma.stat file?
Its value can be what's maximally available at that level when max is
unlimited and there is no competition.  At top level cgroups, it'd be
the total resources available in the system.  At sub levels, it'd be
min of what's available to the grandparent and parent's limit on the
resource.

This would be in line with cgroup conventions and would behave the
same way nested making things easier for containers.

Thanks.

-- 
tejun
