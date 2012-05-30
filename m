From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 4/6] add a new scheduler hook for context switch
Date: Wed, 30 May 2012 16:07:57 +0400
Message-ID: <4FC60D9D.8080705@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>  <1338371317-5980-5-git-send-email-glommer@parallels.com> <1338376851.26856.260.camel@twins>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338376851.26856.260.camel@twins>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On 05/30/2012 03:20 PM, Peter Zijlstra wrote:
> /me cries a little.. I was hoping to fix put_prev_task.. see:
>
>    https://lkml.org/lkml/2012/2/16/487
>
> (I've actually got a 4 patch split out of that if anybody cares)
>
> Its just one of those things stuck behind the -ENOTIME tree :/
>
> The plan is to 'merge' put_prev_task and pick_next_task into one and
> avoid a lot of the up-down walking.
>
> You just added a constraint for always having to walk the entire thing
> up -- cgroups is too damn expensive already, we should be trimming this
> nonsense not bloating it.

if they are merged, then I don't need a new hook.

Do you have plans to do it? I'd be happy to continue the work if you 
lack the time, since I am directly interested in the functionality.

