From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 4/5] mm, memcg: avoid possible NULL pointer dereferencing
 in mem_cgroup_init()
Date: Thu, 29 Jul 2021 14:52:31 +0100
Message-ID: <YQKyn8bKRblCDuND@casper.infradead.org>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-5-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=//JteJBlPO/oxjTtV3LASZaFA4G6WCHzkWs4cs97Saw=; b=iZFUmVL3DjXeQg65XLBHJKYW+r
        ij7voxBE+IDPgeuSPz7voqUndWCfKEe4BwM0Nx49Uer0h//8+3oD9o62dZ6iJ7MeKTIiC9GwN6pja
        8Q25jshIVHOAXS/XavTefpp71qH3SOdLJSvYQVsr/wKa091xMOpafpfGWhUnh+aPDUXFW+Lh6rYLQ
        ZY/8spCb23lWoAi6nVPNAJbrFvBI4yoijzs/Rj77fHaz1wgpd6yvZEXNBV+xI/GYSLqe9TOtLA7sk
        pkqyZy7ewtzkjO/bGQf6v94jGRPAWzXQ90AeFGQkRITOa2ns2kghh3nmSN6zbJa9KwL7hmNpQyoTM
        xWxCLu8w==;
Content-Disposition: inline
In-Reply-To: <20210729125755.16871-5-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 29, 2021 at 08:57:54PM +0800, Miaohe Lin wrote:
> rtpn might be NULL in very rare case. We have better to check it before
> dereferencing it. Since memcg can live with NULL rb_tree_per_node in
> soft_limit_tree, warn this case and continue.

Why would we need to warn?  the GFP flags don't contain NOWARN, so
we already know an allocation failed.
