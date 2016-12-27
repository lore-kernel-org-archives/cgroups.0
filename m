From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: reorganize cgroup source files
Date: Tue, 27 Dec 2016 14:53:41 -0500
Message-ID: <20161227195341.GB31771@htj.duckdns.org>
References: <20161220210827.11176-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jCB/16zQWShLQDZIAzmHrXxUUpyfl63IwRZAkCkbSzc=;
        b=HoIWcHI3Z7AP/cutgkwj73LTbEg2h3Qb09Wfu/sqii/mR3a6y7L8RbTU2xdpZi+8oC
         +NU3Z1SG80MP+Gd6YTz0DWZPZR0xO5RA2Sj0S+vL25fDbYAvry52+bP2j5bS3E94IIyW
         uNFMLgte5VcUmsxXCxgnRpvCP7MSmzPAKP3kSTKXqUHfP2Rx3vMoEqoB6Sg4GCJnVop/
         L5jJxAf16DwDb3g0dNbml6ZMR3GLFx1xkadsCnzDSpDI/SDOvLG4b9+4UJhs1WGAga1P
         n+iNuKJcAm6mYpqtDdOrkdWB5lZDW0e4moCJNkAu+QNxr8kciCwQYgmXItPAnFm4lLjd
         Bvww==
Content-Disposition: inline
In-Reply-To: <20161220210827.11176-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Dec 20, 2016 at 04:08:19PM -0500, Tejun Heo wrote:
> cgroup source files are getting a bit too unwieldy.  Let's reorganize
> them.
> 
> * Move cgroup files in kernel to kernel/cgroup.
> 
> * Split cgroup.c into multiple files.
> 
> The only functional change this patchset causes is loss of a
> WARN_ON(); otherwise, everything remains identical.

Applied to cgroup/for-4.11.

-- 
tejun
