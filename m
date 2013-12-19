From: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/6] memcg, slab: check and init memcg_cahes under slab_mutex
Date: Thu, 19 Dec 2013 12:00:58 +0400
Message-ID: <CAA6-i6r=hW+Y2+kdKME=GTWN6sCbi37kh4sX5dT3AKkatpQzGg@mail.gmail.com>
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com>
	<afc6d5e85d805c7313e928497b4ebcf1815703dd.1387372122.git.vdavydov@parallels.com>
	<20131218174105.GE31080@dhcp22.suse.cz>
	<52B29B2F.7050909@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=OM/pgHiFse7nGo/O3tYluJY8FFc8glnHmyBXrfl+ffY=;
        b=xXKv2eQ8uo/CNTgH/7b7g7hDH0pMde55ZVtIPSJL30gNO5ydpD5e4ZN6jBcGDrzedN
         +ndBldxMR3sFgUELO/GHj51IdFBtJUwc6j58ce09oydh72++Wa366zEL8AQqsPf0ywlr
         XLAYB2h8V2jFgGoktDQdhZwBhyobI7q/Bh12nuwQRUXLfrNvEYsdXsCZoQkM+nJlb6Td
         cQ2rvHAYT9Kz3qKV5QUa6+xdaOD9dpHx/vcl+uxXi2miD2T4zXWnZC7sSQ1conBXrOly
         NjIzjgH1ux8CpUJmRTa2abNnwV+0Q5tJdqmzaHOX+uPH4lv7XS0YOw6AHu1LDchf1PRG
         40tg==
In-Reply-To: <52B29B2F.7050909-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Dec 19, 2013 at 11:07 AM, Vladimir Davydov
<vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> On 12/18/2013 09:41 PM, Michal Hocko wrote:
>> On Wed 18-12-13 17:16:55, Vladimir Davydov wrote:
>>> The memcg_params::memcg_caches array can be updated concurrently from
>>> memcg_update_cache_size() and memcg_create_kmem_cache(). Although both
>>> of these functions take the slab_mutex during their operation, the
>>> latter checks if memcg's cache has already been allocated w/o taking the
>>> mutex. This can result in a race as described below.
>>>
>>> Asume two threads schedule kmem_cache creation works for the same
>>> kmem_cache of the same memcg from __memcg_kmem_get_cache(). One of the
>>> works successfully creates it. Another work should fail then, but if it
>>> interleaves with memcg_update_cache_size() as follows, it does not:
>> I am not sure I understand the race. memcg_update_cache_size is called
>> when we start accounting a new memcg or a child is created and it
>> inherits accounting from the parent. memcg_create_kmem_cache is called
>> when a new cache is first allocated from, right?
>
> memcg_update_cache_size() is called when kmem accounting is activated
> for a memcg, no matter how.
>
> memcg_create_kmem_cache() is scheduled from __memcg_kmem_get_cache().
> It's OK to have a bunch of such methods trying to create the same memcg
> cache concurrently, but only one of them should succeed.
>
>> Why cannot we simply take slab_mutex inside memcg_create_kmem_cache?
>> it is running from the workqueue context so it should clash with other
>> locks.
>
> Hmm, Glauber's code never takes the slab_mutex inside memcontrol.c. I
> have always been wondering why, because it could simplify flow paths
> significantly (e.g. update_cache_sizes() -> update_all_caches() ->
> update_cache_size() - from memcontrol.c to slab_common.c and back again
> just to take the mutex).
>

Because that is a layering violation and exposes implementation
details of the slab to
the outside world. I agree this would make things a lot simpler, but
please check with Christoph
if this is acceptable before going forward.
