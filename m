From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: reset css on destruction
Date: Tue, 1 Mar 2016 12:06:52 -0500
Message-ID: <20160301170652.GG3965@htj.duckdns.org>
References: <69629961aefc48c021b895bb0c8297b56c11a577.1456830735.git.vdavydov@virtuozzo.com>
 <92b11b89791412df49e73597b87912e8f143a3f7.1456830735.git.vdavydov@virtuozzo.com>
 <20160301163018.GE3965@htj.duckdns.org>
 <20160301165630.GB2426@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NmCCFMHCHa74/FREzfUMT8qt9KOFCZgqPgGsjYPs1YI=;
        b=Qpm1afJGFVn5qDeUbHaBU1hzTwOTiPGikFLZc0Frmpa0YJSl/LJDvmHlbKDmEHSHa9
         pfAHUgUSj3onT8enDt30oBr7m2/1YChp/K9e2VWqXrK5z92wBsoVJYj+7qPjsD8tBSEw
         GEMtryza9IQNylJcvAsuo9Lp23TVm0cNu99HArMAPsvPAkPl9vhoDDiPggJfjfYapG20
         6A9tlgDZb6gfVCuAVvLOXFE/4Cc+s7vLZc6Y4njx0uBigfPQ10qFQUUFv2WXxHDEQsGl
         IOutGfvhTT0fHzTWYi2KhOkdedJw7dNbHwIzUCp7wx84tr6QLSxwJ+ROh+WxTW9IdNCp
         mDXg==
Content-Disposition: inline
In-Reply-To: <20160301165630.GB2426@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 01, 2016 at 07:56:30PM +0300, Vladimir Davydov wrote:
> From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Subject: [PATCH] cgroup: reset css on destruction
> 
> An associated css can be around for quite a while after a cgroup
> directory has been removed. In general, it makes sense to reset it to
> defaults so as not to worry about any remnants. For instance, memory
> cgroup needs to reset memory.low, otherwise pages charged to a dead
> cgroup might never get reclaimed. There's ->css_reset callback, which
> would fit perfectly for the purpose. Currently, it's only called when a
> subsystem is disabled in the unified hierarchy and there are other
> subsystems dependant on it. Let's call it on css destruction as well.
> 
> Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Applied to cgroup/for-4.6.  Thanks.

-- 
tejun
