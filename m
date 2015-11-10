From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup_pids: add fork limit
Date: Tue, 10 Nov 2015 10:12:23 -0500
Message-ID: <20151110151223.GA17938@mtj.duckdns.org>
References: <144716440621.20175.1000688899886388119.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=cj/WWD3Pc3GXWEJqHcCWdLwbeHRoWhgL3qDq0Y17wq8=;
        b=FnuNdcG3phqYN93O+nQAhKSIm6WSx5UtUWKOXABF23Wr94VfEEXk8yCUvPTr8/fg/v
         PZssA4gmiKLvjDFjJZxiBnTgYVH7a08SDarprAAmxkjOaUUjWhSr/uA/sMg8nZeUrr68
         kcSsjhptFxUbC+K81p4IMtJVHKFmuK2eBX1iLKcm0MZS9qQo9f5zB+H1aGaiFw2stvz6
         aZK0ztIIwgPQj3/FpOc+2+c9OoB67V/WNbfdU6zu9QPsks5AG1Tl9AXbhxFIGLK6LRWq
         uj5LM5dz05TcLFpkWUEljYHZs//T76SRYQquaigdOY9yeV6qJUurSMfPlz72Y9fmgYqB
         +cbQ==
Content-Disposition: inline
In-Reply-To: <144716440621.20175.1000688899886388119.stgit-Rjmu19FXx3rR8JxBgnUBv+rzNCUFrscg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Max Kellermann <mk-xMchvyqCc6DQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, max-hDT0AjmEH7RAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 10, 2015 at 03:06:46PM +0100, Max Kellermann wrote:
> This patch introduces a new setting called "fork_remaining".  When
> positive, each successful fork decrements the value, and once it
> reaches zero, no further forking is allowed, no matter how many of
> those processes are still alive.  The special value "unlimited"
> disables the fork limit.
> 
> The goal of this limit is to have another safeguard against fork
> bombs.  It gives processes a chance to set up their child processes /
> threads, but will be stopped once they attempt to waste resources by
> continuously exiting and cloning new processes.  This can be useful
> for short-lived processes such as CGI programs.

But what's the resource here?  All first-order resources which can be
consumed by forking repeatedly already have proper controllers.
What's the point of adding an extra second-order controller?  Where do
we go from there?  Limit on the number of syscalls?

Thanks.

-- 
tejun
