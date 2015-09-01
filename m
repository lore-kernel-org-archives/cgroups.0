From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] memcg: always enable kmemcg on the default hierarchy
Date: Tue, 1 Sep 2015 14:51:57 -0400
Message-ID: <20150901185157.GD18956@htj.dyndns.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-5-git-send-email-tj@kernel.org>
 <20150828164918.GJ9610@esperanza>
 <20150828171438.GD21463@dhcp22.suse.cz>
 <20150828174140.GN26785@mtj.duckdns.org>
 <20150901124459.GC8810@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NN+VANBVAas+oL3yC4maMvD2znwijVE05jYKxUC3/EI=;
        b=t4SH4VgG1RRFockbYW9tnt3T4Ke+FAZitw8k/o+NAok+uFE+1jYWZoDZ8jHxMe73sT
         ZnbWtYzCo1gkAq7Af5U5neHa6KONWLsF9mzU2Jr1vUr7cUG2rZ8z96jVR5TMaMTJV6zN
         u8i4h4oS14NeAGQUCfQQTLNceBZAMz8SeTPQ4ZYEoItxiXO3CSgQieHOYs6R9jbGNu6K
         NyzsTonentSV5/EOYL/CYfjytcWaqddKYP0yL0O6zxFfIYH1oquGOV10winKFPfK4BNC
         VwycKjoYEJlmh5YeaoPl8en06RCJrdc8fJLj0RVtjBLppsZfANnLZLgYvPou++nRxftd
         whWw==
Content-Disposition: inline
In-Reply-To: <20150901124459.GC8810-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Tue, Sep 01, 2015 at 02:44:59PM +0200, Michal Hocko wrote:
> The runtime overhead is not negligible and I do not see why everybody
> should be paying that price by default. I can definitely see the reason why
> somebody would want to enable the kmem accounting but many users will
> probably never care because the kernel footprint would be in the noise
> wrt. user memory.

We said the same thing about hierarchy support.  Sure, it's not the
same but I think it's wiser to keep the architectural decisions at a
higher level.  I don't think kmem overhead is that high but if this
actually is a problem we'd need a per-cgroup knob anyway.

> > We wanna put all memory consumptions under the same roof by default.
> 
> But I am not sure we will ever achieve this. E.g. hugetlb memory is way
> too different to be under the same charging by default IMO. Also all
> the random drivers calling into the page allocator directly in the user
> context would need to charge explicitly.

Oh I meant the big ones.  I don't think we'll achieve 100% coverage
either but even just catching the major ones, kmem and tcp socket
buffers, should remove most ambiguities around memory consumption.

Thanks.

-- 
tejun
