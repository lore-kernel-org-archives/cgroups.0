From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: make the default root invisible when it's
 umounted
Date: Wed, 4 Jun 2014 21:20:11 -0400
Message-ID: <20140605012011.GB14370@mtj.dyndns.org>
References: <538D4956.5050205@huawei.com>
 <538D4982.10905@huawei.com>
 <20140603130144.GB26210@htj.dyndns.org>
 <538EE00F.10406@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zD10ddM3MXOgoXr//+NDMoCszTGHZa4q0bFX9AVnKEU=;
        b=oGUrQ4zysMbgd5Ma39aKTNRtRQSaPZ15Et2d+8coupDF+NdkGO7lpFS71R/S1EdITf
         id56rH8E0bBijOrDeAd2OgCnz6iE155PcpD1qJuwKUnPvNNLpShVlFa6f9TfdKR4QdXr
         9I8a3TaBXRBNFit7RIWFxMnQpfZO1qTcTrEz2JEsXVlGFMLjrQb/LtaEOb0xSfVNtOfB
         1OkbI7r/7QL2mQlA0RH7BdhZJXv+aCAwl47npA3Ny3rVivHYSr3NcmH1Z2IxTqs/LKww
         cZWWLlJ7AUw1x0JhhEksvUfbXIJW17FySk4a4lkkwXkiNu0y8tuBzoze4uvvGCx1AJFv
         XPlw==
Content-Disposition: inline
In-Reply-To: <538EE00F.10406-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Wed, Jun 04, 2014 at 04:59:59PM +0800, Li Zefan wrote:
> The example I gave is the same result if sane_behavior is not specified,
> so this is a behavioural change for the old interface?

Hmmm?  Either the userland knows about unified hierarchy or not and
there's no point in hiding it if we know that userland knows.  It's
really a system-wide thing which happens once.

Thanks.

-- 
tejun
