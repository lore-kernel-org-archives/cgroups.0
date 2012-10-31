From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] cgroup: kill cgroup_subsys->__DEPRECATED_clear_css_refs
Date: Wed, 31 Oct 2012 13:14:07 -0700
Message-ID: <CAOS58YOHjLyKFeah+h+qOrAWvfi1O5eL7m-AMbqAdcP=EOFb6g@mail.gmail.com>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
	<1351712650-23709-2-git-send-email-tj@kernel.org>
	<20121031201227.GF1271@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=Ic3qwp/ZBzBpaCEpWKTt1thkYJan3Rlbeok3v1v1QQE=;
        b=l5oRSX3I369QV5V75uUghjOWOBLxjfEHmTQWUd4WWCkkCtqfyG/zYwfNtucYSZS7sJ
         CZI8RY874Ge4swKuZ7YS94O5uX2N9X+Zi7M60ZzgrWIIC6dzU6bc6Hprf0QYDg8RcZ7D
         xo4WPRZuLaRHL29VOJ/S8iajRHdUMMatkjVEbMG3HjK3zAzW4I1plPI5a0if/7uEUdM2
         WeuB6aDIHjOqvghHV1Xj5VbtkyN7yBLfgvV5N64bL9diVsT6N6bgyvz8VaFTe2pxU4lM
         MRh7tRopCeNpdVAV/NdFMt2kEsZxo0bI1uJCnupacH6qQ1oeMJMOeeK0J/oKnKh0YZy9
         KIHA==
In-Reply-To: <20121031201227.GF1271-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, Michal.

On Wed, Oct 31, 2012 at 1:12 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> And sorry for being to annoying about this WARN_ON_ONCE but I really
> don't see any reason for it. pre_destroy can still happen and now it is
> even reduced to a reasonable condition (somebody shown up). So I would
> put it out of way as it doesn't give us anything and as I've already
> mentioned one can trigger it really easily.

It was there before and goes away in several commits.  I have to
explain all that to remove it in this patch.  Why do that when the
whole thing is just gonna disappear anyway?

Thanks.

-- 
tejun
