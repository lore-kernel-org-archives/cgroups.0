From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 0/2] Another pass at Android style loosening of
 cgroup attach permissions
Date: Tue, 4 Oct 2016 15:38:38 -0400
Message-ID: <20161004193838.GH4205@htj.duckdns.org>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
 <20161004161630.GC4205@htj.duckdns.org>
 <CALAqxLUPMxpngbZCSFW9wS+LbZJbfSUxTDEXX2x-FUmuN4H+QQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hqpWW+gnuhqPy/FD9PvbttxqojHc0tPqrUr+yjcIl1o=;
        b=JnHnMqPGQzkSY7pXsIpsbJuDOqKid6tVa9jRzfQ7CN9QiAn16BaJ1JgELnSa8N4tkx
         fZlm0U3Y/nPa93jc7CIbdhsyb6FyWQhRESWATQ3bLRlsrDueNkGLBZddJSanOkpnBwD5
         FbEYiPDdrLc0FIBUxshinkbCXI8X8Fwp5TDmhdCEIzFyKxNZ6B1nbajusc8OllO4o03A
         mD+zeeccu1wtxziSyggMkxDSF9sY+Z5riVNY0Q+iB5XTUw288VrRLxEir3eWoCRz4Mgl
         KbS9dk0wuqgl/coQf443LwRuuarUoaQRvZwDnrC9dlMqIx4b8yE59Qar91W41XvTKsfq
         XU5w==
Content-Disposition: inline
In-Reply-To: <CALAqxLUPMxpngbZCSFW9wS+LbZJbfSUxTDEXX2x-FUmuN4H+QQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Hello, John.

On Tue, Oct 04, 2016 at 11:01:12AM -0700, John Stultz wrote:
> So to make sure I understand your suggestion, you're suggesting the
> cgroupfs files like:
> cpuctrl/tasks,
> cpuctrl/bg_non_interactive/tasks,
> cpuset/foreground/tasks,
> cpuset/background/tasks,
> etc
> use ACL permissions to specify the specific uids that can write to
> them? I guess this would be conceptually similar to just setting the
> owner to the system task, no?  Though I'm not sure that would be

Yeah, finer grained but essentially just giving write perms.

> sufficient since it would still fail the
> cgroup_procs_write_permission() checks. Or are you suggesting we add
> extra logic to make the file owner uid as sufficient to change other
> tasks?

Hah, now I'm not sure how this is supposed to work inside a userns as
it's checking against GLOBAL_ROOT_UID.  cc'ing Serge.  Serge, can you
please have a look?

But back on subject, yeah, I think a capability based approach is
better here too.  No idea how difficult it is to add a new CAP but I
think it's worth trying.  Can you please spin up a patch?

Thanks!

-- 
tejun
