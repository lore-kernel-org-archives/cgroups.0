From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Thu, 22 Jun 2023 08:50:05 -1000
Message-ID: <ZJSX3bjnYTL0mCHj@slm.duckdns.org>
References: <ZIpm3pcs3iCP9UaR@work>
 <726aae97-755d-9806-11d4-2fb21aa93428@arm.com>
 <0d6377ef-bc34-784a-8694-478d0ade085e@embeddedor.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687459808; x=1690051808;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YoqKoCGD22r5x5TeJTnO4aO3qshyt7k/108oz2dWFVM=;
        b=ef2yQscTpwf7n4KiHLRh6c4s+xIN4XgQISZYvu2mQatB000a88NnB9WtUyBRWKPgH5
         c8THlyujQvlhIgyFS5E02s/8dAJAn53nKF8WzM3RRfWUwgOOWx7W6z/7xhpf91FGK+Ta
         XyHGBZgJLiI2mfbgZKWvCX3Pm15BFlFVt5g/3ZSSAMNkCKvAZXakiZsrQadnGcdqW41r
         qG4UwFmhNRbA8nr0WnnMJSUI/VYTT6vYgUNEfHdpn4h93do8VMIiu7RwX6tKSxVwrPJf
         9FzzE0TU6R7CeqT7qzz9owIVNV2lYb6e8usC575oTy1812Oki1QKCHe/XgoltAPHfl/4
         TD3A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0d6377ef-bc34-784a-8694-478d0ade085e-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavo-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Cc: Steven Price <steven.price-5wv7dgnIgG8@public.gmane.org>, "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

On Thu, Jun 22, 2023 at 08:09:03AM -0600, Gustavo A. R. Silva wrote:
> > Reverting this commit on the head of linux-next gets the board working
> > again.
> 
> Thanks for reporting this issue. I'll take a look.

I'm reverting the commit from cgroup/for-6.5. Let's try again later.

Thanks.

-- 
tejun
