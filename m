From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cgroups: add a pids subsystem
Date: Tue, 10 Mar 2015 23:31:47 +1100
Message-ID: <CAOviyagpCNcAN4hdhsxffdpE+yDmw+NXx+FikTe64GJ1hQeXhQ@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
	<1425606357-6337-1-git-send-email-cyphar@cyphar.com>
	<1425606357-6337-3-git-send-email-cyphar@cyphar.com>
	<20150309033405.GE13283@htj.duckdns.org>
	<54FDED43.4050908@gmail.com>
	<CAOviyah2KCu9K7D_H2zAf3LYbnj65P39YPmNamfA=-SSNq4hOg@mail.gmail.com>
	<54FED651.6040100@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54FED651.6040100-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Austin,

>>>> Does pids limit make sense in the root cgroup?
>>>
>>> I would say it kind of does, although I would just expect it to track
>>> /proc/sys/kernel/pid_max (either as a read-only value, or as an
>>> alternative way to set it).
>>
>> Personally, that seems unintuitive. /proc/sys/kernel/pid_max and the pids
>> cgroup controller are orthogonal features, why should they be able to
>> affect each other (or even be aware of each other)?
>
> I wouldn't consider them entirely orthogonal, the sysctl value is the
> limiting factor for the maximal value that can be set in a given pids
> cgroup.  Setting an unlimited value in the cgroup is functionally identical
> to setting it to be equal to /proc/sys/kernel/pid_max, and the root cgroup
> is functionally equivalent to /proc/sys/kernel/pid_max, because all tasks
> that aren't in another cgroup get put in the root.

While it is true that /proc/sys/kernel/pid_max would be functionally equivalent
to setting pids.max to the value of /proc/sys/kernel/pid_max (and thus the pids
root cgroup is functionally equivalent to the parent), it is untrue that the
sysctl value is the limiting factor on what "max" is defined as. "max" is
defined as the maximum possible pid_t value (it's really the only sane maximum
value, because trying to use /proc/sys/kernel/pid_max would be problematic due
to the fact that the maximum limit would keep changing and the line between
"max" and some arbitrary value would be blurred). In addition, the sysctl value
limits the number of pids in the system in a separate part of the kernel -- it
has nothing to do with cgroups and cgroups have nothing to do with it.

> My only thought is that having the file that would set the limit there might
> make things much simpler for software that expects the entire cgroup
> structure to be hierarchical.

The only valid value for pids.max in the root cgroup would be "max". And "max"
is defined as (PID_MAX_LIMIT + 1), not as the current setting of
/proc/sys/kernel/pid_max, because the only *real* maximum value of pid_t is
PID_MAX_LIMIT so the only reasonable way to represent "max" is a number greater
than that.

There is an issue with both of the behaviours you describe. The root-level
pids.max could either:

a) be read-only (which breaks the idea of it being "simpler" because now you
   have a special case where you can't write to the limit); or (even worse)
b) modify some other aspect of the kernel in a way that is unique compared to
   children of the root hierarchy (which IMO sounds like trouble).

In either of those two cases, the idea of it being "simpler" for software that
makes the (wrong) assumption that you can limit the global maximum number of
pids through the root cgroup is broken because it has either weird side effects
(b) or is just an odd feature (a).

--
Aleksa Sarai (cyphar)
www.cyphar.com
