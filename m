From: Udayan Bapat <uvbapat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Limiting CPU resources of a cgroup (how do I) HELP REQUESTED
Date: Thu, 9 Aug 2012 09:11:56 -0400
Message-ID: <ECF03057-612C-4544-8174-1F6FF0E9FAB7@gmail.com>
References: <CACivvv0G3CspFnFud569vgdh=_2sofb4P3f2sfdFRuu2XSvRaQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=references:in-reply-to:mime-version:content-transfer-encoding
         :content-type:message-id:cc:x-mailer:from:subject:date:to;
        bh=hmPpTs1i+CpGbgf46iOINIDCgUyXU7uj9NYA3smyXyY=;
        b=Wgkkr2SJ4i1dPjTrQJvyoWfA1LViGDmloWTi7nrErrbXcszTdIEqNt9mAidHMzrnyk
         hubaFsopNyxnsOr5/hUk7ub8uLk2j+sKTWAmL4918rRaFeF6eI1i4icylE8oUUMdm/bU
         fqw0lN7Zd68Y+pkgdm5PIHumV1qyfaJtV1jDQ1HtAYxxOtxbPuWZZ0mWpGIHkVmrcnEk
         avwRCoEcU0oE6zC8yTjW+uJKFa2aJXLliJ3zR/HqSKHDc5wQVrLg2rj8OWDsQaZIKN3a
         jAKrqkNBSRw/zkwC8JQ1XIi9ksv8s21krICgSbdhWznC5MBcEAthWZWTdn3XUSqJ/5JU
         /rBg==
In-Reply-To: <CACivvv0G3CspFnFud569vgdh=_2sofb4P3f2sfdFRuu2XSvRaQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vecu BOSSEUR <vecu.bosseur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Unless, I am mistaken cgroup does not provide max guarantee. It can be used to provide min guarantee by setting CPU.shares value.

Besides, what is the use case where you would want to limit the usage even when other threads/cores are idle? Wouldn't you want to give 100 percent to finish your task earlier than giving say 30 percent only?


On Aug 8, 2012, at 8:24 AM, Vecu BOSSEUR <vecu.bosseur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Dear Friends or Foes ;-)
> 
> 
> It is quite some time now that I first tried to find an adequate
> solution to my problem; none managed to get me right yet :=-(
> 
> Basically, I would like to limit CPU resource usage (i.e. ~= time
> share) allocated to a said cgroup to let's say 30% of the machine
> processing power, or 30 % of time.
> ( SMP and HyperThreading technologies will change the interpretation
> of that goal; regardless, please read on. )
> 
> I am in the very need to throttle some cgroup's CPU usage, regardless
> the overall machine CPU utilisation. I mean that I need to cap the
> processing power dedicated and allowed to some cgroup, whether the
> CPU(s) is(are) otherwise IDLE or BUSY (with respect to other tasks or
> groups).
> 
> Any hint on how to accomplish this?
> 
> All that I happend to do was to create a renice-boosted daemon that
> alternately froze then unfroze the said cgroup (using a calculated
> time ratio between running/frozen states) to keep the cgroup's CPU
> usage under control.
> 
> You can ea
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
