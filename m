From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: punt high overage reclaim to
 return-to-userland path
Date: Fri, 28 Aug 2015 16:53:01 -0400
Message-ID: <20150828205301.GB11089@htj.dyndns.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-4-git-send-email-tj@kernel.org>
 <20150828171322.GC21463@dhcp22.suse.cz>
 <20150828204554.GM9610@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IRI9fUKWMrnSzFkv8xdi1DdhtjsYyU/1nEEdmKnNBsk=;
        b=W3eysdkd09outp9YGwDyTpBNincr0MstuNo1r5kjshcAInzjlmwDOGx+rhHkNX8Yif
         lekBEDpWTgf4VXUOMQicdiHiIboPfGn9LLn/ef+LWIejiUB0zKd9EgRHO6thOPceGFfl
         HA7cslvhiwCK3a/I+YH94KBkoGEN8h6ZUiQW0TkDKCzrJW0zKPqvmh8CH1LG3Ew1ujTz
         IA+HKzF1Lm3PV/sXwfz17CoWxYxCCexibqz7SS1u+q9IImVKUrnkkpnhLhfk3AbYkzjK
         gQxM20hY9ICuP4KfpSQTdH1Wl5baRyU70msF1Wz91rz685DAZOjjCn2TycwwyLEhpJIr
         +bvA==
Content-Disposition: inline
In-Reply-To: <20150828204554.GM9610@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Vladmir.

On Fri, Aug 28, 2015 at 11:45:54PM +0300, Vladimir Davydov wrote:
> Actually, memory.high by itself *is* the protection against GFP_NOWAIT
> allocations, similarly to zone watermarks. W/o it we would have no other
> choice but fail a GFP_NOWAIT allocation on hitting memory.max. One
> should just set it so that
> 
>   memory.max - memory.high > [max sum size of !__GFP_WAIT allocations
>                               that can normally occur in a row]

While this would be true in many cases, I don't think this is the
intention of the two knobs and the space between high and max can be
filled up by anything which can't be reclaimed - e.g. too many dirty /
writeback pages on a slow device or memlocked pages.  If it were
really the buffer for GFP_NOWAIT, there's no reason to even make it a
separate knob and we *may* change how over-high reclaim behaves in the
future, so let's please not dig ourselves into something too specific.

> That being said, currently I don't see any point in making memory.high
> !__GFP_WAIT-safe.

Yeah, as long as the blow up can't be triggered consistently, it
should be fine.

Thanks.

-- 
tejun
