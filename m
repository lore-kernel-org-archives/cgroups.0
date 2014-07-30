From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: fix the WARN_ON() in update_nodemasks_hier()
Date: Wed, 30 Jul 2014 11:27:39 -0400
Message-ID: <20140730152739.GA23734@htj.dyndns.org>
References: <53D899A1.3080003@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=KTcvJiOWeyfv7kLQyx7RN1W9aIig5Vv/0v7dYX2ELfM=;
        b=JDximlet8AjkaGM/Ry5/JiNlwvio5a1dJlz2lR54XWj3DL6+9Ij5vHtll0b2c0dMZK
         WVGAfFY0nU+tqGVfeK4a+VnVouaH1AG+40qJ/LGodMQHbEaFe2AChHX2TEN3XOYi4wFC
         JO1jrXoivPv2/3WhFVU6ut2Z8cZPKKK5MAdG4r2c6JRIPMp8LCjXTgUENsxp0WEvpa6J
         kWtQXZl5iJc0PD698e8Q9AacAjbsgAlGzVggsNnmPpSqkNuEgoZ/baMn3EuIHNFmQ853
         D1O2SLtJsUFku8A9Ayu32czBRf3ThJ9pMq179bcQamw1/cS5pGBGf9oxYZHLZhlKxEQ/
         XsFA==
Content-Disposition: inline
In-Reply-To: <53D899A1.3080003-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Mike Qiu <qiudayu-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 30, 2014 at 03:07:13PM +0800, Li Zefan wrote:
> The WARN_ON() is used to check if we break the legal hierarchy, on
> which the effective mems should be equal to configured mems.
> 
> Reported-by: Mike Qiu <qiudayu-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Tested-by: Mike Qiu <qiudayu-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.17.

Thanks.

-- 
tejun
