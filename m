From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.19 3/3] cgroup: fix the async css offline
 wait logic in cgroup_subtree_control_write()
Date: Tue, 18 Nov 2014 02:50:43 -0500
Message-ID: <20141118075043.GA7809@htj.dyndns.org>
References: <20141113215813.GA2598@htj.dyndns.org>
 <20141113215848.GB2598@htj.dyndns.org>
 <20141113215921.GC2598@htj.dyndns.org>
 <546AE794.5070902@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rAA+NyecWJtdOyOTT7T1KAtdqtPaSyJDxNL1YPnuVmg=;
        b=CpmMX8CN0dayniYyA5ZZF9uAyFu8y453qLsnXfuTaWu3o+lWo9I20w0lKqM7bUBA4f
         7rR6ReSkqnkEp1/0w0qWKnp8LQHxd6mzKX/m/j/CK6La4wdu7SR4f+mtRHYg6EZdXwL/
         twCl03mU9fW5Fe6ayo6s+9aDk0UuZj/C/bA9ZpXcgRcwXPkyB1zhyfAkvBDe7TwmHfk+
         e5YVSMlam/P+xtA8dpkAgp/V5W/PPHtcv1Nxr5iSP/fi23BFpYg01lXhTcnZarwPAnQX
         rVgnjNRGWl6S461CGFiYhPKPE+rk7H9f1bqtnGpx41Kai+LTJgjtuujD5vUIeLsjuoaj
         yt+w==
Content-Disposition: inline
In-Reply-To: <546AE794.5070902-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 18, 2014 at 02:30:44PM +0800, Zefan Li wrote:
> For all 3 patches:
> 
> Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied 1-3 to cgroup/for-3.19.

Thanks.

-- 
tejun
