From: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Tue, 26 Nov 2013 12:45:27 -0800
Message-ID: <CAO_Rewao9smJpi5H1hZBVv3J=CHEathFP7zWSeu6wuXhVfTsoQ@mail.gmail.com>
References: <20131125224335.GA15481@mail.hallyn.com> <CAO_RewZGWARUafKzDc_t3G5OedGtEPTZgB2VYeHHiKSSrja8fA@mail.gmail.com>
 <20131126161246.GA23834@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=qWWVX4yTCLDNUPVGBKqvuVl2lyLqcss62ipWLvZR8J4=;
        b=LegT9HLUX074NMSgheHM0gHy2sZhNapl0vi9f4S020TdBySeORrnABfRzk5bYRUg7p
         uH60rxG3fiLs4cfnMq4O0LHce7Y0QO2waFW4bj3nLx0kka+8CHQnhoBvoDBzqZvgxZrR
         EOBu+yqGwZw9yXgX0ji0vlcKKn//3kh5CRqKbp9eIp0xTWlKHMubqKCAyeY5Hh4k5CFI
         PjsiDBHWlFv0FlJva72dxedC6I/9BnoA++zzka4eDG5XPKwHI2zT3q0EUF60CVi/nf4E
         mkDYAjksVNuYih5xj1UwQ+iEZouWH/fFW9jj0UGq7Vp+xCm/TuEVPE8H8r+enjOLE8KJ
         bJaw==
In-Reply-To: <20131126161246.GA23834-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?St=E9phane_Graber?= <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>

On Tue, Nov 26, 2013 at 8:12 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
>> What are the requirements/goals around performance and concurrency?
>> Do you expect this to be a single-threaded thing, or can we handle
>> some number of concurrent operations?  Do you expect to use threads of
>> processes?
>
> The cgmanager should be pretty dumb, so I would expect it to be
> quite fast.  I don't have any specific perf goals though.  If you
> have requirements I'm very interested to hear them.  I should be
> able to tell pretty soon how far short I fall.

If we're limiting this to write traffic only, I think our perf goals
are fairly relaxed.  As longs as you don't develop it to preclude
threading or multi-processing, we can adapt later.  I would like to
see at least a mention to this effect.  We also need to beware DoS
(accidental or otherwise) - perhaps we should force round-robin
service of pending-requests, or something.

> By default I'd expect to run with a single thread, but I don't
> imagine one thread can serve a busy 1024-cpu system very well.
> Unless you have guidance right now, I think I'd like to get
> started with the basic functionality and see how it measures
> up to your requirements.  I should add perf counters from the
> start so we can figure out where bottlenecks (if any) are and
> how to handle them.
>
> Otherwise I could start out with a basic numcpus/10 threadpool
> and have the main thread do socket i/o and parcel access
> verification and vfs work out to the threadpool, but I'd rather
> first know where the problems lie.

Agree.  Correct first, then fast :)

>> Can you talk about logging - what and where?
>
> When started under upstart, anything we print out goes to
> /var/log/upstart/cgmanager.log.  Would be nice to keep it
> that simple.  We could log requests by r to do something
> it is not allowed to do, but it seems to me the failed
> attempts cause no harm, while the potential for overflowing
> logs can.

I agree that we don't want to overflow logs.

> Did you have anything in mind?  Did you want logging to help
> detect certain conditions for system optimization, or just
> for failure notices and security violations?

When something goes amiss, we have to ty to figure out what happened -
how far did a request get?  Logging every change is probably
important.  Logging failures could be downsampled and rate-limited,
something like 1 failure log per second or something.

>> How will we handle event_fd?  Pass a file-descriptor back to the caller?
>
> The only thing currently supporting eventfd is memory threshold,
> right?  I haven't tested whether this will work or not, but
> ideally the caller would open the eventfd fd, pass it, the
> cgroup name, controller file to be watched, and the args to
> cgmanager;  cgmanager confirms read access, opens the
> controller fd, makes the request over cgroup.event_control,
> then passes the controller fd back to the caller and closes
> its own copy.
>
> I'm also not sure whether the cgroup interface is going to be
> offering a new feature to replace eventfd, since it wants
> people to stop using cgroupfs...  Tejun?
>
>> That's all I can come up with for now.
