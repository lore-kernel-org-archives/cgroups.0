From: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup-v1: Grant CAP_SYS_NICE holders permission to
 move tasks between cgroups
Date: Thu, 17 Jun 2021 13:01:54 +0100
Message-ID: <YMs5ssb50B208Aad@dell>
References: <20210617090941.340135-1-lee.jones@linaro.org>
 <YMs08Ij8PZ/gemLL@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PZ6ISBSnRrzVuSGvUd0b/8GChX0lbxx7dZ00sY7kWSQ=;
        b=ClmgFWz8+2HypoYvC+r5XNcMSnn1uiYnYp9+/m/RvaoK11RlmLCbs34RQTbCbb6cbu
         2eQf+wKIYAocO/nXeeV61afl8dulo+jZrID6MlWbalOUB/oTE2h8iG5eveHIGujPTPnV
         UtX8AHiXIb60iJU58NIuKJ4AO8EKGXwWL1+nETQGyRH8W9j0M6BYHxOUXiMGXyowzkTB
         d3b5FzexoMOIxC1W0zO5Q7jzFPxPvd+M8KwrFeCNr4JRxojO8hfd+gzUJ50cqvy53OLK
         hvP0OMPF0pgl5d7kNwZWWufubnFSrBBGqLzs7Hazj6PBc3uXj1F19829cgHCp+GZLipT
         eZXw==
Content-Disposition: inline
In-Reply-To: <YMs08Ij8PZ/gemLL-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

Thanks for your reply.

On Thu, 17 Jun 2021, Tejun Heo wrote:
> On Thu, Jun 17, 2021 at 10:09:41AM +0100, Lee Jones wrote:
> > It should be possible for processes with CAP_SYS_NICE capabilities
> > (privileges) to move lower priority tasks within the same namespace to
> > different cgroups.
> 
> I'm not sure that "should" is justified that easily given that cgroup can
> affect things like device access permissions and basic system organization.

The latter part of that sentence does provide some additional caveats.

> > One extremely common example of this is Android's 'system_server',
> > which moves processes around to different cgroups/cpusets, but should
> > not require any other root privileges.
> 
> Why is this being brought up now after all the years?

This has been discussed before?

I didn't find any evidence of that on the lists.

> Isn't android moving onto cgroup2 anyway?

That I would have to check.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
