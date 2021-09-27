From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH mm] vmalloc: back off when the current task is OOM-killed
Date: Mon, 27 Sep 2021 12:36:15 +0300
Message-ID: <508abe37-a044-7180-ac67-b4ce5e4cc149@virtuozzo.com>
References: <YT8PEBbYZhLixEJD@dhcp22.suse.cz>
 <d07a5540-3e07-44ba-1e59-067500f024d9@virtuozzo.com>
 <YUsg4j8gEt+WOCzi@dhcp22.suse.cz>
 <fa29c6f9-a53c-83bd-adcb-1e09d4387024@virtuozzo.com>
 <YU2EXP5wrSKv+b/8@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=UuF6FHs19BNorLrl2iJ5nlzRqI12m41442Ub5BwC1yY=; b=cLaqobgNClIHOqPlH
        4PvwKYnD6rUCdvka5AQkv2s1rFASROYIi0XMbECngjIx9Cdm9lUzuqO/DpoDma1WyY+fZO27ZPZCz
        yVMT5tKlP4GG049tOkT8nVxdakIoLjMIA4pjZZ1d+/PtrSfIjlruZdsBA9KuVUT0pB6QMF8a5RhM4
        =;
In-Reply-To: <YU2EXP5wrSKv+b/8@dhcp22.suse.cz>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 9/24/21 10:55 AM, Michal Hocko wrote:
> On Thu 23-09-21 09:49:57, Vasily Averin wrote:
> [...]
>> I'm agree that vmalloc callers should expect and handle single vnalloc failures.
>> I think it is acceptable to enable fatal_signal_pending check to quickly
>> detect such kind of iussues.
>> However fatal_signal_pending check can cause serial vmalloc failures
>> and I doubt it is acceptable. 
>>
>> Rollback after failed vmalloc can call new vmalloc calls that will be failed too, 
>> even properly handled such serial failures can cause troubles.
> 
> Could you be more specific? Also how would this be any different from
> similar failures for an oom victim? Except that the later is less likely
> so (as already mentioend) any potential bugs would be just lurking there
> for a longer time.
> 
>> Hypothetically, cancelled vmalloc called inside some filesystem's transaction
>> forces its rollback, that in own turn it can call own vmalloc.
> 
> Do you have any specific example?

No, it was pure hypothetical assumption.
I was thinking about it over the weekend, and decided that:
a) such kind of issue (i.e. vmalloc call in rollback after failed vmalloc)
   is very unlikely
b) if it still exists -- it must have own failback with kmalloc(NOFAIL) 
   or just accept/ignore such failure and should not lead to critical failures.
   If this still happen -- ihis is a bug, we should detect and fix it ASAP.

>> Should we perhaps interrupt the first vmalloc only?
> 
> This doesn't make much sense to me TBH. It doesn't address the very
> problem you are describing in the changelog.

Last question:
how do you think, should we perhaps, instead, detect such vmallocs 
(called in rollback after failed vmalloc) and generate a warnings,
to prevent such kind of problems in future?

Thank you,
	Vasily Averin
