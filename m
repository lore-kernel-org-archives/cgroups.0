From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: punt high overage reclaim to
 return-to-userland path
Date: Fri, 28 Aug 2015 17:14:23 -0400
Message-ID: <20150828211423.GC11089@htj.dyndns.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-4-git-send-email-tj@kernel.org>
 <20150828171322.GC21463@dhcp22.suse.cz>
 <20150828204554.GM9610@esperanza>
 <20150828205301.GB11089@htj.dyndns.org>
 <20150828210704.GN9610@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NbZ9X//8lgtxdCKr+mkIf55KJTnszyKHT/RNxbFBuas=;
        b=nIgivnxVrJkLU7d68S5FU7RWSrrgP8rcgMtGtK3nK12fyt1ZAtSh0x/MNQy/JUa7tQ
         VD03kM+O06NKovd6saudLDkNsc4pNV+eLdeAlNPVNFAbgGxR4KHM3s6ALQrOu184+zd2
         M7iD/jRy95wRIcshf1y6s/Xe5D6H5Os0gIQpnKOKXqmreEDdnX0BOdyT4l+ig7Ql/njx
         cxnOugyeD8ZJFHQK7di/Pfv5Orj2U/q4ZRVqmnu93aUfwAwppBRXFOOMKgHNdaVvsR0t
         Grqf3I9Mlnobt6Mgok+xzw75SQb1BTJbkkdCF1acKIjQ7G2dBkodoVAFnPeD6983dQo5
         JFDg==
Content-Disposition: inline
In-Reply-To: <20150828210704.GN9610@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hey,

On Sat, Aug 29, 2015 at 12:07:04AM +0300, Vladimir Davydov wrote:
> We should probably think about introducing some kind of watermarks that
> would trigger memcg reclaim, asynchronous or direct, on exceeding
> them.

Yeah, for max + kmemcg case, we eventually should do something similar
to the global case where we try to kick off async reclaim before we
hit the hard wall.  Ultimately, I think punting reclaims to workqueue
or return-path is a good idea anyway, so maybe it can be all part of
the same mechanism.  Given that the high limit is the primary control
mechanism on the default hierarchy, it should be fine for now.

Thanks.

-- 
tejun
