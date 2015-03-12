From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cgroups: add a pids subsystem
Date: Thu, 12 Mar 2015 13:28:10 +1100
Message-ID: <CAOviyahChsruXvjfu6EJCi49o6R38DHj5iLV92HuyJtfn2a81A@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
	<1425606357-6337-1-git-send-email-cyphar@cyphar.com>
	<1425606357-6337-3-git-send-email-cyphar@cyphar.com>
	<20150309033405.GE13283@htj.duckdns.org>
	<54FDED43.4050908@gmail.com>
	<CAOviyah2KCu9K7D_H2zAf3LYbnj65P39YPmNamfA=-SSNq4hOg@mail.gmail.com>
	<54FED651.6040100@gmail.com>
	<CAOviyagpCNcAN4hdhsxffdpE+yDmw+NXx+FikTe64GJ1hQeXhQ@mail.gmail.com>
	<55005BAC.9060405@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55005BAC.9060405-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> I did not necessarily word this very clearly.  What I meant is that
> /proc/sys/kernel/pid_max is essentially an external limiting factor that
> caps the total number of pids that can be under the root cgroup and it's
> children, not that the cgroup in any way payed attention to it.  It might be
> useful to be able to just disable the sysctl option and set the value
> through the root cgroup, solely or consistency, although such usage isn't
> something I would consider essential in any way.

Maybe this is something that can be reviewed as a separate patchset to this
one? I'd much prefer that we actually get per-cgroup process limiting merged
first, then deal with such features separately.

--
Aleksa Sarai (cyphar)
www.cyphar.com
