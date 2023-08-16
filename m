From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Wed, 16 Aug 2023 10:51:12 -1000
Message-ID: <ZN02wFqzvwP2JI-K@slm.duckdns.org>
References: <ZN02iLcZYgxHFrEN@work>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692219075; x=1692823875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/36aw1xmDrnWgBaeP2BLSKHpeS0jtx76RKcl679jDEk=;
        b=mlDFmkAWIAw706A5Q/2UucACgJXVkzTw8eFJOQn88+CxlaPt4SaCnnTRx27vUUv7cB
         Zze96Ru+A+82vcL4rlMlApTPMi+tbSLnFJIFH+vPsFy1dVKvGjbBn0Phe+M+9RX1fnvK
         uddcN27TPeQWvy1yrDfLBjAMooFbkrYoIW8RNE5HvigZhpXIVsFLiclGGN6w2s/qtpVu
         bAMiDg9eO/YNn1twwpJs+i9ieBOkRI2PBc4vyJSaw2jmNcUSDWXmPBi6UliFZ69NSjLe
         /Wu324aj48ZsND83y52LwIU42qOiUNlYAngPwqS/fkFFAnrMsqbDCf3BFIWFensD2oi5
         VN8A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ZN02iLcZYgxHFrEN@work>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Aug 16, 2023 at 02:50:16PM -0600, Gustavo A. R. Silva wrote:
> Change the notation from pointer-to-array to pointer-to-pointer.
> With this, we avoid the compiler complaining about trying
> to access a region of size zero as an argument during function
> calls.

Haha, I thought the functions were actually accessing the memory. This can't
be an intended behavior on the compiler's side, right?

Thanks.

-- 
tejun
