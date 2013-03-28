From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/5] cgroup: Remove subsys.active flag
Date: Thu, 28 Mar 2013 11:19:10 -0700
Message-ID: <20130328181910.GE14088@htj.dyndns.org>
References: <5153EF24.3040608@huawei.com>
 <5153EF8D.2080502@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=kAeRk2m8V9fbXrc8kgxmcVHrksZeoWFUoqwuB8uquR0=;
        b=wZ4AqOKBGQcf5g7IxbHfX46DXA6P149zbJcyIa2MWLlU9RG3y+QPY/x5ZcenyUUyLA
         09BL+ouHoMu3OhKIG+EQwnt/epMNuUbCDXf04dqQT+tgGVzMRieYinnXCIYJkUSfdpdM
         XiiUgBHaNk4D0di1p3d7bGn98FNU8r0RZHEqKrmN5xNM9eDLD1PnnPVmzrNcBUC6KRCp
         M1m9pxSlbw7rSZvspVEYYUEW+xhb0S7TmSoQC0pvsowvjfpYqbwPA8IoRPg/EvlgXH4i
         oz4+99/qoziCmXfRQZ7Y3bJ/br+C2qXA7tCQeDEBNSp1OMzKa7H/UVbvW5nf8Jhcml8D
         2+Vw==
Content-Disposition: inline
In-Reply-To: <5153EF8D.2080502-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Mar 28, 2013 at 03:21:49PM +0800, Li Zefan wrote:
> The only user was cpuacct.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

  Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Please feel free to route through -tip with the other cpuacct changes.

Thanks.

-- 
tejun
