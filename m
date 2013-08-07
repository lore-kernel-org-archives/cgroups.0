From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] memcg: Limit the number of events registered on
 oom_control
Date: Wed, 7 Aug 2013 09:08:36 -0400
Message-ID: <20130807130836.GB27006@htj.dyndns.org>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <1375874907-22013-2-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pEpjJBjFzdyDpEVNJWN2EjM2fLEjpK6zwzn15D45tpE=;
        b=nkc1C+9ijpWj111dxtMNvZIBkMZ7e6Cert3DHpkQjNEhFIYTHHRwIAQqjeZILrzmvO
         vlA+bXY2nH5lXysGY0ZxwioXueSfKvuJyaqbNXsF/1sOgHNkivCULfMVDA9F6/xfWPv/
         9LoyYpxmy+YL92oRLaEGydGinLdcbC9R0SZfvhZ/gHr2Zn6ELwfa+MthsgPJEPMn1V9c
         mDghl1jEbcV1xQGDnZU3F/cOSCYJlNUGPoxSJXxBqRHTVTfF8b/sVdYsDqb55/4oaPSC
         E+AYCSu23p8PZK+9D6FZIdDMo8TONjKjJWYQRHObvJ64dnkceXxGR1h+keawcGd0j96v
         +59A==
Content-Disposition: inline
In-Reply-To: <1375874907-22013-2-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Hello, Michal.

On Wed, Aug 07, 2013 at 01:28:26PM +0200, Michal Hocko wrote:
> There is no limit for the maximum number of oom_control events
> registered per memcg. This might lead to an user triggered memory
> depletion if a regular user is allowed to register events.
> 
> Let's be more strict and cap the number of events that might be
> registered. MAX_OOM_NOTIFY_EVENTS value is more or less random. The
> expectation is that it should be high enough to cover reasonable
> usecases while not too high to allow excessive resources consumption.
> 1024 events consume something like 24KB which shouldn't be a big deal
> and it should be good enough (even 1024 oom notification events sounds
> crazy).

I think putting restriction on usage_event makes sense as that builds
a shared contiguous table from all events which can't be attributed
correctly and makes it easy to trigger allocation failures due to
large order allocation but is this necessary for oom and vmpressure,
both of which allocate only for the listening task?  It isn't
different from listening from epoll, for example.  If there needs to
be kernel memory limit, shouldn't that be handled by kmemcg?

Thanks.

-- 
tejun
