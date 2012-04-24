From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 17/23] kmem controller charge/uncharge infrastructure
Date: Tue, 24 Apr 2012 13:25:57 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1204241322390.753@chino.kir.corp.google.com>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1335138820-26590-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1204231522320.13535@chino.kir.corp.google.com> <20120424142232.GC8626@somewhere>
 <4F96BB62.1030900@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=dwGtISbhTtx0HlFN9osBUsJD9OBDlyEOvIZKIo8dSQg=;
        b=Hn1bmampbAFf8996FEwvE7WAdp29T4yVar30zisX/k5tdPxmlAXSwfj3u/ZKkagq6u
         P98Cf2xEo2MFhUWhoai8uTZtgY+DXnai+B0eBYyVL5Rkx8mTiziUgVlGNhKV/ygm5oJX
         XI5Tgl2Y4HpnasS1qicFUvg4Bdd3h3dYC8qBRkoQGiarvp6bXYuKjob7cNP8RRgwE32z
         tNKROUNkahG5IBszef+33wF/R+m7ygySCMuwfiNzVp/BQZbtIMUPvWV4TJchNmnNENyJ
         0ZdPLcgJ80RK162MJCbYXRzXkTOwXg6nvKKu9XfLszOjZdpmq74kCrpjTp0ECy9hdPiP
         4pmQ==
In-Reply-To: <4F96BB62.1030900-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Tue, 24 Apr 2012, Glauber Costa wrote:

> I think memcg is not necessarily wrong. That is because threads in a process
> share an address space, and you will eventually need to map a page to deliver
> it to userspace. The mm struct points you to the owner of that.
> 
> But that is not necessarily true for things that live in the kernel address
> space.
> 
> Do you view this differently ?
> 

Yes, for user memory, I see charging to p->mm->owner as allowing that 
process to eventually move and be charged to a different memcg and there's 
no way to do proper accounting if the charge is split amongst different 
memcgs because of thread membership to a set of memcgs.  This is 
consistent with charges for shared memory being moved when a thread 
mapping it moves to a new memcg, as well.
