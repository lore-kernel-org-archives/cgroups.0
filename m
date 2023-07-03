From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] nvmet: allow associating port to a cgroup via configfs
Date: Mon, 3 Jul 2023 09:16:21 -1000
Message-ID: <ZKMehaAF0v-nV1qt@slm.duckdns.org>
References: <20230627100215.1206008-1-ofir.gal@volumez.com>
 <30d03bba-c2e1-7847-f17e-403d4e648228@grimberg.me>
 <90150ffd-ba2d-6528-21b7-7ea493cd2b9a@nvidia.com>
 <79894bd9-03c7-8d27-eb6a-5e1336550449@volumez.com>
 <ab204a2d-9a30-7c90-8afa-fc84c935730f@grimberg.me>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688411784; x=1691003784;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dlgEq4UH4vDTOZrzscCBubu+ZOjeAEIOmPqCH5Q/VA4=;
        b=siqjtbELynGlxxIRUqqlm1qRIIGPI04SUqntEeyZ9DeXx8FwnRhhG/EMMubIceFYt7
         RRc7uebvlYi6FEe+8lMc6vsu5mreNBpTjxbiemcLNzjSRJHa47+8ElZ+ZrFSTMgC8SLF
         BdgsZU43OvuG+VFZfruUNF9AvzzruQwh8EtBS/bwmJpTm/c+JPYvgxaLxxfx8qiu1c3P
         t7b9zQnHnBx/ccB3g1NZG2DjONQLSTNCZOak+814Gk3OIZVIuE9lwn8CK76yHtvRnjf3
         DBGIWj/E2eMuYQAMN1bN26jfh/sw16Py4Qdwr82U39plffa37oiePNcacDwtOPVgGxP4
         Be5Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ab204a2d-9a30-7c90-8afa-fc84c935730f-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Ofir Gal <ofir.gal-83CFe9096HFBDgjK7y7TUQ@public.gmane.org>, Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Jul 03, 2023 at 04:21:40PM +0300, Sagi Grimberg wrote:
> > Thorttiling files and passthru isn't possible with cgroup v1 as well,
> > cgroup v2 broke the abillity to throttle bdevs. The purpose of the patch
> > is to re-enable the broken functionality.
> 
> cgroupv2 didn't break anything, this was never an intended feature of
> the linux nvme target, so it couldn't have been broken. Did anyone
> know that people are doing this with nvmet?

Maybe he's referring to the fact that cgroup1 allowed throttling root
cgroups? Maybe they were throttling from the root cgroup on the client side?

> I'm pretty sure others on the list are treating this as a suggested
> new feature for nvmet. and designing this feature as something that
> is only supported for blkdevs is undersirable.
> 
> > There was an attempt to re-enable the functionality by allowing io
> > throttle on the root cgroup but it's against the cgroup v2 design.
> > Reference:
> > https://lore.kernel.org/r/20220114093000.3323470-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> > 
> > A full blown nvmet cgroup controller may be a complete solution, but it
> > may take some time to achieve,
> 
> I don't see any other sane solution here.
> 
> Maybe Tejun/others think differently here?

I'm not necessarily against the idea of enabling subsystems to assign cgroup
membership to entities which aren't processes or threads. It does make sense
for cases where a kernel subsystem is serving multiple classes of users
which aren't processes as here and it's likely that we'd need something
similar for certain memory regions in a limited way (e.g. tmpfs chunk shared
across multiple cgroups).

That said, because we haven't done this before, we haven't figured out how
the API should be like and we definitely want something which can be used in
a similar fashion across the board. Also, cgroup does assume that resources
are always associated with processes or threads, and making this work with
non-task entity would require some generalization there. Maybe the solution
is to always have a tying kthread which serves as a proxy for the resource
but that seems a bit nasty at least on the first thought.

In principle, at least from cgroup POV, I think the idea of being able to
assign cgroup membership to subsystem-specific entities is okay. In
practice, there are quite a few challenges to address.

Thanks.

-- 
tejun
