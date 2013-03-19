From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 0/4] devcg: introduce proper hierarchy support
Date: Tue, 19 Mar 2013 14:30:39 -0700
Message-ID: <20130319213039.GO3042@htj.dyndns.org>
References: <20130215165543.131282532@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=Q8a50Zsi2mhSivfpIy2g1ROlcsBlAmWwlCmGE/TTFyE=;
        b=Q43Jl1NoGRmS0lor2HH/WrvVurakiZB0vtimuZ2l4qnvZST3MlQssWQxVNZkYatRN2
         n7GY6zCPRwxpkfsV5o1zUzUAgifUTmQ5iKibYMksn2jkOuuYlAnWynn3XGnEpKjvw9HZ
         IKoFFt83wQO2J8TaUKWCJ/H05i+Ce81DgVmHVyyIf40f+pbJuj+bL3sngoGxCV8ERrf2
         vN/62j/lWg2/yzt3o3Imq/tH4kXFKnCzOwe+GYcz4ZDc+vZ7GDiBWmAFH4zCtdEIQuFa
         L6NntBbW8CpX22Tl4SjLVJ5u4IaLeC2NXkprREl59EuTsuNhGZLl2/wbuNmKBN1tcp8U
         JiVg==
Content-Disposition: inline
In-Reply-To: <20130215165543.131282532-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Fri, Feb 15, 2013 at 11:55:43AM -0500, Aristeu Rozanski wrote:
> This patchset implements device cgroup hierarchy. Exceptions will be
> propagated down in the tree and local preferences will be re-evaluated
> everytime a change in its parent occours, reapplying them if it's still
> possible.

Applied to cgroup/for-3.10.

Thanks!

-- 
tejun
