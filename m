From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/4] device_cgroup: prepare exception list handling
 functions for two lists
Date: Thu, 24 Jan 2013 14:01:25 -0800
Message-ID: <20130124220125.GV2373@mtj.dyndns.org>
References: <20130124194957.198022148@napanee.usersys.redhat.com>
 <20130124194957.375712635@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=8bMESgLY4c6mMYpnE2vrL9iClV1h+gWF854NtB6hdXo=;
        b=iGDf3TLwC1UDRmH8/VAsjCwDjaVjSvOP2zlHrBKF4RdtUCCkJGBS4Ofeeja5XjZ489
         3Wvv/nNmp4MdyLo/zqZUJAoQaXwteYwzKuLnL7xdPZtROUEkrmteL2ZzbJgJD559/C2q
         w4oeJMpPVWGfKhAnmtVEQDYqc8BwgHhAHo5yGoU0TmuR/mL1K0DSgvuMUzI4JCp4umvB
         Dm0ZLXEti5yeR+iTrWZmxiwNLWvja1a0TCNCKgcrCjmE2qGtljQ0bWBsnvvxyiISUQuw
         CExa0PBnzGzo62ggs+ls10cUhnQideUDDfb9ZKiu5XY7ReZlI8LQ6zsvc6pDmre2nFSW
         DclA==
Content-Disposition: inline
In-Reply-To: <20130124194957.375712635-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Thu, Jan 24, 2013 at 02:49:58PM -0500, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> In the following patches, device_cgroup structure will have two sets of
> behavior and exceptions list (actual one, another with the local settings)
> so rework the functions to use exception list, not a device_cgroup.
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

-- 
tejun
