From: Marco Ballesio <balejs@google.com>
Subject: Re: [PATCH] cgroup-v1: freezer: optionally killable freezer
Date: Fri, 20 Mar 2020 13:10:38 -0700
Message-ID: <20200320201038.GB79184@google.com>
References: <20200219183231.50985-1-balejs@google.com>
 <20200303134855.GA186184@mtj.thefacebook.com>
 <CAKOZuevzE=0Oa8gn--rkVJ8t69S+o2vK--pki65XXg6EVuOhMQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8wBJM863apF0IwOPmO9fuaOOqzaQw306izkJnc0/fII=;
        b=fvAklPMvJlNS9vNQhJdK1AuiQZmkjC9vvIRMZAQNcvfDDWR0w81khYqp5RiIul11WS
         WNDSy3c75Luwy9fag1iFfAx9/w70boBzrfy11P7KavWhZ+KyL4ceLQOJRHR1B3zrPJUZ
         qdClxBt0eYYcn70/mYeISAvctswbPnd48V7CRpzrwo3NX8m/mAo6R6EhXlXVD9++v7TH
         uYxvLdjJRlOBxjGld2ZPPSL3GxoFznoZ8mkQV+c9Q3N7U+vOYd5Lmjf43xm/r76g91X/
         AUhtUkfSWDvveqHe5UZzR9+cCVaNJjrJ+Pco0WFaX1iLxXn9O15Mu5/ruLY0L6YUn2/+
         4ONQ==
Content-Disposition: inline
In-Reply-To: <CAKOZuevzE=0Oa8gn--rkVJ8t69S+o2vK--pki65XXg6EVuOhMQ@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Colascione <dancol@google.com>
Cc: Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, cgroups@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, rjw@rjwysocki.net, Pavel Machek <pavel@ucw.cz>, len.brown@intel.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-pm@vger.kernel.org, Minchan Kim <minchan@google.com>, Suren Baghdasaryan <surenb@google.com>

On Wed, Mar 11, 2020 at 10:46:15AM -0700, Daniel Colascione wrote:
> On Tue, Mar 3, 2020 at 5:48 AM Tejun Heo <tj@kernel.org> wrote:
> >
> > Hello,
> >
> > On Wed, Feb 19, 2020 at 10:32:31AM -0800, Marco Ballesio wrote:
> > > @@ -94,6 +94,18 @@ The following cgroupfs files are created by cgroup freezer.
> > >    Shows the parent-state.  0 if none of the cgroup's ancestors is
> > >    frozen; otherwise, 1.
> > >
> > > +* freezer.killable: Read-write
> > > +
> > > +  When read, returns the killable state of a cgroup - "1" if frozen
> > > +  tasks will respond to fatal signals, or "0" if they won't.
> > > +
> > > +  When written, this property sets the killable state of the cgroup.
> > > +  A value equal to "1" will switch the state of all frozen tasks in
> > > +  the cgroup to TASK_INTERRUPTIBLE (similarly to cgroup v2) and will
> > > +  make them react to fatal signals. A value of "0" will switch the
> > > +  state of frozen tasks to TASK_UNINTERRUPTIBLE and they won't respond
> > > +  to signals unless thawed or unfrozen.
> >
> > As Roman said, I'm not too sure about adding a new cgroup1 freezer
> > interface at this point. If we do this, *maybe* a mount option would
> > be more minimal?
> 
> I'd still prefer a cgroup flag. A mount option is a bigger
> compatibility risk and isn't really any simpler than another cgroup
> flag. A mount option will affect anything using the cgroup mount
> point, potentially turning non-killable frozen processes into killable
> ones unexpectedly. (Sure, you could mount multiple times, but only one
> location is canonical, and that's the one that's going to get the flag
> flipped.) A per-cgroup flag allows people to opt into the new behavior
> only in specific contexts, so it's safer.

It might also be desirable for userland to have a way to modify the behavior of
an already mounted v1 freezer.

Tejun, would it be acceptable to have a flag but disable it by default, hiding
it behind a kernel configuration option?
