From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] make 'none' field a flag
Date: Tue, 13 Dec 2011 07:41:08 -0800
Message-ID: <20111213154108.GF25802@google.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com>
 <1323614738-7405-5-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jEkUhds+wT0sBeRTnZ+dapQxwNMEJ4qpcUUjcRjBEgg=;
        b=ZXj4G0bL4lHEDWf7IFiiZ7gHC6Mlrj+3cT5dtz/33kC2c2W0WTYX4Z+gCuwcj/4QFK
         ltV35vR+grostUD7JDYO4nOSZBMl2bLO3ph6PP2HqjG0g0W+KB4FUYmTV8gp8v7VJA/G
         KF136Vf6sH/aJUIsnbCZJVyfmKODyQ/sJHQNE=
Content-Disposition: inline
In-Reply-To: <1323614738-7405-5-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On Sun, Dec 11, 2011 at 03:45:38PM +0100, Glauber Costa wrote:
> There is no reason to have a flags field, and then a separate
> bool field just to indicate if 'none' subsystem were explicitly
> requested.
> 
> Make it a flag
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Same as the previous patch.  Doesn't this change how remount
conditions are checked?

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
