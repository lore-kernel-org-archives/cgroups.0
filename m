From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 1/4] cgroups: use bitmask to filter for_each_subsys
Date: Sun, 26 Apr 2015 12:09:09 -0400
Message-ID: <20150426160909.GC1499@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-2-git-send-email-cyphar@cyphar.com>
 <20150422152551.GA10738@htj.duckdns.org>
 <20150422154212.GE3007@worktop.Skamania.guest>
 <20150422160258.GE10738@htj.duckdns.org>
 <CAOviyagvVTKjRp4wxyNo4Oke-w=Wbda+UyHAN-ih9yFX-8jqmw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=SHY0w3ShSq5zgJUhcNvXg4ChAqoyO79UzrINFW2e4QY=;
        b=xsLQKAdUkK6o+oiLWxFwACkjBWTERuO4AP7vU/Bl/b7Q8Bw4Z2qwHSEU5mrp/lDiLl
         PkSUmm+omwtw7Cl9UNRg4vbooSroWcmX96fmCCR5RkWzeKZRIeWYn388Ng4+V6xxtAxj
         Ge8B9B7gGt6efRwG2YW19079IzPsoQN9VOBmHdBsLcOxrsFfIF/zqqNkkV6yIT2JGbHI
         mr4uFIzhvO+6z5I8F46rII/tjbq8XzLjxVVO+Caa195rp5skViFlV+kjGg+LhSkV6wtf
         kUik0R+ro5EGNA0BbdIfQsNklu5f5VKiC3Rc1Al7xvW+/Fo4ExjqLvoaAtHFbIbZ4nPq
         3sXQ==
Content-Disposition: inline
In-Reply-To: <CAOviyagvVTKjRp4wxyNo4Oke-w=Wbda+UyHAN-ih9yFX-8jqmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Apr 27, 2015 at 02:05:47AM +1000, Aleksa Sarai wrote:
> In addition, there are a bunch of cgroup_* functions that use unsigned
> ints for bitops (cgroup_calc_child_subsys_mask, rebind_subsystems,
> cgroup_print_ss_mask). Is there a better solution to this problem, or
> should I just switch back to my naive solution?

Hmmmm... You can either convert all masks to ulong (which is fine) or
do something like the following.

#define for_each_subsys_which(ss_mask, ss, ssid)            \
    unsigned long __tmp_mask = (ss_mask);		    \
    for_each_set_bit(ssid, &__tmp_mask, CGROUP_SUBSYS_COUNT)\
            if ((ss) = group_subsys[ssid] && false)         \
                    ;                                       \
             else

Thanks.

-- 
tejun
