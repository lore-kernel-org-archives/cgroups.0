From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: bind() call in cgroup's css structure
Date: Mon, 9 Apr 2012 11:09:32 -0700
Message-ID: <20120409180932.GB7522@google.com>
References: <4F82EB5C.7090003@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=giaHIIYB+lQbICZoPlwb0o4GPFUVtIT1E7EULpM3x94=;
        b=cvdcFH9n7v1S/eGDCc5xvXZJOR7mkM8XHL4FZQR7THI/6JOaFMvwB933PLYtPaz97x
         nHAmMROBTa3T8NQ5BN/sz/WJtCScTOJU5uoXkn+OPLFC+/i5LubOaLJenvQaEYq8b1z6
         cp/Cvt3dbaEYPNulPTwcdULaftPMBiHTO3Pz2oGJ+wW8g8zStU1iyMcS0R/BjGUsCboz
         d2axjCJa8JkNMxG4+qGNGJBjo4TOw8F1IyEj6qjS/VanC80bt+RdyvIckGYiDyUo0zoz
         sJ5KVBnvD+ptp39a//FQjZ7d5IUNg1iJpXfEQNBY97WHLKoVNaszU2s1PqrrT7Ny/iCT
         J+Kw==
Content-Disposition: inline
In-Reply-To: <4F82EB5C.7090003-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Glauber.

On Mon, Apr 09, 2012 at 10:59:56AM -0300, Glauber Costa wrote:
> During your cgroup refactor, I was wondering if you have any plans
> to get rid of the bind() callback that is called when hierarchies
> are moved?
>
> At least in tree, there seems to be no users for that.

I don't have any current plan for the callback but if it doesn't have
in-kernel user, I'd prefer to remove it.

> I actually planned to use it myself, to start or remove a jump label
> when cpuacct and cpu cgroups were comounted.

I see.

> Problem is, because we have some calls in the cpuset cgroup from
> inside the cpu hotplug handler, we end up taking the almighty
> cgroup_mutex from inside the cpu_hotplug.lock.

Yeah, those two are pretty big locks.

> jump labels take it in most arches through the get_online_cpus()
> function call. This means we effectively can't apply jump labels
> with the cgroup_mutex held, which is the case throughout the whole
> bind() call.
> 
> All that explained, I figured I might as well ask before I attempted
> a solution to that myself: as much as populate(), bind seems to be
> one of the overly complicated callbacks, designed for a scenario in
> which everything can come and go at will, which is something we're
> trying to fix.

I haven't read the code so this could be completely off but if this is
jump label optimization which can be made to work w/o it immediately
applied, maybe just punt it to a work item from the callback?  Note
that if cancellation is necessary for e.g. unbinding, it may
re-introduce locking dependency through flushing.

Thanks.

-- 
tejun
