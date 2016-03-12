From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Sat, 12 Mar 2016 11:49:03 +0530
Message-ID: <CAG53R5XPFJn-gKvr-WtJy-+zv=APK0DWTBY96fo47XUD9h1FcQ@mail.gmail.com>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
	<1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
	<20160302173949.GG29826@mtj.duckdns.org>
	<CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
	<CAG53R5VYnTMzG4DchY2DKgveeeXbKcjUWQpOOjCNQuY-f7g9bg@mail.gmail.com>
	<CAG53R5Wwr41Ma4AbTG==4VcOGvdO=t=be8z0Lkfq0YukuBtCzg@mail.gmail.com>
	<20160305125215.GC3567@htj.duckdns.org>
	<CAG53R5V-fhbVqZWroAkvDpgjNWchnO87G47-iXqSGg41sY1A5Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=R37VAQO0JwsijJUn6Bi8+OC6D6j5a0Iwyp3aIEtdMtU=;
        b=sUbUDSpe+aYS/WBhMZroRr4QQj/euJDCI+LX1yh/mmRa49hQz3IzOPrS97aCHY3DUd
         nKDvWPtfK9it1zu0uBLv1nvtfJd7DQnp7Ts1VpTBBpffypPXzEBebeUGlYU0bWPDaTFX
         Q+gd0Rte2BNFC/Hr8tSgs3jAW1gtTTCPScpAKfhAyQrFu5vOWLZ9fuEwSMr68ZZN1KwP
         s7RjOZbQwmwrX0npeA7bAs86dbmyP1gl4b66slM2Co21FGHMc1BVRc4tVl3csWP4BoW+
         iwkbTayJoS7+j5WT/FdsWjXlefC+7TqAno+WpxW7QzK8KgkcLh/tKeHVkeX/pkv/IO5T
         Cc6w==
In-Reply-To: <CAG53R5V-fhbVqZWroAkvDpgjNWchnO87G47-iXqSGg41sY1A5Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

On Sat, Mar 5, 2016 at 10:50 PM, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Tejun,
>
> On Sat, Mar 5, 2016 at 6:22 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> Hello, Parav.
>>
>> On Sat, Mar 05, 2016 at 04:45:09PM +0530, Parav Pandit wrote:
>>> Design that remains same from v6 to v10.
>>>   * spin lock is still fine grained at cgroup level instead of one
>>> global shared lock among all cgroups.
>>>      In future it can be optimized further to do per cpu or using
>>> single lock if required.
>>>   * file type enums are still present for max and current, as
>>> read/write call to those files is already taken care by common
>>> functions with required if/else.
>>>   * Resource limit setting is as it is, because number of devices are
>>> in range of 1 to 4 count in most use cases (as explained in
>>> documentation), and its not hot path.
>>
>> 1 and 2 are not okay.
> For (1) shall I have one spin lock that is uses across multiple
> hierarchy and multiple cgroup.
> Essentially one global lock among all cgroup. During hierarchical
> charging, continue to use same lock it at each level.
> Would that work in this first release?
>

I am waiting for your reply.
Shall one lock for all cgroup is ok with you?

> Can you please review the code for (2), I cannot think of any further
> helper functions that I can write.
> For both the file types, all the code is already common.
> file types are used only to find out whether to reference max variable
> or usage variable in structure.
> Which can also be made as array, but I do not want to lose the code
> readability for that little gain.
> What exactly is the issue in current implementation? You just
> mentioned that "its not good sign".
> Its readable, simple and serves the purpose, what am I missing?
>
If this is ok. I will keep the code as it is, because it uses common
helper functions for max and current files.


>> 3 is fine but resource [un]charging is not hot path?
> charge/uncharge is hot path from cgroup perspective.
> Considering 1 to 4 devices in system rpool list would grow upto 4
> entry deep at each cgroup level.
> I believe this is good enough to start with. O complexity wise its
> O(N). where N is number of devices in system.
>
>
>>
>> Thanks.
>>
>> --
>> tejun
