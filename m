From: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Subject: Re: [PATCH v2 0/4] mm/slub: Fix sysfs circular locking dependency
Date: Sat, 16 May 2020 21:54:25 -0400
Message-ID: <2BD2A76D-CB50-4BA8-A867-DF71B1DA5F28@lca.pw>
References: <20200427235621.7823-1-longman@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=QqBtGMwRf4iMThT/E7Zzgq854jp3AIpzA1Y8zlAhggY=;
        b=kWafknG1HhI2nq0LzV1WNZsMtIbtpGsnnUjIJW35CsFYFMlqLGy5HA66FACPokMXhc
         /8td4xNLaqhlfun7I+onfk0qbHyvwgkIKM8bOj4UMsnD0rRDMxMFSALK5mG4ULqZwOj6
         WmoXzu7R1hOLYUxM2mStHwrkm9PL4c1U1akmER10YBtOmhSV/QJGIj1QxTJ8sHWdoxzm
         dbKcw0on4aWVPAChVGm9vwFsCT8sIV3v9jp7cvdbpBJyWqOLiLrk+mVcF4sn8GKQ2wvn
         RuI8czmKO7TExBBB9x2BribWkKTRmRWIkWPT23qn8tkEWth3IcWCMu+8xOn6mQAGy9ww
         kcLQ==
In-Reply-To: <20200427235621.7823-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



> On Apr 27, 2020, at 7:56 PM, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> v2:
> - Use regular cmpxchg() instead of x86-only try_cmpxchg() in patch 2.
> - Add patches 3 and 4 to fix circular locking dependency showing up
>   at shutdown time.
> 
> With lockdep enabled, issuing the following command to the slub sysfs
> files will cause splat about circular locking dependency to show up
> either immediately afterwards or at shutdown time.
> 
> # echo 1 > validate
> # echo 1 > shrink
> 
> This patchset fixes these lockdep splats by replacing slab_mutex with
> memcg_cache_ids_sem as well as changing some of the lock operations
> with trylock.

For the whole series, feel free to use,

Tested-by: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
