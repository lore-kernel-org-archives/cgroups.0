From: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct
 stats
Date: Wed, 30 May 2012 13:24:32 +0200
Message-ID: <1338377072.26856.263.camel@twins>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
	   <1338371317-5980-4-git-send-email-glommer@parallels.com>
	  <1338374041.26856.241.camel@twins> <4FC5F7A0.2000201@parallels.com>
	 <1338374628.26856.244.camel@twins> <4FC5FA20.50301@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC5FA20.50301-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Wed, 2012-05-30 at 14:44 +0400, Glauber Costa wrote:
> But I don't really parse what you mean by "make the files go away". We 
> have just one file, with multiple entries. The entries are in key:value 
> form, so I don't see a huge problem in having some entries disappearing.
> 
> As a matter of fact, this is exactly what happens in /proc/stat when you 
> offline a cpu: the correspondent line will stop showing up.

Oh, I thought you had a file per cpu.

If you have content per cpu, this all might become a problem with 4096
cpus, that's bound to overflow the page of output space?
