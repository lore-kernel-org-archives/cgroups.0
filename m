From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cgroups: add a pids subsystem
Date: Tue, 10 Mar 2015 19:10:46 +1100
Message-ID: <CAOviyah2KCu9K7D_H2zAf3LYbnj65P39YPmNamfA=-SSNq4hOg@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
	<1425606357-6337-1-git-send-email-cyphar@cyphar.com>
	<1425606357-6337-3-git-send-email-cyphar@cyphar.com>
	<20150309033405.GE13283@htj.duckdns.org>
	<54FDED43.4050908@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54FDED43.4050908-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Austin,

>> Does pids limit make sense in the root cgroup?
>>
> I would say it kind of does, although I would just expect it to track
> /proc/sys/kernel/pid_max (either as a read-only value, or as an alternative
> way to set it).

Personally, that seems unintuitive. /proc/sys/kernel/pid_max and the pids
cgroup controller are orthogonal features, why should they be able to affect
each other (or even be aware of each other)?

--
Aleksa Sarai (cyphar)
www.cyphar.com
