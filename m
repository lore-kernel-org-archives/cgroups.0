From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v3 1/5] cgroup: introduce cgroup.kill
Date: Mon, 10 May 2021 09:43:03 -0700
Message-ID: <YJlilxwEoZS01+RE@carbon.DHCP.thefacebook.com>
References: <20210508121542.1269256-1-brauner@kernel.org>
 <874kfaha3t.fsf@meer.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=rrhlUjnD6bW9ponz5bLx07YD8kJYtj+nkd59IW5qQh0=;
 b=eyOkPaWU8zIt3GEf1JBDYLZRNakId2LVFo1YjobMDEkr4PeD5TKDW+gXjPpOuPPRigCR
 TRMM/dEoZulAslHh2QkHKZs5ESd34hRUcIyNiQJr9u0WFraFPbtwUPxYY89dt4RheSdC
 rppMBZDRD/e7A86tR7mvq6pJ9tR7VNHphp0= 
Content-Disposition: inline
In-Reply-To: <874kfaha3t.fsf-K7Oyngvb+qHk1uMJSBkQmQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

On Mon, May 10, 2021 at 09:39:02AM -0600, Jonathan Corbet wrote:
> Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
> 
> > Introduce the cgroup.kill file. It does what it says on the tin and
> > allows a caller to kill a cgroup by writing "1" into cgroup.kill.
> > The file is available in non-root cgroups.
> 
> So I feel like I'm missing something fundamental here...perhaps somebody
> can supply a suitable cluebat.  It seems inevitable to me that, sooner
> or later, somebody will surely wish that this mechanism could send a
> signal other than SIGKILL, but this interface won't allow that.  Even if
> you won't want to implement an arbitrary signal now, it seems like
> defining the interface to require writing "9" rather than "1" would
> avoid closing that option off in the future.
> 
> I assume there's some reason why you don't want to do that, but I'm to
> slow to figure out what it is...?

I think the consensus was that most signals are a process/thread-level thing
and are rarely sent to more than one process, so sending them to all processes
in a cgroup is never required. So far nobody came with any real-life use case
behind SIGKILL. SIGSTOP/SIGCONT could be that case, but the cgroup v2 freezer
is doing virtually the same and eliminates this need.

Even SIGTERM which is often used before SIGKILL as a grateful termination
attempt has to be sent to a proper process in the cgroup (e.g. container-level
init or the main process in the workload).

If a new case will arise, it will be possible to introduce a new interface
file, but it looks very unlikely that there will be many such cases to justify
a more generic interface. On the other side keeping it boolean makes it more
consistent with the rest of the cgroup v2 api.

Thanks!
