From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH] memcg: charge semaphores and sem_undo objects
Date: Fri, 16 Jul 2021 06:57:19 +0300
Message-ID: <44325e3a-f4e9-c19a-4a00-672d1d61120d@virtuozzo.com>
References: <1626333284-1404-1-git-send-email-nglaive@gmail.com>
 <CALvZod4-Vh4O4-PN661jqicSg95GPf87nv10xAYr1yG6oZQk8A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=bgQrMW8axuqa/T8OOKL/8pzBoixeuP3GcTBvX+k2SpY=; b=ABeW19tYTEkgGjO1b
        3IjN+IBg+c61j/saK+k9QaFFs2jRbXXrudHF8U++xtdk2StgGhWTLooje6M3F88/32vXqHYW69kk9
        n7YlZZoTDtX7B7xEH7ILb7BiQcbl0qx7xV8fAQSQLhfKlVVZ2njJ+GqbBw1/00kUxxYTAiw2rUqGM
        =;
In-Reply-To: <CALvZod4-Vh4O4-PN661jqicSg95GPf87nv10xAYr1yG6oZQk8A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org

On 7/15/21 8:05 PM, Shakeel Butt wrote:
> On Thu, Jul 15, 2021 at 12:15 AM Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Signed-off-by: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Thanks for the patch Yutian. I remember patch from Vasily regarding
> memcg charging of similar objects.

Yes, it is part of my "memcg: enable accounting of ipc resources" patch.
We account few other IPC objects too. 

> Vasily, what's the status of your patch?

It is still not merged, unfortunately, I will try to push it again.

Thank you,
	Vasily Averin
