From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: introduce entrance for root_mem_cgroup's current
Date: Fri, 3 Feb 2023 09:58:56 +0100
Message-ID: <Y9zM0GbmfKdvy3bL@dhcp22.suse.cz>
References: <1675312377-4782-1-git-send-email-zhaoyang.huang@unisoc.com>
 <Y9tz+0J9fw+Z+O+O@dhcp22.suse.cz>
 <CALvZod5E0s9Vu3wq-Fuvs9z=ViMADn3aNL0f56ELGmFzxKCtkg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675414736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v8S6zraZDmm8NfG5YlmoDj55zR5f/MJguLBUkCuqdFU=;
        b=nMUifxEzJUnVuWEuDfCB40VhS3vpxS+f9DwWxSfS6K37MuTVadnC6RU2yr0fLSldcoR7e1
        I4kGUT2Yfchr4CA4oDRoV83lCZ2soHeDICcCHoYEzAVx2iDl4VPPfborkCE9UjZprEOlFJ
        18ULHKXGs/z2b8zS8YhQ9mzDg6KNaXA=
Content-Disposition: inline
In-Reply-To: <CALvZod5E0s9Vu3wq-Fuvs9z=ViMADn3aNL0f56ELGmFzxKCtkg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org

On Thu 02-02-23 10:24:08, Shakeel Butt wrote:
> On Thu, Feb 2, 2023 at 12:27 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Thu 02-02-23 12:32:57, zhaoyang.huang wrote:
> > > From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> > >
> > > Introducing memory.root_current for the memory charges on root_mem_cgroup.
> >
> > Charges are not currently accounted for the root memcg universally. See
> > try_charge which is used for all user space and skmem charges. I am not
> > 100% sure about objcg based accounting because there is no explicit
> > check for the root memcg but this might be hidden somewhere as well.
> 
> Yes in __get_obj_cgroup_from_memcg(). However the reason to use
> try_charge_memcg() to bypass root check was to avoid the race with
> reparenting. More details in c5c8b16b596e ("mm: memcontrol: fix
> root_mem_cgroup charging").

Thanks for the pointer!

> > That means that the patch as is doesn't really provide and usable value.
> > The root exemption has been removed in the past but that has been
> > reverted due to a regression. See ce00a967377b ("mm: memcontrol: revert
> > use of root_mem_cgroup res_counter") for more.
> >
> 
> One advantage I can see is if someone is looking for usage for all top
> containers (alive or zombie) but I wanted to know if that was the real
> motivation behind the patch.

Isn't that just a global stats that we already display via /proc files?

-- 
Michal Hocko
SUSE Labs
