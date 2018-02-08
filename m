From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND] blk-throttle: dispatch more sync writes in block
 throttle layer
Date: Thu, 8 Feb 2018 07:41:05 -0800
Message-ID: <20180208154105.GO695913@devbig577.frc2.facebook.com>
References: <557effc5-65f0-5190-477e-6d20b7121b59@linux.alibaba.com>
 <2c190660-1c35-3813-de7d-0cbfec9af7b1@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hsw72OdFSdljxrkI/QgSIgxDqwzWZOOgoGPHllvX1fo=;
        b=f1fe/EA4n7C7pxKIHG8Xn4+EHy3DEM0wQAvIBXJuGXoWBpoT496LH69Cs+gAW6a0ll
         ElE3UEZWKqPbU5gI7WbhkPECZ5qBqjudRg2OS7WoV5RRslnWmYTmcFYaiff8jOTaB9Mj
         VDA1d0i7Ni1PFe3sdeDLZBuYJtPKeThbAc+AztkTOuuAGk9IvmN9yBG7gilG0cyN2Vqg
         LU1arS8NgY1iZtjJvUu8nD7CgV+NiwAxKrURv58fT7plN/68hPTY4gcmM45R573aq1+w
         OH0F8bClNYDRU66sXpdSHGYYmnDa8Mj0NdAv+A1Dtu+gMX1g9a6H3HWXUGlMRdEagoAE
         3s+g==
Content-Disposition: inline
In-Reply-To: <2c190660-1c35-3813-de7d-0cbfec9af7b1-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: xuejiufei <jiufei.xue-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, caspar-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org

Hello,

On Thu, Feb 08, 2018 at 11:39:19AM +0800, xuejiufei wrote:
> Hi Tejun,
> 
> Could you please kindly review this patch or give some advice?

I don't have anything against it but let's wait for Shaohua.

Thanks.

-- 
tejun
