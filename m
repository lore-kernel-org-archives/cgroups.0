From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFD] Merge task counter into memcg
Date: Wed, 18 Apr 2012 10:10:54 +0200
Message-ID: <CAFTL4hxXT+hXWEnKop84JQ8ieHX4e=otpHnXYxdxaPgsiZYCiw@mail.gmail.com>
References: <20120411185715.GA4317@somewhere.redhat.com>
	<20120412010745.GE1787@cmpxchg.org>
	<20120412145507.GC11455@somewhere.redhat.com>
	<4F87042A.2000902@parallels.com>
	<20120412165922.GA12484@somewhere.redhat.com>
	<20120417151753.GB32402@google.com>
	<20120418065430.GB25568@somewhere>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=AcxMabGI5BLpt4qiBTjcwPGKHY8Dj+GEo/a6eS/+d6I=;
        b=YlWpu3kXf+6+FGG+Dy1LFcrzV8w6bXFHH6mHFyB8MdUsV7qqSNlK0+wd43EJey4Kvc
         s3Iib7C06qv0zfrW49ltFoRYGInACQBRd46+THmDJvF8hhoo50VzJEoFVLRKnME//gzT
         Yw6B3sZCbP60AI3icOc8OU5wwkmj7LrRPgR1HMIfuwgOotafgztnNNKGLmMc7TewpIwp
         nHlYi26+Xk5ROJeuB72JQsrymRQF8lLirXrNDNxWjCwgwqvrVUK90Xeh23d77k0gwMU7
         XXad26i5lDjxgEgdo/Dr5iqKDUp+Pz8BuyM9VowV41SK7SK1RfAMoQ1ZQAZVmmY1xSqs
         qWhw==
In-Reply-To: <20120418065430.GB25568@somewhere>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Daniel Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

2012/4/18 Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Tue, Apr 17, 2012 at 08:17:53AM -0700, Tejun Heo wrote:
>> Hello, Frederic.
>>
>> On Thu, Apr 12, 2012 at 06:59:27PM +0200, Frederic Weisbecker wrote:
>> > I want:
>> >
>> > a) to prevent the forkbomb from going far enough to DDOS the machi=
ne
>> > b) to be able to kill that forkbomb once detected, in one go witho=
ut race
>> > against concurrent forks.
>> >
>> > I think a) can work just fine with kernel stack limiting. I also n=
eed
>> > to be notified about the fact we reached the limit. And b) should
>> > be feasible with the help of the cgroup freezer.
>>
>> kmem allocation fail after reaching the limit which in turn should
>> fail task creation. =A0Isn't that the same effect as the task_counte=
r as
>> implemented?
>
> That's it.
>
>>
>> > > Is there anything for which you need to know exactly the number =
of
>> > > processes?
>> >
>> > No that's really about prevent/kill forkbomb as far as I'm concern=
ed.
>>
>> Hmm... so, accounting overhead aside, if the only purpose is
>> preventing the whole machine being brought down by a fork bomb, kmem
>> limiting is enough, right?
>
> I think so yeah.

But this needs to be a well defined kind of kmem I think. Relying on
kernel memory
alone is too general to just protect against forkbombs. Kernel stack,
OTOH, should be
a good criteria.

But now I'm worrying, do you think this kmem.kernel_stack limitation
is going to be useful
for other kind of usecase?
