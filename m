From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: add group_oom_kill memory event
Date: Fri, 10 Dec 2021 15:00:06 -0500
Message-ID: <YbOxxhuQ3a1Myd6v@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
References: <20211203162426.3375036-1-schatzberg.dan@gmail.com>
 <CALvZod6y+_O49jzuD9wLXncCEGCgun4f-uf_yBzYcsfEiH1WOQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yLZJvjoofMd+xeF11awcZvcV4Nn3U+z+fMY0sp4o/sA=;
        b=BjS8Vig6e8gQ4F0ZwsS3QThNYRE1ejxTIXemMKWA/aHL8GjyLyTAhPf/Yn4mdskwdf
         aGk3YFZk3sckvjvH/XRMg6GqWCMnutMR9SLLbsDTP1CWCGbMFyuGWDDSQPaHvMh5uDPY
         z3K0J/UJ88uHGHrSEaJG1bGYB13RPUe6ug+5eyDprQAY+8kISqRD/Kokt2j8/3EEjF+w
         Ij8EsV1Mq18LEA8wgQtDhSBN+KwwoFXMxKkv0Z2fiFWa5YOwIw2jy2ERGW9Ua+or7G2V
         K+1YH+vLDsvdwnJNUccX+KEsh3seflpRZHOnjBrh8z4QksUW5Fl5x9DJB9B0f+zojjUf
         OS7Q==
Content-Disposition: inline
In-Reply-To: <CALvZod6y+_O49jzuD9wLXncCEGCgun4f-uf_yBzYcsfEiH1WOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, Dec 03, 2021 at 04:45:54PM -0800, Shakeel Butt wrote:
> On Fri, Dec 3, 2021 at 8:24 AM Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > Our container agent wants to know when a container exits if it was OOM
> > killed or not to report to the user. We use memory.oom.group = 1 to
> > ensure that OOM kills within the container's cgroup kill
> > everything. Existing memory.events are insufficient for knowing if
> > this triggered:
> >
> > 1) Our current approach reads memory.events oom_kill and reports the
> > container was killed if the value is non-zero. This is erroneous in
> > some cases where containers create their children cgroups with
> > memory.oom.group=1 as such OOM kills will get counted against the
> > container cgroup's oom_kill counter despite not actually OOM killing
> > the entire container.
> >
> > 2) Reading memory.events.local will fail to identify OOM kills in leaf
> > cgroups (that don't set memory.oom.group) within the container cgroup.
> >
> > This patch adds a new oom_group_kill event when memory.oom.group
> > triggers to allow userspace to cleanly identify when an entire cgroup
> > is oom killed.
> >
> > Signed-off-by: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> So, with this patch, will you be watching oom_group_kill from
> memory.events or memory.events.local file for your use-case?
> 
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

We will watch from memory.events.local. If containers want to
construct their own child cgroups and allow for group oom to occur
inside, that's fine - a future container exit should not result in us
claiming the container was OOM killed. If the container exits and
memory.event.local shows oom_group_kill > 0 then we know the container
was OOM killed.
