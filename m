From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 3/9] device_cgroup: keep track of local group settings
Date: Tue, 29 Jan 2013 11:46:19 -0800
Message-ID: <20130129194619.GD6824@mtj.dyndns.org>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190759.713469698@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=oEbuSCMmsCYwAtsmWPvSNJ7p7S79m/yX1rJ43jNFo8E=;
        b=DjMgfkSwZzB43Uz199pNPPQUqHlNkM25SNRKufze+mowIxH8nu/BMnx80/KNy5nZNw
         +lhOUvqpkiqYLX4GDEjFv78W3PXOMqM9wITHO15yQPfjv2CgPPKxtSdo+UaUcRgfhcr8
         BGiBOnSGcR8Hgsd4gPZxMg3/ndobMOPw/MU7Mb9D3hF2goTlrUAYA6KyQJ1e2Lt05d/x
         ZesmVEKytsFUq6n1xXaIgifQVRBDNrh0cGd2BVczEqZNwzhG3Wi6alfld6htOW9cfTAM
         KgG9381u1AQJy0zwKM6/YG8QvmW338GWUh1EfesINqaM9hCL5PcDRLdBZrEfmXDmhMtK
         WzgA==
Content-Disposition: inline
In-Reply-To: <20130129190759.713469698-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Tue, Jan 29, 2013 at 02:08:02PM -0500, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> In preparation for better hierarchy support, it's needed to retain the local
> settings in order to try to reapply them after a propagated change if they're
> still valid.
> 
> v2: split this patch in two, one to just move dev_exception_rm() before
>     dev_exception_add() while keeping functional changes in this patch as
>     requested by Tejun.
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
