From: David Rientjes <rientjes@google.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Thu, 21 Sep 2017 01:27:29 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709210125150.10026@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com> <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz> <20170913215607.GA19259@castle> <20170914134014.wqemev2kgychv7m5@dhcp22.suse.cz> <20170914160548.GA30441@castle>
 <20170915105826.hq5afcu2ij7hevb4@dhcp22.suse.cz> <20170915152301.GA29379@castle> <alpine.DEB.2.10.1709151249290.76069@chino.kir.corp.google.com> <20170915210807.GA5238@castle> <alpine.DEB.2.10.1709191351330.7458@chino.kir.corp.google.com>
 <20170920222403.GA4729@castle>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=QRmcdNEIwNigvo5HmrLZ94257y5WowjtV833ZUHl2Dw=;
        b=vFg8yv2o9jJDcs6Pl+5GXo+pONrtDyUOCpmEW24UdoIdWm7x5wG2rAgxFpOYx9s8Rh
         3SuCHOKu1907bMO8+S52sXeTbpyVKioJt+8fbvpx6pQR1asweYrAnCgiJsg+OUucqIdV
         N2Pw7J3oHB9/g9MFXZZ1qfeensVIov/Y+iyKfTvbDozOI4gDSU6GtwBi/g4GOBSqJ19s
         O5e/z2kaZXAto8i8T8gkfbjPBMoPaW+OkITakNMhc0/mr+li3JDRseqhyWGkIBN2lq2w
         ppyW14prg4acJjlT9Lu2luu0z5fIruaxcoy85KpQEGKtDxU+X5I6QWmOOfAoNCduNdN8
         rx/Q==
In-Reply-To: <20170920222403.GA4729@castle>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 20 Sep 2017, Roman Gushchin wrote:

> > It's actually much more complex because in our environment we'd need an 
> > "activity manager" with CAP_SYS_RESOURCE to control oom priorities of user 
> > subcontainers when today it need only be concerned with top-level memory 
> > cgroups.  Users can create their own hierarchies with their own oom 
> > priorities at will, it doesn't alter the selection heuristic for another 
> > other user running on the same system and gives them full control over the 
> > selection in their own subtree.  We shouldn't need to have a system-wide 
> > daemon with CAP_SYS_RESOURCE be required to manage subcontainers when 
> > nothing else requires it.  I believe it's also much easier to document: 
> > oom_priority is considered for all sibling cgroups at each level of the 
> > hierarchy and the cgroup with the lowest priority value gets iterated.
> 
> I do agree actually. System-wide OOM priorities make no sense.
> 
> Always compare sibling cgroups, either by priority or size, seems to be
> simple, clear and powerful enough for all reasonable use cases. Am I right,
> that it's exactly what you've used internally? This is a perfect confirmation,
> I believe.
> 

We've used it for at least four years, I added my Tested-by to your patch, 
we would convert to your implementation if it is merged upstream, and I 
would enthusiastically support your patch if you would integrate it back 
into your series.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
