From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] perf: remove include of cgroup.h from perf_event.h
Date: Wed, 6 Mar 2013 11:31:20 +0100
Message-ID: <20130306103120.GA16827@gmail.com>
References: <513568A0.6020804@huawei.com>
 <CABPqkBTTn6E=FS6WiCWopcScHDVa9F6bu5-pw8Ma7TK2aunkvQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=0/qmPdoZ+KP6Ab8B/Tna6J/tT8/IdO1paosC98wb1Js=;
        b=TnrOzcpCaG4LJLf+dtGt8Kd6hzuvtl8ZSVh4i+C7LrPe6MzyHAh4h2i8+tmBMRmfjB
         +r+l63c/I6bDo2O3I6e3uP+czzi4gw5pXzmk5Z32ze8T8Tfa4WvIfTtHbRnRvIvwu19f
         8Xdj8vao6wI4g/zMU/wjcZZKO5ydEhfpaY/egrhD9bGyBbk/ZJ8WUohkng5WJQOz1wKT
         9NIix8lD0HjntbTtRzDcPc6dBSKxpYbeVppKzY/lpn78gV7EfLZWluJ6qw0Gl0ouFoeL
         i2YKFFNMO3+n/j9pTn2fbjtSGkJszgAr3tIRM5v7CFkJ0rVYWKJx4F20QxJGghlMY3e2
         RKFw==
Content-Disposition: inline
In-Reply-To: <CABPqkBTTn6E=FS6WiCWopcScHDVa9F6bu5-pw8Ma7TK2aunkvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephane Eranian <eranian-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


* Stephane Eranian <eranian-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> > - * This is a per-cpu dynamically allocated data structure.
> > - */
> > -struct perf_cgroup_info {
> > -       u64                             time;
> > -       u64                             timestamp;
> > -};
> > -
> > -struct perf_cgroup {
> > -       struct                          cgroup_subsys_state css;
> > -       struct                          perf_cgroup_info *info; /* timing info, one per cpu */
> > -};
> > -#endif
> > -
> > +struct perf_cgroup;
> 
> The problem is that you have struct perf_cgroup in the struct perf_event 
> structure. Today, this field is not referenced outside of kernel/events/core.c But 
> it is available outside this file. If someday the field is reference, your changes 
> will have to do reverted. So I am wondering what is the point of the change right 
> now?

It's standard practice to not define the type for task_struct or other kernel 
subsystems.

For example slab caches can be created via kmem_cache_create() anywhere in the tree, 
but the internal structure is only known to the SLAB subsystem.

Thanks,

	Ingo
