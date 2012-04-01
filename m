From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] block: modularize blkcg config and stat file
 handling
Date: Sun, 1 Apr 2012 14:42:43 -0700
Message-ID: <20120401214243.GA12536@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eIjNMtGZ3tPsN3AvgTE4RZgBW4pxK89WvmPLuY7J/8k=;
        b=pM3WxP0O05ChGH/sKSY6oOC5BTGgceDcfyWmc4e9MQegUeUZcMaL8PYSiyCtkkoUBo
         ZPI7/aLEC3Amq4O/d/JZtqzBwsc5yMNHE3CiBOP4Gwkk1GBqumqx4GDNbHuuQgya59SH
         F6sMrFDAB2T9Uo8jtEZ9IWmJeHluCIA6/5jWuh4CnMC25hrAW0gwl5lruVeicTrACASL
         nPepP/PNk6W5xocvrT9Kx1xOUrMnoucane3DDOCPKA9a/w5ic5P+zw+Hf0H1sFgW71DO
         /u8VuLgr5aVpEVTPFGJxcIR2yJUaS+ZSVEFZGaWE64PjDUGjHbWbVjZnska2G9msf0a8
         FsEg==
Content-Disposition: inline
In-Reply-To: <1332975091-10950-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Wed, Mar 28, 2012 at 03:51:10PM -0700, Tejun Heo wrote:
> and is on top of
> 
>   block/for-3.5/core eb7d8c07f9 "cfq: fix cfqg ref handling..."
> + [1] cgroup-cftypes d954ca6469 "cgroup: implement cgroup_rm_cftypes()"
> 
> Note that the cgroup branch is temporary and the merge between the two
> branches aren't trivial.  I'll prepare a proper merged branch once the
> cgroup/for-3.5 branch is settled.
> 
> This patchset is also available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-files

The above branch has been updated on top of block/for-3.5/core +
cgroup/for-3.5.  Ready to be pulled.

Thanks.

-- 
tejun
