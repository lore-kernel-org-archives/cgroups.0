From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] sysfs: fix namespace refcnt leak
Date: Tue, 25 Feb 2014 10:17:55 -0500
Message-ID: <20140225151755.GG26788@htj.dyndns.org>
References: <530C7E6C.2020500@huawei.com>
 <20140225144256.GB26788@htj.dyndns.org>
 <20140225151955.GA8322@kroah.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=atjh15wNCQDzH+ayheORJ9M2bsjGYH4wKq6ZKjm6tGo=;
        b=mlwcxyiPNNoDnB3fdYnjxTfnYvEKD9pybv/8Kx7fnz5EewsGxr3l6K+75shaoN24f1
         b7J5Zzv489YZn9TRQfnGM2JTCx98uUq0Tg3XacLVrih/y+kFDyqGlcTihit6KKNdGJSr
         Q5vA48+pdk1ERLYkpxdsJTFYC5tkXGCI0pRv4x5lz7EUIvIRdvi1O+W+ZWlMQ6MZjeMH
         OeHX3moZzhtMAlcCGdCoBg10r46YOWwP4Ym16eEH30tRnu5FpKGHb9px7T67t3tsocV7
         /rFufQ+tnxvGJRD//GQqA3UfgklN56IFHlV/fn2UdYWQGxwXSuPK5AAfo+ICG/EAo7wO
         qLeA==
Content-Disposition: inline
In-Reply-To: <20140225151955.GA8322-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Feb 25, 2014 at 07:19:55AM -0800, Greg Kroah-Hartman wrote:
> On Tue, Feb 25, 2014 at 09:42:56AM -0500, Tejun Heo wrote:
> > On Tue, Feb 25, 2014 at 07:28:44PM +0800, Li Zefan wrote:
> > > As mount() and kill_sb() is not a one-to-one match, we shoudn't get
> > > ns refcnt unconditionally in sysfs_mount(), and instead we should
> > > get the refcnt only when kernfs_mount() allocated a new superblock.
> > > 
> > > v2:
> > > - Changed the name of the new argument, suggested by Tejun.
> > > - Made the argument optional, suggested by Tejun.
> > > 
> > > v3:
> > > - Make the new argument as second-to-last arg, suggested by Tejun.
> > > 
> > > Reviewed-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > 
> >  Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> Is this needed for 3.14-final or 3.15?

It also fixes sysfs refcnting, so should also be applied to 3.14, I
think.

Thanks.

-- 
tejun
