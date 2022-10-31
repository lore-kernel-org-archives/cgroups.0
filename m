From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] block/blk-iocost (gcc13): cast enum members to int in
 prints
Date: Mon, 31 Oct 2022 05:24:28 -0700
Message-ID: <Y1++fLJXkeZgtXR2@infradead.org>
References: <20221031114520.10518-1-jirislaby@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+WDg5qNBe76FnzbLrO8nDJQ46OMFpJ0zF+2XMGbgyVw=; b=G2KuZBTUsRRYlM25mWS2OzlfUW
        vRYmMylWTdj4cHrNo7JgTSQnawMwdiX2LlU1I4+ApxI+kAoZisrbAr8zzcpg/S005SSbFiLHHGUqG
        143M/86X3wEWKmpvLtPVqr1zYq5diK4PaOJAijthuaIugtmkywdHIz4FognofoOqYu2rhQ3DxCoGg
        gJY5lWQ8XPUvodlopUo4ayTh4utr4yFpoOaWGXsSjvzd/+CGTzGZZeH2nFk0GBA3O0x66is3Gp3AY
        JJvY2LLviOSEGgZex8koGgxEfC3gHovSwgpHYmzWnSl24pvHiWjugg9SIzCM8PdhCbDHnJ5NvKZSq
        X048//cQ==;
Content-Disposition: inline
In-Reply-To: <20221031114520.10518-1-jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Jiri Slaby (SUSE)" <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 31, 2022 at 12:45:20PM +0100, Jiri Slaby (SUSE) wrote:
> Cast the enum members to int when printing them.
> 
> Alternatively, we can cast them to ulong (to silence gcc < 12) and use %lu.
> Alternatively, we can move VTIME_PER_SEC away from the enum.

Yes, either split the enum or just use a define.  But casts are a big
code smell and should be avoided if there is a reasonable alternative.
