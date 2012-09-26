From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Wed, 26 Sep 2012 10:44:32 -0700
Message-ID: <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
	<1347977050-29476-5-git-send-email-glommer@parallels.com>
	<20120926140347.GD15801@dhcp22.suse.cz>
	<20120926163648.GO16296@google.com>
	<50633D24.6020002@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=O5reV53SmVtqLXpGQ5BgqUQMeg3ES2sXnB8h9GTqv44=;
        b=J44F6OSmZTK0GIo3mw21JwNm5L4k0LB0P3SsMt+suTPmpYWB5K0HtMZ4KH2uxb9GfH
         2DCvVLQtkujNfGfOjaa+CbWad+b79S8aGLrmasCBgE0OkpiHHAKjKuhgrjTQhJj2oaMP
         bdcVgEHvFu5GHe6PeXBu3Qq4GazbTdi5mGUZIzVb6pwwPoNnMR8F2MtddER59JxJzXDN
         ad+9eK1c1I3MBfNr/DsATgFRPJsHdYxigHpI8vHT4DKfr24+z3Q9h/yVBxStLEATY2LQ
         Q1LclSrx+K+qG4ypfp/LZ0A0Smb2BTXr9llNDiVMvGb2xJEXWiHDU42io4KCXyvz8zVA
         623Q==
In-Reply-To: <50633D24.6020002-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Glauber.

On Wed, Sep 26, 2012 at 10:36 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> This was discussed multiple times. Our interest is to preserve existing
> deployed setup, that were tuned in a world where kmem didn't exist.
> Because we also feed kmem to the user counter, this may very well
> disrupt their setup.

So, that can be served by .kmem_accounted at root, no?

> User memory, unlike kernel memory, may very well be totally in control
> of the userspace application, so it is not unreasonable to believe that
> extra pages appearing in a new kernel version may break them.
>
> It is actually a much worse compatibility problem than flipping
> hierarchy, in comparison

Again, what's wrong with one switch at the root?

Thanks.

-- 
tejun
