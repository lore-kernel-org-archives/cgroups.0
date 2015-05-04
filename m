From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blkcg: remove redundant code in blkcg_css_free()
Date: Mon, 4 May 2015 12:16:17 -0400
Message-ID: <20150504161617.GD1971@htj.duckdns.org>
References: <5546C02C.3060803@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=YzjW9zBpGHZuXVku2DDZighHTrHn2uIv4TxPLNV/2Kc=;
        b=0AXSLTOjNzs0sDK5bNaGpOFymEXZgb9l9kGcDPufZIEQEMc+NdsEP1w9TAucY2P6Cd
         JF2tNHqHHvji3F1Dt7qRLR7al52HFIkmsfXqULwHNHgSkkRuWdVmu4mzy1tktx4+y7Qq
         JW5Rw1XubNfWsIbvodhWCm0O/vpf/Q8kKuTbd6/c18XZXnUmj6fC2jObBjQWXcxyI735
         UvBm1ay32/fqtdOT7spPUjMcebB8IHWYf8muxBPQzsHyCthPAm4IsphgYoWg6VXzt+6i
         Z3w485SJs8dJNocprBFzfMfuAbE8OC523fq+1COyAk+WzEBvV26o7WdtW0egRw+ld4Vn
         Xt1w==
Content-Disposition: inline
In-Reply-To: <5546C02C.3060803-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, May 04, 2015 at 08:41:16AM +0800, Zefan Li wrote:
> The check was needed only when we supported modular cgroup subsystem.
> 
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Jens, can you please take this patch or shall I route it through the
cgroup tree?

Thanks.

-- 
tejun
