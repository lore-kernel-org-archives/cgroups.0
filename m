From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: clarification about misc controller and capacity vs. max
Date: Tue, 1 Nov 2022 06:54:34 -1000
Message-ID: <Y2FPSqOaQGnISvXu@slm.duckdns.org>
References: <2f7b7d6b10bdcbc9a73ea449d3636575124afa25.camel@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=spsZndBT7leVOWuziIPS4xU0aN+hFOZ8iUUTPETtklA=;
        b=AvcaKX3jDJlPbj+XUFXCw/eNC1XntbhLZOVPgZ+tAFa/w5ylcYNV6PCYWT0S5QF1/o
         8Yyos9IKlZ+YvbCz5y9hBe31IIvFXdv0zsQrC+ECFrZFwYbxp80vbv9p+FZwokqriof5
         pAhCJp7S75lfrFvVwv5RIRYfgAgbuREIePNpRiloRNBcNsUycaU7RbPybIb8VszXADKI
         uVi7nJB1U8sQf6EUJsxS7AkP6G6UIGgQXIWqsz8oNI1xa9/xrPbbG7MbvXlSFcCM5e7e
         DD8+rDC1bisp9MQJqmk4MNMEZ7tWXFVGl1rtq/8XaonFT/SX3Nn6YivWUVdc7s6ocLF3
         g0Kg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2f7b7d6b10bdcbc9a73ea449d3636575124afa25.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Accardi, Kristen C" <kristen.c.accardi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Tue, Nov 01, 2022 at 04:40:22PM +0000, Accardi, Kristen C wrote:
> I notice in the comments for the misc controller it is stated that the
> max limit can be more than actual total capacity, meaning that we can
> overcommit with the resource controlled by the misc controller.
> However, in the misc_cg_try_charge() code, the function will return -
> EBUSY if max limit will be crossed or total usage will be more than the
> capacity, which would seem to enforce total capacity as an upper limit
> in addition to max and not allow for overcommit. Can you provide some
> clarity on whether the resource consumption model for the misc
> controller should allow for overcommit?

I think what it's trying to say is that the sum of first level .max's can be
higher than the total capacity. e.g. Let's say you have 5 of this resource
and a hierarchy like the following.

        R - A - A'
          + B - B'
          \ C

It's valid to have A, B, C's max set to 4, 3, 2 respectively even if they
sum up to 9 which is larger than what's available in the system, 5 - ie. the
max limits are overcommitted for the resource.

Thanks.

-- 
tejun
