From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix missing unlock in cgroup_release_agent()
Date: Sat, 20 Sep 2014 12:24:36 -0400
Message-ID: <20140920162436.GA3681@htj.dyndns.org>
References: <541D203F.4020902@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=SyPEqd94TQ5xGXsHX9kn5i1Es0Omk61BRiapD9mzmMc=;
        b=jk8nEekwcgrfpff36iisj3iwYLMueI21UyZyPX9BckMF/qyoZAVVFZCBcnx+NBo54t
         +A1lRfUIvm4giT7VBuXFwuJzjSsKRirFZSv7dN8agk/kzZO+7Kuv8TUt8oqRZOSou4q9
         63yH7L+c41tzLeHwB6R771XcZ7MuUvCJmOGfPdvUCxgjrBDvhf3GWcbpzVvFkDpCfMpg
         WLOx9Av8bT9t29PF58thtEvLFayiouNcw9tmaY3K9jMF40adOTLrFyUChRS1/XDb/xKl
         P+JtWgZLzj86HeKppol5j6j0gp7wCIc4MNWfnP67A4DW5K0ZWkkATKkjFPaEY8mpkEma
         8QCQ==
Content-Disposition: inline
In-Reply-To: <541D203F.4020902-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On Sat, Sep 20, 2014 at 02:35:43PM +0800, Zefan Li wrote:
> The patch 971ff4935538: "cgroup: use a per-cgroup work for release
> agent" from Sep 18, 2014, leads to the following static checker
> warning:
> 
> 	kernel/cgroup.c:5310 cgroup_release_agent()
> 	warn: 'mutex:&cgroup_mutex' is sometimes locked here and sometimes unlocked.
> 
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
