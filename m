From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: Split process across multiple schedulers?
Date: Mon, 14 Mar 2022 17:43:33 +0100
Message-ID: <20220314164332.GA20424@blackbody.suse.cz>
References: <b5039be462e8492085b6638df2a761ca@saabgroup.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647276214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U8aU7ATJhIHHpbiq1kzf5ExUEOuGSR5q8FMA3efJl9M=;
        b=UEr/ewUMeqbiMGFJRQ4009Df5u0krJ3RVo5m9R5yvzdo/MnFsuOSsUDcnHMnjZ/HSubxAH
        YP5vU5U4XDnG5CSdufFH4QcBxVNUHYTbY+v99/hd2sFMb+XpiylFvDmkHaveyfRKiKqByY
        sFc4fxtbqUoUU46itK8l6myhdeixj5s=
Content-Disposition: inline
In-Reply-To: <b5039be462e8492085b6638df2a761ca-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello.

On Mon, Mar 14, 2022 at 03:19:56PM +0000, Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org> wrote:
> I have tried reading the documentation for CGroups V1 and V2 and it
> seems that there is one usecase that we are interested in that *is*
> supported by CGroups V1 but not by CGroups V2.

Are you missing CONFIG_RT_GROUP_SCHED and v1 cpu controller's
cpu.rt_{runtime,period}_us? (Just asking, you didn't mention this
explicitly in your e-mail but it sounds so and it's a thing that's
indeed missing in v2.)

> My understanding of CGroups V1 is that it is possible to have one
> scheduler associated  there are use cases where you might want to have
> one kind of scheduler for the VMM process (for instance CFS) and
> another scheduler for the virtual core threads (for instance FIFO).

sched_setscheduler(2) applies to threads regardless of cgroup
membership, there's no change between v1 and v2.

(Without CONFIG_RT_GROUP_SCHED all RT threads are effectively in the
root cgroup.)

> My conclusion after reading the documentation for CGroups V2 is that
> the above scenario is no longer possible to do. Or have I
> misunderstood something here?

You may need to enable threaded mode on v2 (see cgroup.type) to
manipulate with individual threads across cgroups. (E.g. if you want to
use cpuset controller to pin/restrict individual threads.)

Regards,
Michal
