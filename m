From: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Subject: Re: [PATCH memcg] memcg: prohibit unconditional exceeding the limit
 of dying tasks
Date: Fri, 10 Sep 2021 22:04:55 +0900
Message-ID: <099aa0db-045a-e5b8-6df7-b7c3fc4d3caa@i-love.sakura.ne.jp>
References: <5b06a490-55bc-a6a0-6c85-690254f86fad@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5b06a490-55bc-a6a0-6c85-690254f86fad-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 2021/09/10 21:39, Vasily Averin wrote:
> The kernel currently allows dying tasks to exceed the memcg limits.
> The allocation is expected to be the last one and the occupied memory
> will be freed soon.
> This is not always true because it can be part of the huge vmalloc
> allocation. Allowed once, they will repeat over and over again.
> Moreover lifetime of the allocated object can differ from
> In addition the lifetime of the dying task.

Can't we add fatal_signal_pending(current) test to vmalloc() loop?

> Multiple such allocations running concurrently can not only overuse
> the memcg limit, but can lead to a global out of memory and,
> in the worst case, cause the host to panic.
> 
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
