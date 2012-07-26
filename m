From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: containers and cgroups mini-summit @ Linux Plumbers
Date: Thu, 26 Jul 2012 03:57:09 -0700
Message-ID: <877gtq4woq.fsf@xmission.com>
References: <4FFDF321.4030103@openvz.org> <500FD022.6000608@parallels.com>
	<877gtr6uo5.fsf@xmission.com> <50110AE6.2080701@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50110AE6.2080701-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> (Glauber Costa's message of
	"Thu, 26 Jul 2012 13:16:22 +0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Kir Kolyshkin <kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rohit Seth <rohitseth-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>, Dave Kleikamp <dave.kleikamp-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Maxim Patlasov <MPatlasov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> writes:

> On 07/26/2012 07:57 AM, Eric W. Biederman wrote:
>> Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> writes:
>> 
>>> I just came up with the following preliminary list of sessions:
>>>
>>> http://wiki.linuxplumbersconf.org/2012:containers
>>>
>>> Since people mostly said what they wanted to talk about, but without
>>> extensive descriptions, I took the liberty of coming up with a small
>>> text for each in the blueprints. If you believe this is inaccurate, or
>>> would like to see it extended (although I personally don't see the point
>>> about going into very formal and deep details here), just let me know
>>> and I will edit it.
>>>
>>> This is all still subject to change.
>> 
>> Something that just came up recently and worth looking at if it hasn't
>> already be resolved.
>> 
>> The network namespace, the user namespace, and the memory control group
>> are not meshing well.
>> 
>> In particular we need some additional checks for an unprivileged user
>> who can set tcp_mem.  If you are the creator of a network namespace you
>> should at least be able to set the values down.  I don't know at all
>> about increasing the amount of memory consumed by the tcp stack.
>
> This is between the user namespace and net namespace only, right ?
>
> To be quite honest, I haven't looked thoroughly at UNS after your last
> work. How do you yourself believe this should be?

I looked a little deeper and there are a few more places in the
networking stack besides tcp_mem, that are setting memory limits
that unprivileged users should not be able to touch.

What I would expect one of.
- A global limit accross network namespaces that the per netns limit
  can not allow you to escape.
- Something like rlimits where the limit can be reduced but not
  increased.
- capability checks that prevent anyone except the global root from
  changing the value (of course this has the problem that creating
  a fresh network namespace allows memory limit escaping).

The driving factor is that in the 3.7 time frame it will be possible to
create user namespaces and network namespaces as unprivileged users.  So
we have to be careful that we setup the limits so that the global root
on the host can set limits that are not trivially overridden.

>> The non-nesting nature of memory control groups with respect to the
>> network stack also seems very bizarre.
>
> Correction:
>
> The non-nesting nature of memory control groups is very bizarre. No need
> for modifiers. It does support nesting, though. Just that it is
> selectable, and not the default. But there is work in progress to change
> that.

Which leads to another bit of fun.  It is possible to create containers
in containers in containers, which has interesting implications for
control groups in general, and especially interesting implications for
control groups that don't nest.

Eric
