From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4.4-rc7] sched: isolate task_struct bitfields according
 to synchronization domains
Date: Wed, 30 Dec 2015 15:41:40 -0500
Message-ID: <20151230204140.GA17398@htj.duckdns.org>
References: <55FEC685.5010404@oracle.com>
 <20150921200141.GH13263@mtj.duckdns.org>
 <20151125144354.GB17308@twins.programming.kicks-ass.net>
 <20151125150207.GM11639@twins.programming.kicks-ass.net>
 <CAPAsAGwa9-7UBUnhysfek3kyWKMgaUJRwtDPEqas1rKwkeTtoA@mail.gmail.com>
 <20151125174449.GD17308@twins.programming.kicks-ass.net>
 <20151211162554.GS30240@mtj.duckdns.org>
 <20151215192245.GK6357@twins.programming.kicks-ass.net>
 <20151230092337.GD3873@htj.duckdns.org>
 <CA+55aFx0WxoUPrOPaq3HxM+YUQQ0DPV-c3f8kE1ec7agERb_Lg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6pR0vetf2W7b8CrAaTpPhJ2D8MoCptySxjL9iTO6dj8=;
        b=aD5J1oWSuzPYEb75c4gUetLP//gTDbU72WuHv/7/RQm3l41+v+chMQxd4v96yLu+x3
         jwuc+bBcutTD3BuXSNEyabBiLzj2+jRwxGg7ltPTrZ/ZmB0s3nepdWlwo8M/w6F3WnBE
         7p/sSCfhjWQlqfLxdpFwKjdC26QbfC2L9ERZ8HLpDai4Q7Ptllf73fQOQH+d2SMfV0ox
         BFV4RpYROCdPt2SR+Be52yAd2usPVoaGN1t5F/4SttoK0FemmxZnmAudBk9NrRwwEiwz
         /GG0kVTfFBCsjMMkmLsz6e4ZgcQt2XlcRsSEfiBpf+tHlbxDbdA8vIYu9nQvrrzLVH7S
         Ymww==
Content-Disposition: inline
In-Reply-To: <CA+55aFx0WxoUPrOPaq3HxM+YUQQ0DPV-c3f8kE1ec7agERb_Lg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hello, Linus.

On Wed, Dec 30, 2015 at 12:10:12PM -0800, Linus Torvalds wrote:
> On Wed, Dec 30, 2015 at 1:23 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > Peter, I took the patch and changed the bitfields to ulong.
> 
> I wouldn't expect the unsigned long part to matter, except for the
> forced split with

Right, I was thinking alpha was doing rmw's for things smaller than
64bit.  That's 32bit, not 64.

>    unsigned long :0;
> 
> itself.
> 
> Also, quite frankly, since this is basically very close to other
> fields that are *not* unsigned longs, I'd really prefer to not
> unnecessarily use a 64-bit field for three bits each.
> 
> So why not just do it with plain unsigned "int", and then maybe just
> intersperse them with the other int-sized fields in that neighborhood.
>
> I'm also wondering if we shouldn't just put the scheduler bits in the
> "atomic_flags" thing instead?

Sure.

-- 
tejun
