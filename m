From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Wed, 26 Sep 2012 12:56:48 -0700
Message-ID: <20120926195648.GA20342@google.com>
References: <1347977050-29476-5-git-send-email-glommer@parallels.com>
 <20120926140347.GD15801@dhcp22.suse.cz>
 <20120926163648.GO16296@google.com>
 <50633D24.6020002@parallels.com>
 <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com>
 <50634105.8060302@parallels.com>
 <20120926180124.GA12544@google.com>
 <50634FC9.4090609@parallels.com>
 <20120926193417.GJ12544@google.com>
 <50635B9D.8020205@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=3cNed9brM9wypLgVjP2C4XN7c133g3n/BQ3sTWx/zg8=;
        b=IVg+Dg0EsWHASxcJiXTOqiUlpVZX2Be3ruJFQMB82cIpe4HQJr35zWY86YNAG6KoQU
         +GXT7GS099gFQ3kHio+BDT6HmLKTW20Y74YYyCRU1yExAy+5o0PmV87RrCSmoLstBoHN
         +ee3IYK9rDL3d0D2nbsTyIqi55PrbdbREQBeuRCpkoY1qJfv9Td/XEXITNkRZXPCN3sq
         KdaZqhAWhv14ULZM0b/N5LzkLOMNySEStUVpF8QY5x3CgLjzCqOBcUUPT5K4LpWn0E75
         sB8VlOu0TPXJrTvxYJtXNnveOvokahs4sm8B5Z0eTkOKkThNSvWCRFpQkyTvZ0b0uNmT
         5npA==
Content-Disposition: inline
In-Reply-To: <50635B9D.8020205-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello,

On Wed, Sep 26, 2012 at 11:46:37PM +0400, Glauber Costa wrote:
> Besides not being part of cgroup core, and respecting very much both
> cgroups' and basic sanity properties, kmem is an actual feature that
> some people want, and some people don't. There is no reason to believe
> that applications that want will live in the same environment with ones
> that don't want.

I don't know.  It definitely is less crazy than .use_hierarchy but I
wouldn't say it's an inherently different thing.  I mean, what does it
even mean to have u+k limit on one subtree and not on another branch?
And we worry about things like what if parent doesn't enable it but
its chlidren do.

This is a feature which adds complexity.  If the feature is necessary
and justified, sure.  If not, let's please not and let's err on the
side of conservativeness.  We can always add it later but the other
direction is much harder.

Thanks.

-- 
tejun
