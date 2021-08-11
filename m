From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] blk-cgroup: refactor blkcg_print_stat
Date: Wed, 11 Aug 2021 07:56:40 -1000
Message-ID: <YRQPWJS3LVbiubs2@slm.duckdns.org>
References: <20210810152623.1796144-1-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3ISDCxbC0OsTshs9YdIziBnJ7D+uMqsu/ILSt9X0dxQ=;
        b=XgJVt0h7y/te1WZ+8bc+lSss2d6dT6f/ugcIJg2cTf/YeEo0GnUA1aKpj4BC5CORUX
         IOOGZou+zCoGZoC9Jy0WPjpMV55jn1hTTYb5UI9ICBZs81sHplWjDcQcOXdlhJC9LBkz
         CTRNFnLHL6b2ge3AZaSjg/+MOXrltfyEPrQwMksqCcnyRiJNgYGId0LN5JwZnfky3sWQ
         ByW5Ba58LNtePDFGhHyQDObBzc+i8ET2DLa24ktyM64RKPY/fqNKtHbL8X25c+06iy+p
         q7JK9FNPoTxfTuHFxDvuljwRJ8IPlpZgASn7KThKsWs6/q7+uHWUXPEKt5gZ4Sgbk5Ej
         T7GQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210810152623.1796144-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 10, 2021 at 05:26:22PM +0200, Christoph Hellwig wrote:
> Factor out a helper to deal with a single blkcg_gq to make the code a
> little bit easier to follow.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
