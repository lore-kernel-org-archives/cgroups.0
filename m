From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Remove unused mod_memcg_obj_state()
Date: Tue, 13 Oct 2020 12:28:15 -0700 (PDT)
Message-ID: <alpine.DEB.2.23.453.2010131228021.2883230@chino.kir.corp.google.com>
References: <20201013153504.92602-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=XGODVd8VkNSh8S84Wy0CghHqd0aFoaKdhs2B2qvJRwU=;
        b=QJDFWLm9JSrh/of7EIAurbQWhS26t3KiBiOYedmnmy5W/mdATsMGEThFkfuueGBiuD
         yUx1IWye8xXZ5sZSqRsm7uTgnhlhfgCInmdC1BBsnn3PuEIBlmJNZsAgXq9S7zqq0S+k
         zpgr/O1j/KEq5Hw+fxDBQIwzBRl+pO5bhGB5/7QtKTCJD+aD13xRuYup8hwes+FPXZ8b
         mHxg4A0iKwEsTeY5xl8BTKeTkxO4qwYgfcqQw1zOCb2g+eBsH/TGzwa8Knmrs+DjzrRa
         zBVL/4EvNgN+SEuUAdMs2M80hAWa/LAyVCDi8dhXt9t33NkGO9eMsNnF7GkJT+mRbIrA
         e/FA==
In-Reply-To: <20201013153504.92602-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, 13 Oct 2020, Muchun Song wrote:

> Since commit:
> 
>   991e7673859e ("mm: memcontrol: account kernel stack per node")
> 
> There is no user of the mod_memcg_obj_state(). This patch just remove
> it. Also rework type of the idx parameter of the mod_objcg_state()
> from int to enum node_stat_item.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
