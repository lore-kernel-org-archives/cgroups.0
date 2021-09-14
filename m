From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH memcg] memcg: prohibit unconditional exceeding the limit
 of dying tasks
Date: Tue, 14 Sep 2021 13:01:40 +0300
Message-ID: <bab6c1d2-38d8-9098-206f-54894f9871b6@virtuozzo.com>
References: <5b06a490-55bc-a6a0-6c85-690254f86fad@virtuozzo.com>
 <YT8RjxShvfEVe4YU@dhcp22.suse.cz>
 <7af26106-388c-6f99-e018-669a8f0cf9b5@virtuozzo.com>
 <YT8uGUMQ7K+/0gyA@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=ImRIPihhAObidTCiJqcnR+Z8IfwFSS7GltQDYdsx+N8=; b=s9EIcM218cXLgAcVF
        x2igWWw+5J2ksbdHAJ76DZGcs4PAzMOI4aqrBzYOgTroR3W22sFgMdz6nr8qWJSgZEgjefXl12Zfz
        5Rzt4hTINk5F9djLHnQdmuhAnpSxGuDgQmwNgTfiMHgIIord/XMaxAN3OiEGHEcr2V+NjawPY02l0
        =;
In-Reply-To: <YT8uGUMQ7K+/0gyA-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 9/13/21 1:55 PM, Michal Hocko wrote:
> Here is what I would do.

Your patch fixes the problem, I just want to add rename of should_force_charge()
helper to task_is_dying() and will submit v2 version soon.

I think this patch is not optimal, however its improvements can be discussed later.

Thank you,
	Vasily Averin
