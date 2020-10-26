From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] blk-cgroup: Fix memleak on error path
Date: Mon, 26 Oct 2020 09:54:46 -0400
Message-ID: <20201026135446.GD73258@mtj.duckdns.org>
References: <20201022205842.1739739-1-krisman@collabora.com>
 <20201022205842.1739739-2-krisman@collabora.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cUT8Sy01NVeG6Z9oLzP8fHNeZqNa1h3Q4yE9nUY4mH4=;
        b=JXg5D7kCFBJVxLNDC5x4JSkTHc61NyFYC3pf51a28Uv1bIRisaqXT1bZnliDg7imPi
         i1xRI/jErcJTEwWCaH5uwXGu3RNOgcCp0E3J5qTxcaVo4XhGkrPwUCD3XvIAVsbMlPHC
         jZCFEsYQMUnucPPS2aX3zB2UY+++ii40fgWqazFVBdkTeb+cK2igw5nK3cwH8fUIXiqP
         Bf9WwT2c2nxrkYFHA8lPvHgWTvwHN5SzXSxo23PRntPWSv/spgvXujUUvA9Nj6mPjIVS
         otj4l69lLd/fpc9/jXA05QHVmijiNc4fj0LY6ejw8NnXTKogmHgTPQ4sSrAMqY31OfP3
         vnxA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20201022205842.1739739-2-krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org

On Thu, Oct 22, 2020 at 04:58:41PM -0400, Gabriel Krisman Bertazi wrote:
> If new_blkg allocation raced with blk_policy change and
> blkg_lookup_check fails, new_blkg is leaked.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
