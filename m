From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6 0/4] Charge loop device i/o to issuing cgroup
Date: Fri, 21 Aug 2020 11:04:05 -0400
Message-ID: <20200821150405.GA4137@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
References: <20200528135444.11508-1-schatzberg.dan@gmail.com>
 <CALvZod655MqFxmzwCf4ZLSh9QU+oLb0HL-Q_yKomh3fb-_W0Vg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1FzqZJ6ck6KUzOqSuKnj7ejxM9ufdWSJqP1xoW29qVs=;
        b=YMyC8odRxwt4e+ebHOdmQFNxzIqRf1A3/okUdcouS+5ljxpc1mDGkbrRKCaOWLMRFr
         tbYI+SM/yvrHIvogo40z5OqLqYJkChEfGfUzeEtpFZaCRIPZPxYLYEHSc17+Zo/0VE9d
         TzKI7FDaqtwoQKWX9hUMNi6bHRg3MniqKbnRaJ20ycXK2km/LwmfJw14EqQ2fXHsyxJH
         0cd8PXp02Ei2m+BYXl573s3GRyAK3iD/xnGq61OQAg6T9ndogxeZFI095Wf2QmPScfjg
         nermWatu5yNdkT9mlCcjxRIfZTCkdBGzvDieCK0LVBtz3oicHcxtogJkOwk+IkcJnSXu
         Ya/w==
Content-Disposition: inline
In-Reply-To: <CALvZod655MqFxmzwCf4ZLSh9QU+oLb0HL-Q_yKomh3fb-_W0Vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open

On Thu, Aug 20, 2020 at 10:06:44AM -0700, Shakeel Butt wrote:
> On Thu, May 28, 2020 at 6:55 AM Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > Much of the discussion about this has died down. There's been a
> > concern raised that we could generalize infrastructure across loop,
> > md, etc. This may be possible, in the future, but it isn't clear to me
> > how this would look like. I'm inclined to fix the existing issue with
> > loop devices now (this is a problem we hit at FB) and address
> > consolidation with other cases if and when those need to be addressed.
> >
> 
> What's the status of this series?

Thanks for reminding me about this. I haven't got any further
feedback. I'll bug Jens to take a look and see if he has any concerns
and if not send a rebased version.
