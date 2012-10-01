From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Mon, 1 Oct 2012 09:57:17 +0900
Message-ID: <20121001005717.GM10383@mtj.dyndns.org>
References: <20120927142822.GG3429@suse.de>
 <20120927144942.GB4251@mtj.dyndns.org>
 <50646977.40300@parallels.com>
 <20120927174605.GA2713@localhost>
 <50649EAD.2050306@parallels.com>
 <20120930075700.GE10383@mtj.dyndns.org>
 <20120930080249.GF10383@mtj.dyndns.org>
 <1348995388.2458.8.camel@dabdike.int.hansenpartnership.com>
 <20120930103732.GK10383@mtj.dyndns.org>
 <1349004352.2458.34.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=JKsMWzjw5N8X+lyj+hrwR3hVtzPCNENOLLJgeK2rKME=;
        b=w+Sp8qtsVK2VJYwmatOpCOCcxfxzPMnJQ2GPaiyTdsB71xzihusHRlqgYX55QG6yoE
         rU5fS+RluICci9Z7cEH6QgmVQvy0egVY+Gu/UfAs6jKYwHTyyDKZgrTufeW+ofmJt1OV
         hlIsXqJTYJtv9+GhQXDaem1z1s8ejZ8rJQ0+wuWb9AhJz4BzIX2/bKaH682YCuSmU2yq
         fNd+1lSrFa7IrEsUjI8yA+6h4F3zTV5qxz/iLbyQq5P0UhqTMGh0HXdTsrxtuFVnyR/W
         Xe4qygYQiSnoCngFu/4iqWpdAu6sj0M/qZh2jLJBpPJ8TwE/hM+sqJ8RxozDq1xxocik
         L6pg==
Content-Disposition: inline
In-Reply-To: <1349004352.2458.34.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, James.

On Sun, Sep 30, 2012 at 12:25:52PM +0100, James Bottomley wrote:
> But you've got to ask yourself who cares about accurate accounting per
> container of dentry and inode objects? They're not objects that any
> administrator is used to limiting.  What we at parallels care about
> isn't accurately accounting them, it's that one container can't DoS
> another by exhausting system resources.  That's achieved equally well by
> first charge slab accounting, so we don't really have an interest in
> pushing object accounting code for which there's no use case.

Isn't it more because the use cases you have on mind don't share
dentries/inodes too much?  Wildly incorrect accounting definitely
degrades container isolation and can lead to unexpected behaviors.

> All we need kernel memory accounting and limiting for is DoS prevention.
> There aren't really any system administrators who care about Kernel
> Memory accounting (at least until the system goes oom) because there are
> no absolute knobs for it (all there is are a set of weird and wonderful
> heuristics, like dirty limit ratio and drop caches).  Kernel memory

I think that's because the mechanism currently doesn't exist.  If one
wants to control how memory is distributed across different cgroups,
it's logical to control kernel memory too.  The resource in question
is the actual memory after all.  I think at least google would be
interested in it, so, no, I don't agree that nobody wants it.  If that
is the case, we're working towards the wrong direction.

> usage has a whole set of regulatory infrastructure for trying to make it
> transparent to the user.
> 
> Don't get me wrong: if there were some easy way to get proper memory
> accounting for free, we'd be happy but, because it has no practical
> application for any of our customers, there's a limited price we're
> willing to pay to get it.

Even on purely technical ground, it could be that first-use is the
right trade off if other more accurate approaches are too difficult
and most workloads are happy with such approach.  I'm still a bit
weary to base userland interface decisions on that tho.

Thanks.

-- 
tejun
