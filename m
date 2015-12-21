From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RESEND PATCH 2/2] cpuacct: split usage into user_usage and
 sys_usage.
Date: Mon, 21 Dec 2015 16:33:28 -0500
Message-ID: <20151221213328.GP4026@mtj.duckdns.org>
References: <1450696483-2864-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <1450696483-2864-2-git-send-email-yangds.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1TMWEtf5lXTKGezgO7yASRaXltJTDL/OcD/l60lLiog=;
        b=Mq5tv2+oQdB4IfaUmL6wVhdD7Y6uBuZqcIykmnyvg8d9F6GpBAsppFJFIT56mPooMa
         326TVikWC4cpe7+kjs/tY9uQW1FXNMbNfIjqjsIo67ElRU17Mc8Odp8CZolNOvVNVPHu
         CvpFQGE+NmNfLZ0glCW9m0ziwHHllde4b7jF5umfM5iwtNysZ4NMsXP6/Km7DHjoeBKU
         FuMVMFGENODEE1+7V+njTq0QVIIj3SvXzdmXuF/S8jx3sgMekwifANC9XdJn5INUJq+4
         7sN+8KLXWOlaH9nq9UsqkAFh9/949AaYevcJeFOdnoHWbwEeaRaTNauQ26hNmnZPiP2y
         S03g==
Content-Disposition: inline
In-Reply-To: <1450696483-2864-2-git-send-email-yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org

On Mon, Dec 21, 2015 at 07:14:43PM +0800, Dongsheng Yang wrote:
> Sometimes, cpuacct.usage is not detialed enough to user
> to see how much usage a group used. We want to know how
> much time it used in user mode and how much in kernel mode.

cpuusage is being phased out.  If you need these stats, please
implement it on cpu side.

Thanks.

-- 
tejun
