From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 RESEND] cfq-iosched: Fix wrong children_weight
 calculation
Date: Wed, 27 Aug 2014 10:15:05 -0400
Message-ID: <20140827141505.GA12537@mtj.dyndns.org>
References: <1409128352.11712.2.camel@ubuntu-vm-makita>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Tb0Kgr/3suJ4Loo4dCErYd6Z25BZxE0sU3rylS7YimA=;
        b=XRmdlGhNKq3GpHhS/A5eQEVKmALDngYd+YT+iD0mC3DVruWk1K1jeyJtRIpbE44Vbb
         vmTKumGHY1tPcQSoshiF8RFkAGblqmaQAOu6kj6Hi99w6H/gEjA7hg2xecVk1PxAu7nb
         Op1RIeOsny90OlLYnwtxD2rXrUnWWcQ/sZ7/IEmpTIAb73tMu5Q/+2gELs7Spfw+6z33
         0k/FyEsc11DO1j0vYoQ2/eTRDUjWQB3VX3QPliffEbxbZtdpNpMPnvDdmXQSS0i/qgnu
         GBmZ8e96Vxzs+HZExiePnqGjG5/s3P2SemUouCJs48wY1D84zCJKQIzkNx5anUFLWzw6
         wWLw==
Content-Disposition: inline
In-Reply-To: <1409128352.11712.2.camel@ubuntu-vm-makita>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ruki Sekiya <sekiya.ruki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

As it looks like the patch needs to be respun anyway.

On Wed, Aug 27, 2014 at 05:32:32PM +0900, Toshiaki Makita wrote:
> +	/*
> +	 * Update leaf_weight.  We cannot update weight at this point
> +	 * because cfqg might already have been activated by its child.

Maybe something like the following is better?

 because cfqg might already have been activated and is contributing
 its current weight to the parent's child_weight.

Thanks.

-- 
tejun
