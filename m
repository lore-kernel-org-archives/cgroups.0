From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Wed, 27 Mar 2013 09:21:02 -0700
Message-ID: <CAOS58YPsrZNU9qDeMgJG3-Hkn0cBaigz16eTS5M57G95E8fxUQ@mail.gmail.com>
References: <1364373399-17397-1-git-send-email-mhocko@suse.cz>
	<20130327161527.GA7395@htj.dyndns.org>
	<20130327161905.GN16579@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=N69HygzxqALHb023EMnAEY9PoAFHaUiVcsXzn9akiFA=;
        b=UFH9ZXCw8kHorxzU7pxbj0x5/Q8LcCdvwRV3AAiet2E49qV1uUjc14PUlyk2ENfcYn
         5XtHRQ/A7ttXkwJ3Sw9ECPeccpK5Q/qIWCKQuvsW/kAMDDGeHUTPTpUEVJ931/ygobFX
         B46xMLK+GOGUs3kitypglqXca2mYNTdmYnAdl82RZAmWQQWaymJBBVjMLNTHJoP/3n1Z
         riQ+9fictbNFtqKxG5doYA3Nxm6Obd+eJa8G4M+CllKEIes/J66+RNEoW9EDe3KhFuvn
         2U7C7ctjjCI/iMkG+GohUU5cuEhDOj5fcVL+MYB8p1OW9LsgcWM+yLr+Vt/T8gfmTPEg
         7/8Q==
In-Reply-To: <20130327161905.GN16579-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 27, 2013 at 9:19 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>> Maybe the name could signify it's part of memcg?
>
> kmem_ prefix is used for all CONFIG_MEMCG_KMEM functions. I understand
> it clashes with sl?b naming but this is out of scope of this patch IMO.

Oh, it's not using kmemcg? I see. Maybe we can rename later.

Thanks.

-- 
tejun
