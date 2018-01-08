From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH][RESEND] cgroup, docs: document the root cgroup behavior
 of cpu and io controllers
Date: Mon, 8 Jan 2018 04:15:03 -0800
Message-ID: <20180108121503.GK3668920@devbig577.frc2.facebook.com>
References: <e9761aed-4f51-07d1-6ede-d695ea5cb61b@maciej.szmigiero.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HplXD0O8cgreQ7LaB0fLhosGluARzcqXGIA6C33B758=;
        b=IqlgItDjZQGOhqD2OHO7U9BhpakjG8CieCI7Q1eK87kxaT6vrlVXNb8hChgvU/TZ1n
         IrniZg2uYlcfnLIzGVqYUFgiejgG1muLzsAvV3+4gLfT/nyw1M1AMDAM8qXE4j6cH4Sn
         EnGLy9100/MT63jsixjHqHCEVkd2NMN9+chTInbp8u6/PDrEDINOJ0JA93Pxvjc4IGT4
         ob+H+6XNkW2gTiR317ZM80evdaFH/qzxccNsAA6YJ3bBt0j461/rRny84JuBforQzp39
         nmoAeMe+4AdGCoy41Y2MOdvjQiB0FMRwJmB9XHmu7RzGYjqB64AROYCgdTIpoXopHuv9
         d8+w==
Content-Disposition: inline
In-Reply-To: <e9761aed-4f51-07d1-6ede-d695ea5cb61b-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Thu, Jan 04, 2018 at 10:57:00PM +0100, Maciej S. Szmigiero wrote:
> Currently, cgroups v2 documentation contains only a generic remark that
> "How resource consumption in the root cgroup is governed is up to each
> controller", which isn't really telling users much, who need to dig in the
> code and / or commit messages to learn the exact behavior.

I don't think we want to fully guarantee the current behavior.  On the
scheduler side, I don't think it's likely to change but blkio side
*might* change.  Can you please collect the root behavior in a separte
section and clearly note that the behaviors are subject to change?

Thanks.

-- 
tejun
