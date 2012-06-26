From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/11] memcg: Reclaim when more than one page needed.
Date: Tue, 26 Jun 2012 01:54:09 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206260146010.16020@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-3-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252106430.26640@chino.kir.corp.google.com> <4FE960D6.4040409@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=wCjNiSHUdahbTkYBZxvd3qyzxEf6Rj2oeymPCQUogSU=;
        b=WoAi9BSt7FhllyMAU+c1fqeCVMP9YNwYN5UhuLnpsz3gpHuC2k8dZg9n+BGPNCKtUv
         zS33Enig22QqKpChCsuL2um5fB4jyh2UM3CVSUhmPVu/Q7rhxOF5FF1Xc8T5hEU3inr4
         qmGo1zt9WshIT68JSg6O/zkKhZ9WRJoK4FLrwSluveRAEBbLpLE9ryEFrPOnwmcm7VEe
         ZbmJaEc/WHugje52aIdW0d4TcGGxNBJp/C1DpDj2VS349k4RjwYVXhMsx7Fs14A2E8N6
         cXalPzDpUpVxIDy3YhSzuDi50GsJJfuanWVaLNtILsAJY8jeVIkmlljdcPgvB2u+0SXB
         VbgA==
In-Reply-To: <4FE960D6.4040409-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, 26 Jun 2012, Glauber Costa wrote:

> > > + * retries
> > > + */
> > > +#define NR_PAGES_TO_RETRY 2
> > > +
> > 
> > Should be 1 << PAGE_ALLOC_COSTLY_ORDER?  Where does this number come from?
> > The changelog doesn't specify.
> 
> Hocko complained about that, and I changed. Where the number comes from, is
> stated in the comments: it is a number small enough to have high changes of
> had been freed by the previous reclaim, and yet around the number of pages of
> a kernel allocation.
> 

PAGE_ALLOC_COSTLY_ORDER _is_ the threshold used to determine where reclaim 
and compaction is deemed to be too costly to continuously retry, I'm not 
sure why this is any different?

And this is certainly not "around the number of pages of a kernel 
allocation", that depends very heavily on the slab allocator being used; 
slub very often uses order-2 and order-3 page allocations as the default 
settings (it is capped at, you guessed it, PAGE_ALLOC_COSTLY_ORDER 
internally by default) and can be significantly increased on the command 
line.

> Of course there are allocations for nr_pages > 2. But 2 will already service
> the stack most of the time, and most of the slab caches.
> 

Nope, have you checked the output of /sys/kernel/slab/.../order when 
running slub?  On my workstation 127 out of 316 caches have order-2 or 
higher by default.
