From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm: memcomtrol: add warning in case of rtpn = NULL
Date: Mon, 21 Aug 2023 15:25:53 +0100
Message-ID: <ZONz8Zqwg4cuCGCe@casper.infradead.org>
References: <20230821142051.31889-1-abelova@astralinux.ru>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VBLWbhiJ5Y+LfXHbB2wVDfY3nQIzq6btaVbaMioHfUU=; b=Ob3wf54jrst6pqEm8LXcrMnm9m
        zF7UTAPg+4G/Z5X/gaXsOzPf8/oPTBEWz7UZaZpozdHcPyh6WMpbkSp/NnhWspC2e246EiVEkjRLu
        d3r7s09NuEB8Dzoy+YQ6SoiraRD8K64+WiEeWNAcaI+BDL6Zjqsfy32mpPbM7Ey+s3JKw4YnuH0rI
        yxCGVA86DMQPQD/4plE7ar23F5o6tS5xMrhF41ovILa9yv/Ro1TbOpb/vfms/cgwecRF2N8Mt/v0B
        +JDa9sUH+GMEPdmmz6EU1+XUSOYsC4qneL7wNd5mx3dBA0dplXzyTpv9rJoKsObtBWZB73hH/XH+m
        LoJI12zg==;
Content-Disposition: inline
In-Reply-To: <20230821142051.31889-1-abelova@astralinux.ru>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anastasia Belova <abelova@astralinux.ru>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org

On Mon, Aug 21, 2023 at 05:20:51PM +0300, Anastasia Belova wrote:
> kzalloc_node may return NULL. So rtpn should be
> checked before dereference in mem_cgroup_init.

What good will this do?

>  
>  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
> +		WARN_ON(!rtpn);
>  
>  		rtpn->rb_root = RB_ROOT;

so you'll get a warning right before you get a crash, which will provide
exactly the same information.  And you'd already have a warning that
the memory allocation had failed (because __GFP_NOWARN wasn't set).
So you've increased the amount of data from 2 dumps to 3 without providing
any neww information.

If you _did_ something to avoid the crash, there might be a point to
this, but the fact is that small GFP_KERNEL allocations _don't_ fail.
You need to teach your tool that, or you'll be overwhelmed with
false positives.

