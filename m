From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm: slab: make slab iterator functions static
Date: Mon, 15 Nov 2021 23:56:45 +0100
Message-ID: <abe4ef63-7bb2-93c2-d0c7-d7bab9ba2f6b@suse.cz>
References: <20211109133359.32881-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1637017007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XszfChHIbqmWBDL5Op+W4Hd9f4QflFXocWVFOOOOktk=;
        b=1e6O/P+WZWOtrccWiDyT36Q+3aR4OOPIZKKbLnfHJzxJpn0yd9vzpSEglewY8CaiUv+3pU
        9mlryOi2Vca75FOJA7sIeNmH8Yo0m894mMQXymeHo7rOASJlMo90k5hNjf+zdYSOJ1EKjd
        o9jX6MLbrlePfiFrRPDtiAWALFDIYBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1637017007;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XszfChHIbqmWBDL5Op+W4Hd9f4QflFXocWVFOOOOktk=;
        b=g5eanP5cV7Lgt+mSe5VdHWMrEK+GoUSwzJlHsUfkKY+wdapf2u7w8IgsvOI2M6kt4Mz8eO
        fAWig/ra+NWOOgAQ==
Content-Language: en-US
In-Reply-To: <20211109133359.32881-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 11/9/21 14:33, Muchun Song wrote:
> There is no external users of slab_start/next/stop(), so make them
> static. And the memory.kmem.slabinfo is deprecated, which outputs
> nothing now, so move memcg_slab_show() into mm/memcontrol.c and
> rename it to mem_cgroup_slab_show to be consistent with other
> function names.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Reviewed-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
