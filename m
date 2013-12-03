From: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: remove KMEM_ACCOUNTED_ACTIVATED
Date: Wed, 4 Dec 2013 02:38:46 +0400
Message-ID: <CAA6-i6q2viRkbjYOHcoiCHgvdfbfo-4j0k9gj9AA4SH1YToqVg@mail.gmail.com>
References: <1385989693-28788-1-git-send-email-vdavydov@parallels.com>
	<20131202181501.GA5524@dhcp22.suse.cz>
	<CAA6-i6rWsZNQmFY5L-=yc6TaTGyg4hP4qn9gMZVsu8wWJ=1ywg@mail.gmail.com>
	<529CDDB3.3090301@parallels.com>
	<CAA6-i6q+WooWMSbJwLS=ByVu=fgAQuep99iP7tAXiuLABu2gVA@mail.gmail.com>
	<529D9100.4070207@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=rJGMEYF8VK/HdobY+wqhpUUMn+LH10HS0K6D84ijpF4=;
        b=KXrX8j3LzUBbayYydLn4Y+8cBumBm8n3d8mX5gQSrVnIfo9JznhY3ZD5coh4dYP0af
         E/ji0qxhVJMPXjJF3mEB9rLRQjSCoA7NCLwdmNQXleHoiVXNgLlEg++tGmIrQ239F2CY
         yDz24qCFOyhImRAEsgeG6f1YkTfwiwNzH5lLMcMgyudDq0C3C2E1K44XBFa5vy2f9tTU
         3/rTjUpbGtX/oV7cW/pemIxbNuhRGoUzjTM+iZrDDUCWx3vipJHVi6sD2Pc3q9oJt6+k
         TNfSi3n0WyDxrKUuh1FxE8ZjLpZgZdRswTnrqtiO4f1E668kUbJMTPP0eAuQ+Du26Jh3
         Gmeg==
In-Reply-To: <529D9100.4070207-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

>>> Hi, Glauber

Hi.

>
> In memcg_update_kmem_limit() we do the whole process of limit
> initialization under a mutex so the situation we need protection from in
> tcp_update_limit() is impossible. BTW once set, the 'activated' flag is
> never cleared and never checked alone, only along with the 'active'
> flag, that's why I doubt we need it at all.

The updates are protected by a mutex, but the readers are not, and should not.
So we can still be patching the readers, and the double-flag was
initially used so
we can make sure that both flags are only set after the static branches are in.

Note that one of the flags is set inside memcg_update_cache_sizes(). After that,
we call static_key_slow_inc(). At this point, someone whose code is
patched in could
start accounting, but it shouldn't - because not all sites are patched in.

So after the update is done, we set the other flag, and now everybody
will start going
through.

Could you do something clever with just one flag? Probably yes. But I
doubt it would
be that much cleaner, this is just the way that patching sites work.

-- 
E Mare, Libertas
