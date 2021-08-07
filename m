From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm, memcg: get rid of percpu_charge_mutex lock
Date: Sat, 7 Aug 2021 11:56:25 -0700
Message-ID: <20210807115625.b09fdf35b0251206b252e19a@linux-foundation.org>
References: <20210807082835.61281-1-linmiaohe@huawei.com>
        <20210807082835.61281-4-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628362591;
        bh=R4KUtAstqXIu436XTZFaUdZcmaVE6hSEsEnvEkhR7y8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t7dPrU/1MCltJi1oDzxqNIGo8JYvyP0pLs2pCPY7uRqI5e568Vl/aHvm0NZGCTLB2
         L+UrsPJUiV/enlnUkL2hsFUkon0/2pbXXixkCE7Yh3EHC3xnAixdACATkopZhCaN9f
         zVZb5wDA/YrXr2zfqXAtGNVtT9Mw9qWCazjXCPxY=
In-Reply-To: <20210807082835.61281-4-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 7 Aug 2021 16:28:35 +0800 Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:

> We should get rid of percpu_charge_mutex lock as Johannes Weiner said,

I'll skip this one for now - it all seems rather uncertain.
