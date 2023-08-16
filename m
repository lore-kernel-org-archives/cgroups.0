From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Wed, 16 Aug 2023 09:22:19 -1000
Message-ID: <ZN0h69grtuh2Iv8e@slm.duckdns.org>
References: <ZIpm3pcs3iCP9UaR@work>
 <e1c07dd0-e6bf-ca9c-107a-97c5043b1bc7@embeddedor.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692213742; x=1692818542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6yZbEgk5hOBil+6p82DAQcLxcHtlq0Gk/Obtt+1CIrw=;
        b=qKSP52F+/sORslglDOq8VwHya86yPq+jVHh3l/OsdYKeo4vmi0NSnR95HGEjuWXqLJ
         vr+8+ubITXS7B53tEYaJfBvd88MJ3ox9vuhn7NMOkuEVQBdDyBn9xLXZ1xWX/IsurP0V
         sz+nsf2GvYQT8vpOSaKmeNmET5kBzjDty1W2qJ75ob3XR94whTAdJyUzFRL1KbsIr2mS
         zaS+ywl5LBZhindR24QiUrLFEkNzAvUzrI/ezLNYnazWqfs12Q+wSQRHrLikf97SdHp7
         N1pnzml45IvN6LMVOM44PScABbAiPp+zdHCY6iF4KiGmbSmyTmOuMHGdhY/XIJbg4i+e
         q57g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e1c07dd0-e6bf-ca9c-107a-97c5043b1bc7-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavo-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Cc: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 15, 2023 at 01:04:32PM -0600, Gustavo A. R. Silva wrote:
> Hi all,
> 
> I wonder if you have any suggestions on how to address this issue. As it seems that
> my last attempt caused some boot failures[1][2].
> 
> At first, I thought that the right way to fix this was through a similar fix as this
> one[3]. But it seems I'm missing something else that I cannot determine yet.
> 
> These -Wstringop-overflow warnings are mostly the last ones remaining before we can
> finally enable this compiler option, globally.
> 
> Any help or advice on how to properly address this is greatly appreciated. :)

It looks like there are only two functions which misbehave when there are no
controllers configured. Maybe just fix them so that they don't access empty
array?

Thanks.

-- 
tejun
