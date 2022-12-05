From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Mon, 5 Dec 2022 19:28:14 +0000
Message-ID: <20221205192814.diiwtktsrgxzccw2@google.com>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org> <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com> <Y4T43Tc54vlKjTN0@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t2eV37n1EV50KN4L5BF+kL5AM4qRwzFeAkejJliXYvE=;
        b=OXixcqr3xZZ9Hudft/Jy24A4UlcW/Yb6EPf+E30B+Y3SrNhoNoQK+pCDrL/PMBDL82
         IKcAOaMUGYH18Gh0odJqUTEELnNAropoi9gMTbXzIRbC6SljHGZd+rT95xqsGFvPic/v
         sTqJEV88g2wzK30Nz1wYLyY6DgGQm7B8iNTPT1bVcf6ZiPyuFIGsvVEKRmmfY1gdc5xm
         9MA2j56JA5130vszUlvLjOLBg1AOC0touX+NmNhzcvJ20NgsWpDoctpN+DZtaHkTWw+x
         l6O4Rzr7mT+phIJg/gOMUY7jYqiscVkkTUPHYdYGsO2cFfNeKeOJ/nb0kIBvUXlCC+kj
         Uwuw==
In-Reply-To: <Y4T43Tc54vlKjTN0-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On Mon, Nov 28, 2022 at 01:07:25PM -0500, Johannes Weiner wrote:
> 
[...]
> > With the patch applied I'm capped at ~120MB/s, which is a symptom of a
> > clamped window.
> > 
> > I can't find any sockets with memcg->socket_pressure = 1, but at the
> > same time I only see the following rcv_ssthresh assigned to sockets:
> 
> Hm, I don't see how socket accounting would alter the network behavior
> other than through socket_pressure=1.
> 

I think what is happening is that the tcp stack is calling
tcp_under_memory_pressure() and making decisions without going through
the memcg charge codepath which set or reset memcg->socket_pressure.
Most probably the socket is clamped due to memcg->socket_pressure and
then the kernel never tried to grow its buffers because
memcg->socket_pressure is still set and thus never tried the memcg
charge codepath which would have reset memcg->socket_pressure. (Maybe)
That is my guess but network experts CCed can correct me.

Anyways, I don't think the pressure mechanism which relies on successful
charging will work. I am brainstorming towards memory.high based network
throttling. Basically use penalty_jiffies (or something similar) to set
memcg->socket_pressure. However I want this to be opt-in as we do have
applications which prefer to be killed than be throttled. So, still
working on the fine details how this can be done without introducing a
rigid API.

