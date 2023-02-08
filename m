From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] sched/psi: iterate through cgroups directly
Date: Wed, 8 Feb 2023 22:57:14 +0100
Message-ID: <Y+QaunjOmvJf3NTU@blackbook>
References: <20230208161654.99556-1-ryncsn@gmail.com>
 <20230208161654.99556-3-ryncsn@gmail.com>
 <20230208172956.GF24523@blackbody.suse.cz>
 <Y+P17OVZZWVpYIb0@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675893437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R2mYp1Col1qvN/xaX0VnWrTW38RiNgAM0en+DKPJ/Mc=;
        b=tV14ilvCkDpWV8xRNwzMQDPZSjnAg+2lNdLsFTQh7F++domXSJfT/KBw44/SU8cTabNdXf
        3YGlGIDYBNgdX2Vmx2dV0c6RKLxrAGEeKVtAxV00qsjBSEeVvnK39r7pYqbTXEq3XJkumd
        7VQy9xDVfrBv5ZwR3YnlvOVMhUidcHM=
Content-Disposition: inline
In-Reply-To: <Y+P17OVZZWVpYIb0-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Feb 08, 2023 at 02:20:12PM -0500, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> Hm, I don't think it does. It sets up *iter to point to the parent for
> the _next() call, but it returns task_dfl_cgroup()->psi. The next call
> does the same: cgroup = *iter, *iter = parent, return cgroup->psi.

You are right.

> It could be a bit more readable to have *iter always point to the
> current cgroup - but no strong preference either way from me:

A casually reading half-brain finds this more idiomatic :)

I just hope the "preloading" of the parent via iter isn't crucial to the
performance change.

Kairui, I like this reorganization and its effect!

Michal
