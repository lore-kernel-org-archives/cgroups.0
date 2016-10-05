From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Add a allow_attach policy for Android
Date: Wed, 5 Oct 2016 12:18:17 -0700
Message-ID: <CALAqxLXxFcLWCbSHiFFy0OEDgbnJY+2OLbgLYvypDwoQMuapHg@mail.gmail.com>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
 <1475556090-6278-3-git-send-email-john.stultz@linaro.org> <20161005191056.GB31873@dtor-ws>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=9szoFz/YfGW2NYKs37DDbDAwdW+/XBQKaSg1NlD44OA=;
        b=iovFx/qZvm4gIrlOLov7anXTbGhGO/YrkMvr4HGzGpjIBWdsOsCEhdTlCn4jMKLzbg
         IOI3Odl/fHGTUDON+7XVQlHvFQRAubCzY7uxlnONGFpSQRgDFSS35AazpvMKEVMmhnnT
         LPOo+odhHI+aL8hQDrkkJ/gT+gxhWjd6IF6r0=
In-Reply-To: <20161005191056.GB31873@dtor-ws>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ricky Zhou <rickyz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

On Wed, Oct 5, 2016 at 12:10 PM, Dmitry Torokhov
<dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Oct 03, 2016 at 09:41:30PM -0700, John Stultz wrote:
>> +#ifdef CONFIG_CGROUP_NICE_ATTACH
>> +int cgroup_nice_allow_attach(struct cgroup_taskset *tset)
>> +{
>> +     const struct cred *cred = current_cred(), *tcred;
>> +     struct task_struct *task;
>> +     struct cgroup_subsys_state *css;
>> +
>> +     if (capable(CAP_SYS_NICE))
>> +             return 0;
>> +
>> +     cgroup_taskset_for_each(task, css, tset) {
>> +             tcred = __task_cred(task);
>
> __task_cred() requires RCU lock (courtesy Ricky Z).

Again, hopefully this isn't an issue with the new approach, but for
the short term I'll see if we can get this fixed in the android tree.

Thanks again for your careful review!
-john
