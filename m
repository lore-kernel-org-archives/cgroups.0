From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 06/13] memcg: kmem controller infrastructure
Date: Thu, 4 Oct 2012 07:11:51 +0900
Message-ID: <20121003221151.GC19248@localhost>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-7-git-send-email-glommer@parallels.com>
 <20120926155108.GE15801@dhcp22.suse.cz>
 <5064392D.5040707@parallels.com>
 <20120927134432.GE29104@dhcp22.suse.cz>
 <50658B3B.9020303@parallels.com>
 <20120930082542.GH10383@mtj.dyndns.org>
 <5069542C.2020103@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pfJmNvHyj/33G1wVszXazVVE3smc7iz9yA/WyZfnP3g=;
        b=lzEbvkHng0fpES63WypT4CgMD7HcixhfEGa5+CB7kIYZThlJUWKsUpKJ4sd6nNRajZ
         HOlf0B7gbQimoB1xmrDj6QuobZqxZIQe2czrdL9GT3nqpPRGuY9jp/tShcBQhuYaQjnk
         7TwQHcGaItHUglguZonBv2Zt2RathWuXREVc8g5xhKaWGeM2zQ2LsVmy+2H1HWJzWMT6
         mLRmGsVqI44Nw3lmb03fz27xEAjiMTBAhvXncHsh3zdEZ/yG6hDiCRKrxAWjqBl384+W
         Rgj93fx6LB6rswEsW4vP73J/x7853h7HWkbRDBb7Y0Itf0qcZ+UrMSq68RfPYae7FHaq
         SqEQ==
Content-Disposition: inline
In-Reply-To: <5069542C.2020103-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Glauber.

Sorry about late replies.  I'be been traveling for the Korean
thanksgiving holidays.

On Mon, Oct 01, 2012 at 12:28:28PM +0400, Glauber Costa wrote:
> > That synchronous ref draining is going away.  Maybe we can do that
> > before kmemcg?  Michal, do you have some timeframe on mind?
> 
> Since you said yourself in other points in this thread that you are fine
> with some page references outliving the cgroup in the case of slab, this
> is a situation that comes with the code, not a situation that was
> incidentally there, and we're making use of.

Hmmm?  Not sure what you're trying to say but I wanted to say that
this should be okay once the scheduled memcg pre_destroy change
happens and nudge Michal once more.

Thanks.

-- 
tejun
