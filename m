From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcontrol: eliminate redundant check in
 __mem_cgroup_insert_exceeded()
Date: Mon, 12 Oct 2020 09:58:52 -0400
Message-ID: <20201012135852.GB188876@cmpxchg.org>
References: <20201012131607.10656-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Osshed0yZw01kGf9tsxsPTMgiFVwAv+3bFml5Qp/S6I=;
        b=Sbr/oBREuW7qcPtzuexM9iqgk70TQmYyzQXuD1cbd5tg3SM9lOdsUrYHoMeDV8DQOy
         UueavBzl67FQvEbouK6Moe2nIYbhuX9Hn/9BejDvPgFbCGiyk2hgSOMhEkN1TeJv/qtG
         QzswFmgdtJF5bzku8cKITDYpnUD0wwK34cI58duEv3gteiqgDliboq3LM6ANyw7Hw7N8
         mr2mtvc7dMULRnVyov6TZVXr7YambYnUtko20U4NfXMHS8v6ODN77S0030C9VFTxb3Jg
         SLdFjX8tM2pYjiRg+V0DWXvSupRdsxN3aGXSBj1Av+um8cbeKqZGirKH6agH6pmHvcXi
         rANQ==
Content-Disposition: inline
In-Reply-To: <20201012131607.10656-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 12, 2020 at 09:16:07AM -0400, Miaohe Lin wrote:
> The mz->usage_in_excess >= mz_node->usage_in_excess check is exactly the
> else case of mz->usage_in_excess < mz_node->usage_in_excess. So we could
> replace else if (mz->usage_in_excess >= mz_node->usage_in_excess) with else
> equally. Also drop the comment which doesn't really explain much.
> 
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Looks good to me.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
