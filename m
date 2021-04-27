From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: add cgroup.signal
Date: Tue, 27 Apr 2021 10:29:00 -0400
Message-ID: <YIgfrP5J3aXHfM1i@slm.duckdns.org>
References: <20210423171351.3614430-1-brauner@kernel.org>
 <YIcOZEbvky7hGbR1@blackbook>
 <20210427093606.kygcgb74otakofes@wittgenstein>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UMKXl6Gx8KBkOWI3gUemjqjUZmjyHB6+YGIl3pR8iV4=;
        b=UjHG5sqhBTRbA7JGAGdLtiLjXzdXOPVB91HOJnd9Af9EJt2ivK+cpHpMc3DF1jMCYh
         cscFht7exVuPnY5gdsxHMWXu9ox7qddVgaVG/Rwlb6lSMgX+iH0bZe/tY7rnHN6paJDg
         v8fFOwLI0CKePjTVtutLeCXTUqPuJAkf+xxTozM+HCfL4a6beD8aDNgdnQjUyNwKQqKq
         vtqDsHr1w6MShr+Ak4P9NT3ZzOCrG05utQj1creMV5Ltll51StvIU1J3PYRElodrEv+j
         OaExalWKtGxF5yUOogdCsGVH1IFYYnQrEQBF/BD1uy+4fCeIhwOL0wVzYhVGCyx2JzvG
         IpHA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210427093606.kygcgb74otakofes@wittgenstein>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Apr 27, 2021 at 11:36:06AM +0200, Christian Brauner wrote:
> I thought about this optimization but (see below) given that it should
> work with threaded cgroups we can't only walk thread-group leaders,
> afaiu.

CSS_TASK_ITER_PROCS|CSS_TASK_ITER_THREADED iterates all thread group leaders
in the threaded domain and is used to implement cgroup.procs. This should
work, right?

> > > @@ -4846,6 +4916,11 @@ static struct cftype cgroup_base_files[] = {
> > > +	{
> > > +		.name = "cgroup.signal",
> > > +		.flags = CFTYPE_NOT_ON_ROOT,
> > > +		.write = cgroup_signal_write,
> > 
> > I think this shouldn't be visible in threaded cgroups (or return an
> > error when attempting to kill those).
> 
> I've been wondering about this too but then decided to follow freezer in
> that regard. I think it should also be fine because a kill to a thread
> will cause the whole thread-group to be taken down which arguably is the
> semantics we want anyway.

I'd align it with cgroup.procs. Killing is a process-level operation (unlike
arbitrary signal delivery which I think is another reason to confine this to
killing) and threaded cgroups should be invisible to process-level
operations.

Thanks.

-- 
tejun
