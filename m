From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: unexport {,un}lock_page_memcg
Date: Fri, 20 Aug 2021 09:58:53 -0400
Message-ID: <YR+1HfvIJ2K53flA@cmpxchg.org>
References: <20210820095815.445392-1-hch@lst.de>
 <20210820095815.445392-3-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dJyHipZjn+A3UTVcbj+8xVGYmbEmgDxWJmSdu5/Aei8=;
        b=wF7LYu5sQHUWhmZ/2pO0l/fpD45tai9NK9qM04KFze6DgiXS007/iNB+WGyWl4z36/
         LMalj5UXM0fbkrl8h7O3lSxrfJEo0dBa8TfofFc/92h6FZmo9cIZfrMP5s79keMgNwOr
         PMtBmaGTd1cEVwAppYt6aRHyUkPWowwwYLUaG115yo7yYR/s4wjQjsxt+BBg3d6p3p1h
         BweB0duvM9cpyW+Q4OKP20YM0pH9/OM1mi5xmIz0LkpgnfBure8zXdMdjs2/Q9KBbZDd
         pz1Rn5tVIfdVkgMkbpsIb7T6bsU8E49qhEkT1QIn1xjIl++xtm1CO59w6FN1JJUdYZn6
         a98Q==
Content-Disposition: inline
In-Reply-To: <20210820095815.445392-3-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Aug 20, 2021 at 11:58:15AM +0200, Christoph Hellwig wrote:
> These are only used in built-in core mm code.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Good catch.

It was initially exported for xfs dirtying, and is no longer needed
after that switched to iomap (and now __set_page_dirty_nobuffers).

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
