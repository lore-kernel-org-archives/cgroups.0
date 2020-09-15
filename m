From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 0/3] Charge loop device i/o to issuing cgroup
Date: Tue, 15 Sep 2020 09:17:12 -0400
Message-ID: <20200915131712.GA50425@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
References: <20200831153704.16848-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mj8HXSmsSNxeIujwIa30VgbpWrvEiO598UuHVl/xxe8=;
        b=bHtAaTr37msJEOPArN+wAyZqyi+U84EK+yg4FLU29U2WT5F3NlMFrKlYx15Lnaxg35
         iaNPqo/ZxTk/LX/RZnuY/izI4rNZpq49NOCFW9BcuhcGWeHQEDUSoem1gXprIhbFX+SV
         SQTYidbu2wTV31dg+ncvB3lHATpumuzCVfSLqGdvJwTz4cSlB8PXEFApb9c1lioGJx/A
         wS5DGSV88GR5e6EV1Cov4IosxuDQsd8o1JSCiNIrHw2I8/uFj4/5sNQUknmu1iYGzZkC
         Y75UfxyNyHIgV3Xgx0uKearTwlBb5DeGypy6vOVUJ7pI4NnK9SKmHc4r0U7cexNLjH1Y
         Enew==
Content-Disposition: inline
In-Reply-To: <20200831153704.16848-1-schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Jens,

How would you like to resolve this patch series? Roman's patch that
this is based off of just made it into linux-next:

https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next/+/928776957ea4e1c35b1c4c35b8fe7203354fbae3

I suppose you can pull that into the block tree and have git merge
resolve it when it all goes to linus. Another option would be routing
this through Andrew's -mm tree (which already has that commit). Up to
you which you prefer.
