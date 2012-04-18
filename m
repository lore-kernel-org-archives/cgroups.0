From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 4/5] expose fine-grained per-cpu data for cpuacct stats
Date: Wed, 18 Apr 2012 13:14:48 -0300
Message-ID: <4F8EE878.7040007@parallels.com>
References: <1334010315-4453-1-git-send-email-glommer@parallels.com> <1334010315-4453-5-git-send-email-glommer@parallels.com> <CAFj3OHUzKDdS_3LrnTk+XaRVt+fGxWkvmh9cjv88Dt4n8Q39MA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFj3OHUzKDdS_3LrnTk+XaRVt+fGxWkvmh9cjv88Dt4n8Q39MA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, lxc-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org

On 04/18/2012 09:30 AM, Sha Zhengju wrote:
> On Mon, Apr 9, 2012 at 6:25 PM, Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>> >  The cpuacct cgroup already exposes user and system numbers in a per-cgroup
>> >  fashion. But they are a summation along the whole group, not a per-cpu figure.
>> >  Also, they are coarse-grained version of the stats usually shown at places
>> >  like /proc/stat.
>> >
>> >  I want to have enough cgroup data to emulate the /proc/stat interface. To
>> >  achieve that, I am creating a new file "stat_percpu" that displays the
>> >  fine-grained per-cpu data. The original data is left alone.
>> >
>> >  The format of this file resembles the one found in the usual cgroup's stat
>> >  files. But of course, the fields will be repeated, one per cpu, and prefixed
>> >  with the cpu number.
>> >
>> >  Therefore, we'll have something like:
>> >
>> >    cpu0.user X
>> >    cpu0.system Y
>> >    ...
>> >    cpu1.user X1
>> >    cpu1.system Y1
>> >    ...
>> >
> Why not show the all-cpu data together with the per-cpu one?  I think
> the total one
> is an usual concern in most cases.
>
Because that is a trivial operation that can be done in userspace.

In general, I see no value in formatting this file any further if we'll 
have to get to userspace for the final solution anyway.
