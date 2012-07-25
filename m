From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/10] slab: allow enable_cpu_cache to use preset values
 for its tunables
Date: Wed, 25 Jul 2012 13:33:16 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1207251331480.4995@router.home>
References: <1343227101-14217-1-git-send-email-glommer@parallels.com> <1343227101-14217-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1207251204450.3543@router.home> <501039F9.7040309@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1343241201; bh=EahNliTBt/Ins8JQ3ucTLMG4iPVhEpktBHsohpDzFMo=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=qVbjsuCZ8frZMNTCoLV23XLqGcuCq10A8667PlDSW8CRwWV/BsoprKe8CUKPMLjHQnpDDyruGZO5jN8VgYOVv1AA4y+lgMMZHluFmfOoN9T1pMW3KcZ2VgOADWgUOtHtFA0h/fDz0SGdE0NMBQ2WsQt7E9YzJO1KcBF0pMGPy7I=
In-Reply-To: <501039F9.7040309-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, 25 Jul 2012, Glauber Costa wrote:

> It is certainly not through does the same method as SLAB, right ?
> Writing to /proc/slabinfo gives me an I/O error
> I assume it is something through sysfs, but schiming through the code
> now, I can't find any per-cache tunables. Would you mind pointing me to
> them?

The slab attributes in /sys/kernel/slab/<slabname>/<attr> can be modified
for some values. I think that could be the default method for the future
since it allows easy addition of new tunables as needed.
