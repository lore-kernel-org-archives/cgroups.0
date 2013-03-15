From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 1/4] dev_cgroup: keep track of which cgroup is the root
 cgroup
Date: Fri, 15 Mar 2013 18:43:46 +0400
Message-ID: <514333A2.5060408@parallels.com>
References: <1363338823-25292-1-git-send-email-glommer@parallels.com> <1363338823-25292-2-git-send-email-glommer@parallels.com> <20130315140743.GC3782@sergelap>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130315140743.GC3782@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On 03/15/2013 06:07 PM, Serge Hallyn wrote:
> Quoting Glauber Costa (glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org):
>> Most of the other subsystems already keep track of that in some way.  We
>> will do that internally and provide a test to determine whether or not
>> our task is in a device cgroup that is not the root one. We can relax
>> some of our checks in that case, trusting that whoever set device cgroup
>> rules will be responsible to control access to their devices.
>>
>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> 
> Patch looks fine.  AFAIK we're still waiting on Aristeu's patchset to
> hit upstream.  As your patches are simpler I'd prefer, if there is
> churn, for yours to be refactored than his.
> 
I have no problem with that. There is also a small build issue here that
needs to be fixed. If you allow me, with my guarantees that the patch
will be preserved in spirit I will keep your ack after any refactoring =)
