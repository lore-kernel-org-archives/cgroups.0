From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: remove memcg_kmem_skip_account
Date: Wed, 19 Sep 2018 10:22:58 -0400
Message-ID: <20180919142258.GA15400@cmpxchg.org>
References: <20180919004501.178023-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CQ1dFM9Sw0pYDAvGYT6k29iUU9y9kH/dyOXYVbWUYw0=;
        b=ywElcmOA/951O4PoXvgSC4j1Au8RCiPCKT9hkusQDCaLFj6ILQvEM09Rng4zb9zAo/
         nRy71n+yVCWN7gMP4caTdIw3ZUiUc88/pIHkJYZGKcHm+PJgyoOchGj9rmJaPWubwrQY
         EqpyFpdQyHGPjcHG03hJFpnd0/Yi0nivate12o/zl3Tyl4OP8vt7UpUSL5zd72YlGibT
         Mjl/j7qTpZy30CEQnlM98l8SMbg1aMp8baXhwDpy8PmNmGgjFjqfBfyqo7Jii8M5CKfO
         1cJna+Yth6KJBoHlRk+I4mQZIxTeVGvl4uG29uEY58I8a0lfBpx3eAScU0Hf4KgTeCDp
         xoOg==
Content-Disposition: inline
In-Reply-To: <20180919004501.178023-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Sep 18, 2018 at 05:45:01PM -0700, Shakeel Butt wrote:
> The flag memcg_kmem_skip_account was added during the era of opt-out
> kmem accounting. There is no need for such flag in the opt-in world as
> there aren't any __GFP_ACCOUNT allocations within
> memcg_create_cache_enqueue().
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
