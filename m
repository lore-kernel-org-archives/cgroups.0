From: Ofir Gal <ofir.gal-83CFe9096HFBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nvmet: allow associating port to a cgroup via configfs
Date: Thu, 6 Jul 2023 16:28:18 +0300
Message-ID: <d576007e-1e6b-848c-113c-a9365d278c88@volumez.com>
References: <20230627100215.1206008-1-ofir.gal@volumez.com>
 <30d03bba-c2e1-7847-f17e-403d4e648228@grimberg.me>
 <90150ffd-ba2d-6528-21b7-7ea493cd2b9a@nvidia.com>
 <79894bd9-03c7-8d27-eb6a-5e1336550449@volumez.com>
 <ab204a2d-9a30-7c90-8afa-fc84c935730f@grimberg.me>
 <ZKMehaAF0v-nV1qt@slm.duckdns.org>
 <b181b848-b2c7-4a7e-7173-ff6c771d6731@grimberg.me>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9xKj7Pk06sdn8V7DEo12Lkia0TREWf7VNceeMyOmmI=;
 b=IJ9MrPsTXIRaIueDbZGh7UT/ez7081gUA2Gj6TKXWPIXh2IvuDn9j5hWjPWK0D2h5AEHWWdjvP9AG+cKVM7xu9TExpwuINCnckU60Bs+y3Z9Fqs3QWqY5E4yBDJpDZKeKd5/e2+Szx9uxfQdgL+nj1jCeoB4QtHdSrD7G9DFVE8yPFP/Adh3rzoYoW0yFSTVvCeJYkflhgKhHwZgTcxHuYd1IOIyJk6mi4RmCWfO0Mj/QBecox/7lGgfRDIsQjvjSjEmE3oVNltSKVP7qwGvAev49lDgptgdQQY/45fZAJeRu6ZLDCeC+XJaAIbmsUmBp4MogtJoq4ytyJlpFuU0bA==
Content-Language: en-US
In-Reply-To: <b181b848-b2c7-4a7e-7173-ff6c771d6731-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 04/07/2023 10:54, Sagi Grimberg wrote:
>>>> A full blown nvmet cgroup controller may be a complete solution, but it
>>>> may take some time to achieve,
>>>
>>> I don't see any other sane solution here.
>>>
>>> Maybe Tejun/others think differently here?
>>
>> I'm not necessarily against the idea of enabling subsystems to assign
>> cgroup
>> membership to entities which aren't processes or threads. It does make
>> sense
>> for cases where a kernel subsystem is serving multiple classes of users
>> which aren't processes as here and it's likely that we'd need something
>> similar for certain memory regions in a limited way (e.g. tmpfs chunk
>> shared
>> across multiple cgroups).
> 
> That makes sense.
> 
> From the nvme target side, the prime use-case is I/O, which can be on
> against bdev backends, file backends or passthru nvme devices.
> 
> What we'd want is for something that is agnostic to the backend type
> hence my comment that the only sane solution would be to introduce a
> nvmet cgroup controller.
> 
> I also asked the question of what is the use-case here? because the
> "users" are remote nvme hosts accessing nvmet, there is no direct
> mapping between a nvme namespace (backed by say a bdev) to a host, only
> indirect mapping via a subsystem over a port (which is kinda-sorta
> similar to a SCSI I_T Nexus). Implementing I/O service-levels
> enforcement with blkcg seems like the wrong place to me.

We have a server with a bdev that reach 15K IOPs, but when more than 10K
IOPs are served the latency of the bdev is being doubled. We want to
limit this bdev to 10K IOPs to serve the clients with low latency.

For sake of simplicity The server expose the bdev with nvme target under
a single subsystem and with a single namespace through a single port.

There are 2 clients connected to the server, the clients aren't aware of
each other and are submitting unknown amount of IOPs.
Without the limitation on the server side we have to limit each client
to half of the bdev capability, in our example it would be 5K IOPs for
each client.

This would be non-optimal limitation, sometimes client #1 is idle while
client #2 need to submit 10K IOPs.
With a server side limitation, both clients can submit up to 10K
combined but are exposed to "noisy-neighbor".

>> That said, because we haven't done this before, we haven't figured out
>> how
>> the API should be like and we definitely want something which can be
>> used in
>> a similar fashion across the board. Also, cgroup does assume that
>> resources
>> are always associated with processes or threads, and making this work
>> with
>> non-task entity would require some generalization there. Maybe the
>> solution
>> is to always have a tying kthread which serves as a proxy for the
>> resource
>> but that seems a bit nasty at least on the first thought.

A general API to associate non-task entities sounds great!


On 03/07/2023 13:21, Sagi Grimberg wrote:
> cgroupv2 didn't break anything, this was never an intended feature of
> the linux nvme target, so it couldn't have been broken. Did anyone
> know that people are doing this with nvmet?
> 
> I'm pretty sure others on the list are treating this as a suggested
> new feature for nvmet. and designing this feature as something that
> is only supported for blkdevs is undersirable.

I understand that throttling of an nvme target was not an intended feature.
However it was possible to create a global limit for any bdev, which
allowed throttling nvme target with bdev backends.
Today with the new cgroup architecture it is impossible.

I don't see how this does not count as a user-space breakage.
I think this patch can be a temporary solution until a general API will
be designed and implemented.


