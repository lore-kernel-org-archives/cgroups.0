From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/6] cgroup/cpuset: Clarify the use of invalid
 partition root
Date: Fri, 16 Jul 2021 11:18:40 -1000
Message-ID: <YPH3sF56gK71CxXY@mtj.duckdns.org>
References: <20210621184924.27493-1-longman@redhat.com>
 <20210621184924.27493-3-longman@redhat.com>
 <YNcHOe3o//pIiByh@mtj.duckdns.org>
 <6ea1ac38-73e1-3f78-a5d2-a4c23bcd8dd1@redhat.com>
 <YONGk3iw/zrNzwLK@mtj.duckdns.org>
 <c6ae2d9b-ad6e-9bbd-b25c-f52b0ff6fb9b@redhat.com>
 <1bb119a1-d94a-6707-beac-e3ae5c03fae5@redhat.com>
 <8c44b659-3fe4-b14f-fac1-cbd5b23010c3@redhat.com>
 <YPHwG61qGDa3h6Wg@mtj.duckdns.org>
 <e8c538a8-bf5c-b04c-1b21-ac22cd158dd1@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ATw9tZdhYF/626TCmJT2xXOkMuRTkYsc1yKjcQyVFP0=;
        b=IypbT7+Y0NaY7r9Dz97O68Ntezw/INbqU4XXy8HH/13CPcy3JWupvvny1EdiU3s5qO
         FZghZX/FF33NOXDSqw9xOVT5LrWy+YP1ewjsl0FSO8Y8quMKMO0KHnMcZ190oPP7vEoH
         E10fYtWDnV1+jt6RpDepRL9GRku98ELwqAYWrpOzugyFLn5qd7PiE4DAIWROZWa9G8cJ
         0kgj18ee0JcqJv/OlEu3eD6cPTuWgodRad+mgW7a7LYA0mluYalnPz2fK0b9hC8b/9EA
         S1VcjFT+P1+Zhq947Ax0zHHnXemfiCIu/j7G7ZZU4FBXoS3tq49QCnDs537UxFpynhYk
         di+Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e8c538a8-bf5c-b04c-1b21-ac22cd158dd1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Fri, Jul 16, 2021 at 05:12:17PM -0400, Waiman Long wrote:
> Are you suggesting that we add a cpuset.cpus.events file that allows
> processes to be notified if an event (e.g. hotplug) that changes a partition
> root to invalid partition happens or when explicit change to a partition
> root fails? Will that be enough to satisfy your requirement?

Yeah, something like that or make the current state file generate events on
state transitions.

Thanks.

-- 
tejun
