From: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 05/25] memcg: Always free struct memcg through
 schedule_work()
Date: Wed, 20 Jun 2012 10:32:50 +0300 (EEST)
Message-ID: <alpine.LFD.2.02.1206201031150.2989@tux.localdomain>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-6-git-send-email-glommer@parallels.com> <4FDF1A0D.6080204@jp.fujitsu.com> <4FDF1AAE.4080209@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=Ak2PO0zrtwJ2gz+8PZxVx/qg9fgJ6N0ZjEFSFIfqd/s=;
        b=A9R3vYndvxGu0+o4BZh9t6TH0XY+g1jHoA+En7LNkeZZxSLztegMHkbFFpL5/EPdiE
         rqmfLrCR4hC42LYMS4ZVyG82fp3aMpF8rjH0yhaCnguNngQs3MGRwkgMz0L8jyrsXZ3l
         QtOQVQjC7Z1fuJ2fsprx3kP58MnJqWJHix6lczmjQGQRxbg29Wu7yWQENPaNk+IsVh09
         jlIzDjlZdLTqGNskXBKtbajgUArlIJiOWvl23+j0KyAw2qeQdujR+oWcVZVHV+i4KCkY
         x4XGh3R1ODb9aWw91QCkdoorGassZ61G1Nq916S2dNISRbZd2J2mFcsJWyS9jR8vRsU6
         qy9w==
In-Reply-To: <4FDF1AAE.4080209-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Cristoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

On Mon, 18 Jun 2012, Glauber Costa wrote:
> I believe this is already in the -mm tree (from the sock memcg fixes)
> 
> But actually, my main trouble with this series here, is that I am basing
> it on Pekka's tree, while some of the fixes are in -mm already.
> If I'd base it on -mm I would lose some of the stuff as well.
> 
> Maybe Pekka can merge the current -mm with his tree?

I first want to have a stable base from Christoph's "common slab" series 
before I am comfortable with going forward with the memcg parts.

Feel free to push forward any preparational patches to the slab 
allocators, though.

			Pekka
