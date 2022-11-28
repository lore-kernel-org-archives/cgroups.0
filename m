From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Mon, 28 Nov 2022 13:07:25 -0500
Message-ID: <Y4T43Tc54vlKjTN0@cmpxchg.org>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org>
 <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qOn1PUQxMJCGp3yaVSqPelmstrqLulCIcemPhpNVzdU=;
        b=4tQKhAmlgqJFeuomcyGn+GyBJTF3TXNZND3NJQrXoNmD8007Bxyc2BZx8oFt4hfIHz
         DcHStdfL2bgNWjZTK0ib7Ohf9zqFJ+82s5fozbOWW3QWW289UEPRstHix3b0fcK1+fOF
         ud9ZTqyADxWT2iqEUic/48O1fS33VMxPFrU3i1iO79Mwue4ofOjSA5Yhg7qSYgKtqIYq
         c0XG+rJLlfayL++XpOTdm2AUjwy3zr8n5NSnhkwYqQPKPXDvpOjCuAvDzEVYTP13jtUi
         c80FdjP5USS2wz5z/YixX3LluJBQGexKDWu0K9Qraubay+EYw+V5uZ1Iy3idEWE+bCZM
         Fl8w==
Content-Disposition: inline
In-Reply-To: <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On Tue, Nov 22, 2022 at 05:28:24PM -0800, Ivan Babrou wrote:
> On Tue, Nov 22, 2022 at 2:11 PM Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org> wrote:
> >
> > On Tue, Nov 22, 2022 at 12:05 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > >
> > > On Mon, Nov 21, 2022 at 04:53:43PM -0800, Ivan Babrou wrote:
> > > > Hello,
> > > >
> > > > We have observed a negative TCP throughput behavior from the following commit:
> > > >
> > > > * 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure
> > > >
> > > > It landed back in 2016 in v4.5, so it's not exactly a new issue.
> > > >
> > > > The crux of the issue is that in some cases with swap present the
> > > > workload can be unfairly throttled in terms of TCP throughput.
> > >
> > > Thanks for the detailed analysis, Ivan.
> > >
> > > Originally, we pushed back on sockets only when regular page reclaim
> > > had completely failed and we were about to OOM. This patch was an
> > > attempt to be smarter about it and equalize pressure more smoothly
> > > between socket memory, file cache, anonymous pages.
> > >
> > > After a recent discussion with Shakeel, I'm no longer quite sure the
> > > kernel is the right place to attempt this sort of balancing. It kind
> > > of depends on the workload which type of memory is more imporant. And
> > > your report shows that vmpressure is a flawed mechanism to implement
> > > this, anyway.
> > >
> > > So I'm thinking we should delete the vmpressure thing, and go back to
> > > socket throttling only if an OOM is imminent. This is in line with
> > > what we do at the system level: sockets get throttled only after
> > > reclaim fails and we hit hard limits. It's then up to the users and
> > > sysadmin to allocate a reasonable amount of buffers given the overall
> > > memory budget.
> > >
> > > Cgroup accounting, limiting and OOM enforcement is still there for the
> > > socket buffers, so misbehaving groups will be contained either way.
> > >
> > > What do you think? Something like the below patch?
> >
> > The idea sounds very reasonable to me. I can't really speak for the
> > patch contents with any sort of authority, but it looks ok to my
> > non-expert eyes.
> >
> > There were some conflicts when cherry-picking this into v5.15. I think
> > the only real one was for the "!sc->proactive" condition not being
> > present there. For the rest I just accepted the incoming change.
> >
> > I'm going to be away from my work computer until December 5th, but
> > I'll try to expedite my backported patch to a production machine today
> > to confirm that it makes the difference. If I can get some approvals
> > on my internal PRs, I should be able to provide the results by EOD
> > tomorrow.
> 
> I tried the patch and something isn't right here.

Thanks for giving it a sping.

> With the patch applied I'm capped at ~120MB/s, which is a symptom of a
> clamped window.
> 
> I can't find any sockets with memcg->socket_pressure = 1, but at the
> same time I only see the following rcv_ssthresh assigned to sockets:

Hm, I don't see how socket accounting would alter the network behavior
other than through socket_pressure=1.

How do you look for that flag? If you haven't yet done something
comparable, can you try with tracing to rule out sampling errors?

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 066166aebbef..134b623bee6a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7211,6 +7211,7 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 		goto success;
 	}
 	memcg->socket_pressure = 1;
+	trace_printk("skmem charge failed nr_pages=%u gfp=%pGg\n", nr_pages, &gfp_mask);
 	if (gfp_mask & __GFP_NOFAIL) {
 		try_charge(memcg, gfp_mask, nr_pages);
 		goto success;
