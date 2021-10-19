From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg 0/1] false global OOM triggered by memcg-limited
 task
Date: Tue, 19 Oct 2021 16:19:38 +0200
Message-ID: <YW7T+m8Y0wgWSnvQ@dhcp22.suse.cz>
References: <YW04jWSv6pQb2Goe@dhcp22.suse.cz>
 <6b751abe-aa52-d1d8-2631-ec471975cc3a@virtuozzo.com>
 <YW1gRz0rTkJrvc4L@dhcp22.suse.cz>
 <339ae4b5-6efd-8fc2-33f1-2eb3aee71cb2@virtuozzo.com>
 <YW6GoZhFUJc1uLYr@dhcp22.suse.cz>
 <687bf489-f7a7-5604-25c5-0c1a09e0905b@virtuozzo.com>
 <YW6yAeAO+TeS3OdB@dhcp22.suse.cz>
 <YW60Rs1mi24sJmp4@dhcp22.suse.cz>
 <6c422150-593f-f601-8f91-914c6c5e82f4@virtuozzo.com>
 <YW7SfkZR/ZsabkXV@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634653178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=17XfwS65rinqRQ1q6ipG3Hb8XhX7XNxJzO/iLYtDfK8=;
        b=QpnkvsCK9QJG2NyfNxwehgKhumEq8pDVXnpoMGN8xddkAgH7ZIiQiOX7D9WT2NjdLI/jgt
        /wzL6qvCxdyIDB6JS9svh59sSk2sZtQWMMNpmX4vXEb+OaoLLk0/hHU8TttGB5C5zksYsg
        HyUqFZ8b61DP8AYqq0iyHrqA7lj0kLk=
Content-Disposition: inline
In-Reply-To: <YW7SfkZR/ZsabkXV-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue 19-10-21 16:13:19, Michal Hocko wrote:
[...]
> That patch has to be discuss in its full length. There were other
> details I have brought up AFAIU.

And btw. thanks for walking through that maze! It is far from trivial
with side effects all over the place which far from obvious and heavily
underdocumented.

-- 
Michal Hocko
SUSE Labs
