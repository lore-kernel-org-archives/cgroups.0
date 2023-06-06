From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] memcg: use helper macro FLUSH_TIME
Date: Mon, 5 Jun 2023 17:38:57 -0700
Message-ID: <ZH6AIdfebveDeeIL@P9FQF9L96D>
References: <20230603072116.1101690-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686011941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wiA42FcF9ikOR9ipiQl1i9SylwuyTjOy9LZNowrvTpM=;
        b=c2dnv750fpyzxYhsZ/yrFxW36Mu77iGdVzXfc59DqER1yh3PAam00+nKZEYOO+bB53KRHx
        +eLR5X5VjFziDARZI5AhkoruPoVGFGIb3YuBaMOaHazPQuQoNMUNsrJU7LtmRaA59d4NZz
        s0ich55Oa69wIAW53MSCXyLteIwCWZs=
Content-Disposition: inline
In-Reply-To: <20230603072116.1101690-1-linmiaohe@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, shakeelb@google.com, akpm@linux-foundation.org, muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Sat, Jun 03, 2023 at 03:21:16PM +0800, Miaohe Lin wrote:
> Use helper macro FLUSH_TIME to indicate the flush time to improve the
> readability a bit. No functional change intended.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
