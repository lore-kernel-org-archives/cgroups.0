From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: retrieve parent memcg from css.parent
Date: Wed, 12 Jan 2022 00:24:21 +0000
Message-ID: <20220112002421.m3fyktkkz55fup3v@master>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
 <20220111010302.8864-3-richard.weiyang@gmail.com>
 <Yd3H8Hea6dBlkzeW@carbon.dhcp.thefacebook.com>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dFpazlv+lywoGwl9/cFSYAAABBv6zxWMmcLpH0m+3/M=;
        b=Jvwa9TaIcLtrQXSCOZEpvt5o4j62C2t3W/QMQ/KHJ/fiv10OoW6JKvXj5KBsR6XAd9
         YTJX3yMs+oReKUEusB6HXOycLwagLJUD3wZlEY4LzzdZZk2UhbnmiM2kmyYYwY3bXcry
         I5k+BCombR71JSn6bX3+5Knoym/PI1ut2Mzwc/VjfVDq/AqE04o8xf4fXQz5FmaHuweo
         JkXPznZqOnmSwakVWgUKEGUyT9xIufjGXDTNb8kX1g956DAXLnicAHPkoZITy9/nV74M
         TdhGyqIuaWMDnKnhm95W6/P6RSpUBTjyJ0EQAGayOmRlDg58JOSj8qZKnbD+IR6TiQkT
         Fhdg==
Content-Disposition: inline
In-Reply-To: <Yd3H8Hea6dBlkzeW-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Jan 11, 2022 at 10:09:52AM -0800, Roman Gushchin wrote:
>On Tue, Jan 11, 2022 at 01:03:01AM +0000, Wei Yang wrote:
>> The parent we get from page_counter is correct, while this is two
>> different hierarchy.
>> 
>> Let's retrieve the parent memcg from css.parent just like parent_cs(),
>> blkcg_parent(), etc.
>
>Does it bring any benefits except consistency?
>

I am afraid no.

>> 
>> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
>
>Thanks!

-- 
Wei Yang
Help you, Help me
