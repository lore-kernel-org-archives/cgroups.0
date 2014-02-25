From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] sysfs: fix namespace refcnt leak
Date: Tue, 25 Feb 2014 09:42:56 -0500
Message-ID: <20140225144256.GB26788@htj.dyndns.org>
References: <530C7E6C.2020500@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=j7eA3O5Gc1isv1woxyvIUBaPFrof2TQH2uvzvJyPFng=;
        b=oCGoPITYwFl/tlcj37of3zX9/vCJtT05FghJ5BpbFuvuwJjIRyNTPwkETHsP6nRu5w
         ID5zXV12BDLJfVXkhllMte76jF42EZ+V2P6XY0prLpJECbOclPZFP+N8cTgCIb8umglH
         lc9h+UA2JyDgQylxVk6DnImp5bvjEKA2kIhFs8oI0RtpyriVHYaMhwdZ5BSPr1bmN/Gn
         Mzdkvdde5cyl/DJOZ8RACxpsTTTQiEf4lOTgO4Z+qnNup5bBNjwm8SbqbbUA+Tfjv7Kd
         PaI8hvS3F/GApiExji0plZmEHzUPBpyvP77XfBvjQlCD1ar56cis/64g07FtCPtSTISH
         rICQ==
Content-Disposition: inline
In-Reply-To: <530C7E6C.2020500-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Feb 25, 2014 at 07:28:44PM +0800, Li Zefan wrote:
> As mount() and kill_sb() is not a one-to-one match, we shoudn't get
> ns refcnt unconditionally in sysfs_mount(), and instead we should
> get the refcnt only when kernfs_mount() allocated a new superblock.
> 
> v2:
> - Changed the name of the new argument, suggested by Tejun.
> - Made the argument optional, suggested by Tejun.
> 
> v3:
> - Make the new argument as second-to-last arg, suggested by Tejun.
> 
> Reviewed-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks!

-- 
tejun
