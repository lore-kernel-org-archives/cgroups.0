From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] cgroup: get rid of populate for memcg
Date: Mon, 9 Apr 2012 11:13:31 -0700
Message-ID: <20120409181331.GD7522@google.com>
References: <1333728250-14248-1-git-send-email-glommer@parallels.com>
 <1333728250-14248-3-git-send-email-glommer@parallels.com>
 <20120409174042.GA7522@google.com>
 <4F83218E.7060502@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=EDgT8Ecwy47Ls0hMwAdyxijibrnzbUeyMk3eoDvxrys=;
        b=WMo+iVkuCXIcSoHARJz5FNJwWBgwTTVqeRDMLye5ooUa0iuMDNurmwuSF4YPqBrFKA
         7RTH0GhfhZ+/qcxqyEW66wgI06MowCwcniGgwAN6Og26SZKzsigPFGB0vrBV4AKBvmPz
         bHl2uVNkVLO5s2xY93kyteKm74PgqgRRVjp2queBRC1McBpx5/VgfGMtGJIFG9iwauNW
         BxcXY+DN1r5t5xVxej/DqfThOpHsMLm6xHrXgbpf7ONtOlTilkOcDyhNWopZc17ZOd05
         T5/37xyWyJTnsjyOWAK58FHrV1VRmV9sF7g7lIkaKV16yK/RPD+5qXzoRHhZHEPWQkWe
         vmTA==
Content-Disposition: inline
In-Reply-To: <4F83218E.7060502-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello,

On Mon, Apr 09, 2012 at 02:51:10PM -0300, Glauber Costa wrote:
> On 04/09/2012 02:40 PM, Tejun Heo wrote:
> >which BTW seems incorrect even on its
> >own - unmounting and mounting again would probably make the same
> >notifier registered multiple times corrupting notification chain, and
> >ref inc on the parent.
> 
> 
> For the maintainers: Should I fix those in a new submission, or do
> you intend to do it yourselves?
> 
> the refcnt dropping should probably be done in my patch, it is a new
> leak (sorry). The hotplug notifier, as tejun pointed, was already
> there.
> 
> It seems simple enough to fix, so if you guys want, I can bundle it in
> a new submission.

I think it would be best to create a separate patch which is routed
through the usual memcg path (I suppose memcg patches go through
-mm?).

Thanks.

-- 
tejun
