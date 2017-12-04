From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Tue, 5 Dec 2017 00:01:17 +0100
Message-ID: <20171204230117.GF20227@worktop.programming.kicks-ass.net>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=S8DtoOv9Im7UTnt4AwPTZrIFpNeeCAC3gKdeHZg/Ld4=; b=BAMuWN0PBCIkEFSkADsjW6Jvl
        RqaF42dMxNE2gObIgAoI9HGEMMuNKNH+TCcSnb8FMMj9DUHwgFdBnky0oCs7Ag+IYO6d/5k+yyyl9
        L1XjM8y0Ix1cXHl8bdnCV9OH3fWdL2gBmN5r0n/68BNU+ony8o93XdKl+f70hEBPO/y9BYJQJdAK9
        cNIPAiWhjFhMFtCgplOGzMkIjMvV0FLQ+/S5YktHpgtA5dHHyC5b6bMmI0ygfVw5CSnxf0orKxAHC
        lBLwdMJbL4sSe83ZFb+teuUxel7oy+BGY0Syj7deOJfbLkXSJcnx04BobND/kO91XrS+nyNFTrMuK
      
Content-Disposition: inline
In-Reply-To: <20171204225825.GP2421075-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

On Mon, Dec 04, 2017 at 02:58:25PM -0800, Tejun Heo wrote:
> Hello, again.
> 
> On Mon, Dec 04, 2017 at 12:22:19PM -0800, Tejun Heo wrote:
> > Hello,
> > 
> > On Mon, Dec 04, 2017 at 10:44:49AM +0530, Prateek Sood wrote:
> > > Any feedback/suggestion for this patch?
> > 
> > Sorry about the delay.  I'm a bit worried because it feels like we're
> > chasing a squirrel.  I'll think through the recent changes and this
> > one and get back to you.
> 
> Can you please take a look at the following pending commit?
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git/commit/?h=for-4.15-fixes&id=e8b3f8db7aad99fcc5234fc5b89984ff6620de3d
> 
> AFAICS, this should remove the circular dependency you originally
> reported.  I'll revert the two cpuset commits for now.

So I liked his patches in that we would be able to go back to
synchronous sched_domain building.
