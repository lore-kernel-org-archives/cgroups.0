From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] mm/memcg: refine
 mem_cgroup_threshold_ary->current_threshold calculation
Date: Wed, 12 Jan 2022 00:25:51 +0000
Message-ID: <20220112002551.sksmoril2nwuddtu@master>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
 <20220111010302.8864-4-richard.weiyang@gmail.com>
 <Yd3LLalWzPy17PmR@carbon.dhcp.thefacebook.com>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MBSCVEXhAMvxGQvNiGRyMSUYqls1w/ZtyRRzB2dpPmI=;
        b=QI+s8v0B1JsKNZCuCjjyuOlaCkg7jITbixgszmCrLpMZfPFYpHcAX1zqszo8unsiV1
         jsXZXHhaNIzmLJ+roOqKNxX9oQd7UZWzN866zq13FqgZilLSTkSBnUEqo73zTKiEjRq/
         CnJobd7MTSnyH8IU9TEWr9ISjl5BvrRRYYjXIqXt7qqpLBGrbQZOtcq4IhaJ5GaKu/5k
         J2ps1fNM5z+9O3Q95GSfTF4OJbsUEa8X4bFjF8s5n4xExrLJPbnuPLwqlax+TzaxKY1d
         6mmOOny0tBQfGXQv9bn8dajnX2FKEuJ8kTbmbN09UEcwk9DHm8SFfRfEgLQbICUGbL5Q
         GtBQ==
Content-Disposition: inline
In-Reply-To: <Yd3LLalWzPy17PmR-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Jan 11, 2022 at 10:23:41AM -0800, Roman Gushchin wrote:
>On Tue, Jan 11, 2022 at 01:03:02AM +0000, Wei Yang wrote:
>> mem_cgroup_threshold_ary->current_threshold points to the last entry
>> who's threshold is less or equal to usage.
>> 
>> Instead of iterating entries to get the correct index, we can leverage
>> primary->current_threshold to get it. If the threshold added is less or
>> equal to usage, current_threshold should increase by one. Otherwise, it
>> doesn't change.
>
>How big is usually an array of thresholds? If it's not huge, likely
>any savings won't be really noticeable (it's not a hot path and there
>is an rc_synchronize() below).

Usually the size is small I think.

>
>So I agree with Michal that a better justification is really needed.

Yep.

>
>Thanks!

-- 
Wei Yang
Help you, Help me
