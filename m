From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Split process across multiple schedulers?
Date: Wed, 16 Mar 2022 06:38:28 -1000
Message-ID: <YjIShE3mwRyNbO53@slm.duckdns.org>
References: <b5039be462e8492085b6638df2a761ca@saabgroup.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KJG9d+Kapo0GF7vwtS3fr/dHSRbCdMx6tPdBaWiajKU=;
        b=VnlKOwXeu1JbtWgHXg66/LRudlGjGdd4KwAhx7lqYYr5HZ0xPz5SaCNHNxthx3PODH
         plbWZ8WTaBn9EWpsQLJaYl/HJ3BDuZILWyi/rf70/f6UERAvjfHCTLaI18y7jv3P4hZ6
         nVBdsAyFDA5dC/k1DQyF/TEcDArR8pazwZiQgEH6UU9OgX+wrlsGHe/6OlsJn8rk5zMf
         2rn875loP+m4YQjUmX2h4azPligyPoTeG8Zw5+GtJ/7KmjH+Y74Y/1Afkf124kFRCC9B
         sXaAKfJJMA1EwW2MoJa2fSKc4D0uRnvQ7cJZCfzraMbEVRutC/KUIC4MuNCPl4jUydwY
         QwHQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b5039be462e8492085b6638df2a761ca-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Mon, Mar 14, 2022 at 03:19:56PM +0000, Olsson John wrote:
> Preferably for optimal performance you want to isolate the cores where the virtual core threads are running so nothing else interferes with them (besides kernel threads connected to IRQs that can't be moved from the isolated cores). The VMM is then running on another core that is not running a virtual core thread. CGroups is the preferred way of accomplishing this. :)

I have a basic question. cgroup provides new capabilities through its
ability to hierarchically organize workloads on the system and distributes
resources across the hierarchy. If all one wants to do is affining specific
threads to specific CPUs or changing some other attributes of them, there's
nothing extra that cgroup provides compared to using plain per-task
interface. Is there some other eason why cgroup is the preferred way here?

Thanks.

-- 
tejun
