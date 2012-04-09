From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] cgroup: get rid of populate for memcg
Date: Mon, 9 Apr 2012 13:39:11 -0700
Message-ID: <20120409203911.GE7522@google.com>
References: <1333728250-14248-1-git-send-email-glommer@parallels.com>
 <1333728250-14248-3-git-send-email-glommer@parallels.com>
 <20120409174042.GA7522@google.com>
 <4F83218E.7060502@parallels.com>
 <20120409181331.GD7522@google.com>
 <4F83442C.8040006@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=AuEHIU3BA/uMBkkloufR/rpBquX1tPnZhuU/TNqZ9BE=;
        b=ChrbqJ6pW5n4Yxigbv5xVojmlwvceU4KkR3z9bv2L13sL2wA3ICNCeQWaBYRHUn8U3
         T8SrgSd9YEcBcvewVfIXukuPtnudTCPhgYqXell/nd/o3PP1SDZShUdtIqASnfGwpnUQ
         AuRci3WB7SPgeKk4ponDfiYpkR67xkg2oOkcY3eD4kATs0O0336l2MPam+rET16jb1nR
         s1xc0g4tHVn0gvM5SKake7CVcnfX2GT9zaXJgtIXFUCdo/YtpwuShQY2wcNbzeROrkyI
         QF12t9QvLyrKl6TpYWOzn0NiL58oOuxrx/5em4JVotxUA11PJuPqkElAgAtHgvZEhUY3
         DrJQ==
Content-Disposition: inline
In-Reply-To: <4F83442C.8040006-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello, Glauber.

On Mon, Apr 09, 2012 at 05:18:52PM -0300, Glauber Costa wrote:
> After debugging this a bit, I found most of it not to be a problem.
> Unless I am *very* wrong (and I both read and tested stuff), mount
> operations do not recreate the root cgroup. So stuff like the hotcpu
> notifier, etc, won't be a problem.

Ooh, right, root css is created during subsys init.  Please note that
the kernel will panic on subsys init failure (hmm....).

> Now, you are definitely correct in pointing out that we start
> leaking stuff now - my bad.
> 
> But I guess I can then bundle it in a new submission, after
> shuffling around stuff a bit. It is really not a bug now, so no
> reason to route it separately.

Sure, just make it a separate patch.  As long as memcg ppl are fine
with it, I can route the patches together.

Thanks.

-- 
tejun
