From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Fork bomb limitation in memcg WAS: Re: [PATCH 00/11] kmem
 controller for memcg: stripped down version
Date: Wed, 27 Jun 2012 12:38:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206271233080.22162@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <20120625162745.eabe4f03.akpm@linux-foundation.org> <4FE9621D.2050002@parallels.com> <20120626145539.eeeab909.akpm@linux-foundation.org> <4FEAD260.4000603@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=j3XG7tH1hVUrUYG4R1SOIwAV7II8eA7NVgyG0JAIW6I=;
        b=Yq1hz8wpWQbFQ/plwcnzZJ74EX2p0P2oWtxJMzjelxKICfUxm6N/ppaA+NIVA4khNA
         Q/+hjS3ZLTAAPkg48cj2tg3RoijQbH9BzjhChHCGPKaXe7tspAb0bE1cGWd1HXo3f6jh
         IwMhRiIgrsjsocDqpFL9xmVJo90O+aGujuBXHHE9Rb6oaRamBztMaRoVPOdAiQz+pk3R
         Kaaa5eDr2wDKPzK3KXP8dS35NG/+ccR9oeZhLgLuhWU/7jBnczqKoY5GPqVbbby5JMeY
         LZuyPThUE2EtkXNllh/B1KC2rlnYgrWp6xyyncxYPtX38AzD1fAsYzeWoh31I+oZ6ANG
         FYfw==
In-Reply-To: <4FEAD260.4000603-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Kir Kolyshkin <kir-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Wed, 27 Jun 2012, Glauber Costa wrote:

> fork bombs are a way bad behaved processes interfere with the rest of
> the system. In here, I propose fork bomb stopping as a natural
> consequence of the fact that the amount of kernel memory can be limited,
> and each process uses 1 or 2 pages for the stack, that are freed when the
> process goes away.
> 

The obvious disadvantage is that if you use the full-featured kmem 
controller that builds upon this patchset, then you're limiting the about 
of all kmem, not just the stack that this particular set limits.  I hope 
you're not proposing it to go upstream before full support for the kmem 
controller is added so that users who use it only to protect again 
forkbombs soon realize that's no longer possible if your applications do 
any substantial slab allocations, particularly anything that does a lot of 
I/O.

In other words, if I want to run netperf in a memcg with the full-featured 
kmem controller enabled, then its kmem limit must be high enough so that 
it doesn't degrade performance that any limitation on stack allocations 
would be too high to effectively stop forkbombs.
