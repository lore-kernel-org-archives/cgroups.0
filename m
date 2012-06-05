From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [Devel] Re: [PATCH] allow a task to join a pid namespace
Date: Tue, 5 Jun 2012 14:00:00 +0400
Message-ID: <4FCDD8A0.1070608@parallels.com>
References: <1338816828-25312-1-git-send-email-glommer@parallels.com> <4FCDD315.502@free.fr> <4FCDD346.9090008@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FCDD346.9090008-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, kir-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Michael-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

On 06/05/2012 01:37 PM, Glauber Costa wrote:
> On 06/05/2012 01:36 PM, Daniel Lezcano wrote:
>> On 06/04/2012 03:33 PM, Glauber Costa wrote:
>>> Currently, it is possible for a process to join existing
>>> net, uts and ipc namespaces. This patch allows a process to join an
>>> existing pid namespace as well.
>>>
>>> For that to remain sane, some restrictions are made in the calling
>>> process:
>>>
>>> * It needs to be in the parent namespace of the namespace it wants to
>>> jump to
>>> * It needs to sit in its own session and group as a leader.
>>>
>>> The rationale for that, is that people want to trigger actions in a
>>> Container
>>> from the outside. For instance, mainstream linux recently gained the
>>> ability
>>> to safely reboot a container. It would be desirable, however, that this
>>> action is triggered from an admin in the outside world, very much like a
>>> power switch in a physical box.
>>>
>>> This would also allow us to connect a console to the container,
>>> provide a
>>> repair mode for setups without networking (or with a broken one), etc.
>>
>> Hi Glauber,
>>
>> I am in favor of this patch but I think the pidns support won't be
>> complete and some corner-cases are not handled.
>>
>> May be you can look at Eric's patchset [1] where, IMO, everything is
>> taken into account. Some of the patches may be already upstream.
>>
>> Thanks
>> -- Daniel
>
> I don't remember seeing such patchset in the mailing lists, but that
> might be my fault, due to traffic...
>
> I'll take a look. If it does what I need, I can just drop this.
>

Ok. In a quick look, it does not seem to go all the way. This is just by 
reading, but your reboot patch, for instance, is unlikely to work with 
that, since if it doesn't alter pid->level, things like task ns_of_pid 
won't work.

Running the test scripts I wrote for my testing of that patch also 
doesn't seem to produce the expected result:

after doing setns, the pid won't show up in that namespace.

But I can work on top of that tree, may save a lot of work.

Eric, what are your plans for merging the content of that tree ?
