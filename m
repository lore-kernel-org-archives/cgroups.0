From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Wed, 26 Sep 2012 12:34:17 -0700
Message-ID: <20120926193417.GJ12544@google.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-5-git-send-email-glommer@parallels.com>
 <20120926140347.GD15801@dhcp22.suse.cz>
 <20120926163648.GO16296@google.com>
 <50633D24.6020002@parallels.com>
 <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com>
 <50634105.8060302@parallels.com>
 <20120926180124.GA12544@google.com>
 <50634FC9.4090609@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ogrZzy+yM1Kasos3/MLTteG7DeUQoSXG9YHpuiN3D9o=;
        b=M3vWsC6Kyxn3YdfRkM8ygaAkD9aUk38aCUnl/K/a48U7iOMdO/c8F7t6hR8gREMJ1c
         MG4GDJ3gxW5dvpYBfYOzFZ1KxtU15eY63tBacdlaM+ZFlrRFWebpwJSAHQNm4PqJBADl
         WFrH7gv2ZHs5ZQl4aYsd14yoozVQ9+DOnjXsUOH+5TCbJazakodmjFobHP77DuzFmNIw
         k5qsekC4FdK2rO902KcJ5rOZIYPLZB1GqxA9Lyf7XSsuK2ivqB1bxWnbXDfHZDVsHzGz
         Q3HWA4I9AFmpeAT3R/vMzdXlk9wqediDKZXAW9GlwTFbcCCzyAXkkUM2gbqgAnBCkYP2
         k5yw==
Content-Disposition: inline
In-Reply-To: <50634FC9.4090609-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello,

On Wed, Sep 26, 2012 at 10:56:09PM +0400, Glauber Costa wrote:
> For me, it is the other way around: it makes perfect sense to have a
> per-subtree selection of features where it doesn't hurt us, provided it
> is hierarchical. For the mere fact that not every application is
> interested in this (Michal is the one that is being so far more vocal
> about this not being needed in some use cases), and it is perfectly
> valid to imagine such applications would coexist.
> 
> So given the flexibility it brings, the real question is, as I said,
> backwards: what is it necessary to make it a global switch ?

Because it hurts my head and it's better to keep things simple.  We're
planning to retire .use_hierarhcy in sub hierarchies and I'd really
like to prevent another fiasco like that unless there absolutely is no
way around it.  Flexibility where necessary is fine but let's please
try our best to avoid over-designing things.  We've been far too good
at getting lost in flexbility maze.  Michal, care to chime in?

Thanks.

-- 
tejun
