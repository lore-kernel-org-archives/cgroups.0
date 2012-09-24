From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 07/16] memcg: skip memcg kmem allocations in
 specified code regions
Date: Mon, 24 Sep 2012 10:47:42 -0700
Message-ID: <20120924174742.GC7694@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-8-git-send-email-glommer@parallels.com>
 <20120921195929.GL7264@google.com>
 <50602343.6040806@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=maA7J+Px1Iblh+LUL9eMfVnrWam2J6jAEEI5dTq3t6g=;
        b=SOpqGkhlkiHihQMF0zfhxx9FKKGQHGhpgUws3zW/qEQct+GdDOJkI7/VwXlzXbPPo+
         unlSIZyu0QnuMniIIaOxYKCNYrJM64Fdh84EmTjcPoF4jfstGqmHYkbMmsUZKUSc9KIC
         oEcLBaDN7hA75sKu9gbdpVyGCJ10bTC7cQVhrht1XBtnZflmryAKHUpfxBqM0Mlrn4H0
         5dsP+cSPyY9ZzjkzBW+JtJQ579apDxJz+Qt1GqiN2hmuNN5SdJGNXNAa9kfCg0Zn5kIn
         QYABRjcGKjSYhx+1kMaC5pFkzPoPRfQJD7ENUQE6kGIFTwe/kxnu2aJbhhQ8bAHhHWAP
         Oq4g==
Content-Disposition: inline
In-Reply-To: <50602343.6040806-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello,

On Mon, Sep 24, 2012 at 01:09:23PM +0400, Glauber Costa wrote:
> > I can't say I'm a big fan of this approach.  If there are enough
> > users, maybe but can't we just annotate the affected allocations
> > explicitly?  Is this gonna have many more users?
> 
> What exactly do you mean by annotating the affected allocations?

IOW, can't you just pass down an extra argument / flag / whatever
instead?

Thanks.

-- 
tejun
