From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: Add generic cgroup subsystem permission checks
Date: Wed, 5 Oct 2016 12:16:48 -0700
Message-ID: <CALAqxLWUGmMWBu54uRgK2tn9EuCRSDMPHewDmB5DEP+c-WaJEQ@mail.gmail.com>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
 <1475556090-6278-2-git-send-email-john.stultz@linaro.org> <20161005190909.GA31873@dtor-ws>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=4aMiZ07UzUe2IJfTSFREY/dllEV9ZQlPNjeWJnYoDp8=;
        b=WJn8kGuCP9JZX5uOsqOaPCTkCIQGqhUFjcqtKIS1s1qtyeKP1jF5SQrirnyw0e0rLO
         P08qL6t6sYKSRGSsVINPaLyvlj5c81HaP8OHidayBUtsAsm3xnPErMyqcoIIIITE0hzB
         2Gh142amHsAYU9N2CTxTTP5rDVaBOFaOTPXkU=
In-Reply-To: <20161005190909.GA31873@dtor-ws>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ricky Zhou <rickyz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

On Wed, Oct 5, 2016 at 12:09 PM, Dmitry Torokhov
<dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> [ Some comments are form Ricky Zhou <rickyz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, some from
> myself ]
> On Mon, Oct 03, 2016 at 09:41:29PM -0700, John Stultz wrote:
>> From: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>
[snip]
>> +
>> +             cset = task_css_set(task);
>
> Do we need to take css_set_lock here? If not, why?
>
>> +             list_add(&cset->mg_node, &tset.src_csets);
>> +             ret = cgroup_allow_attach(dst_cgrp, &tset);
>> +             list_del(&tset.src_csets);
>
> This should be
>
>                 list_del_init(&cset->mg_node);
>
> since you are deleting task's cset from the tset list, not other way
> around. It only happen to work because there is exactly 1 member in
> tset.src_csets and list_del done on it is exactly list_del_init on the
> node, so you are not leaving with uncorrupted mg_node in task's cset.
>
>> +             if (ret)
>> +                     ret = -EACCES;
>> +     }
>>
>>       if (!ret && cgroup_on_dfl(dst_cgrp)) {
>>               struct super_block *sb = of->file->f_path.dentry->d_sb;
>
> Isn't this, generally speaking, racy? We take current task's cset and
> check if we have rights to move it over.  But we do not have any locking
> between check and actual move, so can the cset change between these 2
> operations?
>
> And if cset can't really change and it is only 1 task, then why do we
> bother with forming taskset at all? Can we make allow_attach take just
> the target task argument?

After Tejun's feedback, I've tried reworking the same functionality in
a much simpler fashion by introducing a new capability bit.
https://lkml.org/lkml/2016/10/4/479

I believe that approach doesn't have the drawbacks you've pointed out
here, but would appreciate your input on it.

As for your feedback on this patch, I'll have to look into it a bit,
as I don't have good answers for you for you right off.  But these do
seem like valid concerns and since the Android common.git kernels are
using the code I submitted here, this issues likely need to be fixed
there.

thanks
-john
