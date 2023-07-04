From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] nvmet: allow associating port to a cgroup via configfs
Date: Tue, 4 Jul 2023 10:54:31 +0300
Message-ID: <b181b848-b2c7-4a7e-7173-ff6c771d6731@grimberg.me>
References: <20230627100215.1206008-1-ofir.gal@volumez.com>
 <30d03bba-c2e1-7847-f17e-403d4e648228@grimberg.me>
 <90150ffd-ba2d-6528-21b7-7ea493cd2b9a@nvidia.com>
 <79894bd9-03c7-8d27-eb6a-5e1336550449@volumez.com>
 <ab204a2d-9a30-7c90-8afa-fc84c935730f@grimberg.me>
 <ZKMehaAF0v-nV1qt@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <ZKMehaAF0v-nV1qt-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ofir Gal <ofir.gal-83CFe9096HFBDgjK7y7TUQ@public.gmane.org>, Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


>>> A full blown nvmet cgroup controller may be a complete solution, but it
>>> may take some time to achieve,
>>
>> I don't see any other sane solution here.
>>
>> Maybe Tejun/others think differently here?
> 
> I'm not necessarily against the idea of enabling subsystems to assign cgroup
> membership to entities which aren't processes or threads. It does make sense
> for cases where a kernel subsystem is serving multiple classes of users
> which aren't processes as here and it's likely that we'd need something
> similar for certain memory regions in a limited way (e.g. tmpfs chunk shared
> across multiple cgroups).

That makes sense.

 From the nvme target side, the prime use-case is I/O, which can be on
against bdev backends, file backends or passthru nvme devices.

What we'd want is for something that is agnostic to the backend type
hence my comment that the only sane solution would be to introduce a
nvmet cgroup controller.

I also asked the question of what is the use-case here? because the
"users" are remote nvme hosts accessing nvmet, there is no direct
mapping between a nvme namespace (backed by say a bdev) to a host, only
indirect mapping via a subsystem over a port (which is kinda-sorta
similar to a SCSI I_T Nexus). Implementing I/O service-levels
enforcement with blkcg seems like the wrong place to me.

> That said, because we haven't done this before, we haven't figured out how
> the API should be like and we definitely want something which can be used in
> a similar fashion across the board. Also, cgroup does assume that resources
> are always associated with processes or threads, and making this work with
> non-task entity would require some generalization there. Maybe the solution
> is to always have a tying kthread which serves as a proxy for the resource
> but that seems a bit nasty at least on the first thought.

That was also a thought earlier in the thread as that is pretty much
what the loop driver does, however that requires quite a bit of
infrastructure because nvmet threads are primarily workqueues/kworkers,
There is no notion of kthreads per entity.

> In principle, at least from cgroup POV, I think the idea of being able to
> assign cgroup membership to subsystem-specific entities is okay. In
> practice, there are quite a few challenges to address.

Understood.
