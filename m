From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC] Add swappiness argument to memory.reclaim
Date: Mon, 16 May 2022 15:29:42 -0700
Message-ID: <CAJD7tkbDpyoODveCsnaqBBMZEkDvshXJmNdbk51yKSNgD7aGdg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=SfNwAhG3H0WFr7m8ORYPNz7dtqzeGJlfJ6gnUv4p940=;
        b=gj1nmb9U1n9DLHipYZgC3NBMcWDJ5bVYuNXQjOsvwVIGUIQ/CcWWoca+1jjdc5LK7s
         ifJDqlmUcsCETFXm7KLp0q5sdkd6xdCjJdVjbB2tTjE7DZcv5kfscr4ocsxgBFbeJf0D
         4gHcQ+F+EOufpbPscNALZB6Ni/Xz/mDvn1UAS5DxK1MNfhIQtSE31jX+oLsQs2jX6m/p
         0kMXKbQuuisx7dhP3sQa3Ovjr1FwNS3D5PuoCQds4MyIvlumtQjInoZSbj6fb6vGifSM
         z0Yky2cbkNNCgm+amQv5WA9eA/+pSCqh8EUpmM2xux0PZWSBvaw87/6l3rzC7k1ZejXK
         Al4A==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

The discussions on the patch series [1] to add memory.reclaim has
shown that it is desirable to add an argument to control the type of
memory being reclaimed by invoked proactive reclaim using
memory.reclaim.

I am proposing adding a swappiness optional argument to the interface.
If set, it overwrites vm.swappiness and per-memcg swappiness. This
provides a way to enforce user policy on a stateless per-reclaim
basis. We can make policy decisions to perform reclaim differently for
tasks of different app classes based on their individual QoS needs. It
also helps for use cases when particularly page cache is high and we
want to mainly hit that without swapping out.

The interface would be something like this (utilizing the nested-keyed
interface we documented earlier):

$ echo "200M swappiness=30" > memory.reclaim

Looking forward to hearing thoughts about this before I go ahead and
send a patch.

[1]https://lore.kernel.org/lkml/20220331084151.2600229-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
