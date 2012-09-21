From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] cgroup TODOs
Date: Fri, 21 Sep 2012 14:40:02 -0700
Message-ID: <20120921214002.GA7694@google.com>
References: <20120913205827.GO7677@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dscS66GFIsmEgGdI31n/K0jMVH41tuKMX0j3EIJJFSY=;
        b=vQf/o5zI90/E4c4inNF/EQm7gHMv/VjHJsj0cEig9P3uFF1aQancDYali3M4JclmGK
         rw2ASHwgdf3uMXAjD4FOeO/3LANsE8nfXkJlrbQpGQ/LIVi4ZbVM5hXIRxXrBd/Rvj57
         Ftwva/KLeAtS8OfkPiVWCqSEduY7cK5m4Isnt+gczWkacivqZMgzpgvdXXhbUnUSCOkG
         naqm1RppU6I2uf1epUEEHdiFY79jXPJsJNU3cZNDzRGi49Goo1PwNgPSw0b5tFYjwex2
         2RPm8paTTbcF6eDzEJwGzEYuPE7Jtz+ijQLCG5v8yX9TXMqrI+hWdiuaQaPfF3+YIhdz
         CQLA==
Content-Disposition: inline
In-Reply-To: <20120913205827.GO7677-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

On Thu, Sep 13, 2012 at 01:58:27PM -0700, Tejun Heo wrote:
> 7. Misc issues
> 
>   * Sort & unique when listing tasks.  Even the documentation says it
>     doesn't happen but we have a good hunk of code doing it in
>     cgroup.c.  I'm gonna rip it out at some point.  Again, if you
>     don't like it, scream.
> 
>   * At the PLC, pjt told me that assinging threads of a cgroup to
>     different cgroups is useful for some use cases but if we're to
>     have a unified hierarchy, I don't think we can continue to do
>     that.  Paul, can you please elaborate the use case?
> 
>   * Vivek brought up the issue of distributing resources to tasks and
>     groups in the same cgroup.  I don't know.  Need to think more
>     about it.

* Update docs.

* Clean up cftype->read/write*() mess.

* Use sane fs event mechanism.

* Drop userland helper based empty notification.  Argh...

-- 
tejun
