From: anjana vk <anjanvk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroup attach task - slogging cpu
Date: Thu, 10 Oct 2013 09:52:00 +0530
Message-ID: <CALPf4Txeh85oq_Bo6qd=emniNGvKsJN1xJQY111Tuz+XOrSxiA@mail.gmail.com>
References: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com>
	<20131004130207.GA9338@redhat.com>
	<20131007184507.GD27396@htj.dyndns.org>
	<20131008145833.GA15600@redhat.com>
	<5254EB2A.7090803@huawei.com>
	<20131009133047.GA12414@redhat.com>
	<20131009140551.GA15849@redhat.com>
	<CAChhN7RerxpSadqyosUeSKFg+qcOpO4d-maEKBZ0rvOQGvN27g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=kAnH2QDBBfx5ujHJ5KyJziXi4lotTTB6yfsBr2BuH1E=;
        b=EqZbhhHt/2yCmLxPzF6boeGsJQAy+j73larXX3GMrWxoxGXll09v2P/8NKqWWYbZWN
         AB7YFuyauSXdPvvQGkv4xJ7Z5leaGc0/bQL0gCV0ZdSVAk56PPbmiR9ypIYrUekG5F7+
         YEbBUv4CE7nmZt099KUnRKv/p4Nly6ybzyDk/H0heUyN5a18M5UwShwox+spM0ZKdbg2
         4OTdCKmucB8kdEkr2KqGn73+kz3YJNpLWRTlNj+iHqxqpPC6uqqmusZPUIoTj3c4pnG6
         Ao8qqda0332hRmhFM0UtfWq+P0jKdXKVAEVh5KAM5x/UdBwMz6fHTCkQGxH+xzDgMrsU
         oBtQ==
In-Reply-To: <CAChhN7RerxpSadqyosUeSKFg+qcOpO4d-maEKBZ0rvOQGvN27g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anjana V Kumar <anjanavk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

+cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/10/13, Anjana V Kumar <anjanavk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi All,
>
> Please find the attached patch making the changes for the case where thread
> is already in the required cgroup.
>
> Can you please let me know if this is the right way to fix this issue, if
> any modifications are required.
>
> Thanks and Regards
> Anjana
>
>
> On Wed, Oct 9, 2013 at 7:35 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On 10/09, Oleg Nesterov wrote:
>> >
>> > On 10/09, Li Zefan wrote:
>> > >
>> > > Anjana, could you revise the patch and send it out with proper
>> changelog
>> > > and Signed-off-by? And please add "Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #
>> 3.9+"
>> >
>> > Yes, Anjana, please!
>>
>> Please note also that the PF_EXITING check has the same problem, it also
>> needs "goto next".
>>
>> > > > check in the main loop. So Anjana was right (sorry again!), and we
>> > > > should probably do
>> > > >
>> > > >           ent.cgrp = task_cgroup_from_root(...);
>> > > >           if (ent.cgrp != cgrp) {
>> > > >                   retval = flex_array_put(...);
>> > > >                   ...
>> > > >           }
>> > > >
>> > > >           if (!threadgroup)
>> > > >                   break;
>> > > >
>> > >
>> > > Or
>> > >
>> > > do {
>> > >     ...
>> > >     if (ent.cgrp == cgrp)
>> > >             goto next;
>> >
>> > Or this, agreed.
>> >
>> > > > Or I am wrong again?
>> > >
>> > > No, you are not! :)
>> >
>> > Thanks ;)
>> >
>> > Oleg.
>>
>>
>
>
> --
> Anjana
>
