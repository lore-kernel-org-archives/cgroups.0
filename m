From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 2/2] cgroup: Add a allow_attach policy for Android
Date: Thu, 6 Oct 2016 15:52:49 -0700
Message-ID: <20161006225249.GB25887@dtor-ws>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
 <1475556090-6278-3-git-send-email-john.stultz@linaro.org>
 <20161005191056.GB31873@dtor-ws>
 <CALAqxLXxFcLWCbSHiFFy0OEDgbnJY+2OLbgLYvypDwoQMuapHg@mail.gmail.com>
 <20161006224351.GA25887@dtor-ws>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gi99sQQMkqsGxp2ehMXZmjU0BzAKFu49ZW0qXfAYeuA=;
        b=jeOCtAd/T+JhpDn9exfYBKOFsWLiVeQPe1b4RYE14YTSOp9LtmL+WgCAFVejvTgKBx
         6DRT7OURpAbBW7heHewbjZI5lSVwqMB/HTSVAwylr/51/JJ3S8P2TiVvaWkk45+uyCB8
         uknRe9rnnXBkLfi44DoHuKQbMyrxp1PmGBmMLZW+0VPooBS+mX7Yw7rxWQdK5ZmF/w8C
         UVp7hdgSfUulpGk3tDUF/GsAosFpHaX3OAd2DOVBwZsQaMqL++/OaHDCj3iLzmtcK01G
         3r1wKaeHTHFFKVUZaSf+aNul1D921iXIkyKgME7foVvY6ec1VR1RlU81gTkE/g3/pikc
         6W1g==
Content-Disposition: inline
In-Reply-To: <20161006224351.GA25887@dtor-ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Rom Lemarchand <romlem@android.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, Ricky Zhou <rickyz@chromium.org>

On Thu, Oct 06, 2016 at 03:43:51PM -0700, Dmitry Torokhov wrote:
> On Wed, Oct 05, 2016 at 12:18:17PM -0700, John Stultz wrote:
> > On Wed, Oct 5, 2016 at 12:10 PM, Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > > On Mon, Oct 03, 2016 at 09:41:30PM -0700, John Stultz wrote:
> > >> +#ifdef CONFIG_CGROUP_NICE_ATTACH
> > >> +int cgroup_nice_allow_attach(struct cgroup_taskset *tset)
> > >> +{
> > >> +     const struct cred *cred = current_cred(), *tcred;
> > >> +     struct task_struct *task;
> > >> +     struct cgroup_subsys_state *css;
> > >> +
> > >> +     if (capable(CAP_SYS_NICE))
> > >> +             return 0;
> > >> +
> > >> +     cgroup_taskset_for_each(task, css, tset) {
> > >> +             tcred = __task_cred(task);
> > >
> > > __task_cred() requires RCU lock (courtesy Ricky Z).
> > 
> > Again, hopefully this isn't an issue with the new approach, but for
> > the short term I'll see if we can get this fixed in the android tree.
> > 
> 
> Actually, it should all be simply removed from there right away, as this
> ends up being basically noop (but with all the locking violations and
> races):
> 
> cgroup_taskset_for_each() needs tasks to be placed on cset->mg_tasks
> list, but nobody does this in the ->allow_access() code path, so this
> loops always executes exactly 0 times and the whole thing is exactly
> equivalent of doing
> 
> 	return capable(CAP_SYS_NICE) ? 0 : -EACESS;
> 
> which can be done right in cgroup_procs_write_permission().

Umm, sorry, no, it actually always returns 0, regardless even of
capabilities. Permissions are indeed being relaxed ;)

-- 
Dmitry
