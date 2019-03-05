From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 0/7] freezer for cgroup v2
Date: Tue, 5 Mar 2019 09:27:32 -0800
Message-ID: <20190305172711.GE50184@devbig004.ftw2.facebook.com>
References: <20190219220252.4906-1-guro@fb.com>
 <20190220143748.GA9477@redhat.com>
 <20190220220020.GA16335@castle.DHCP.thefacebook.com>
 <20190221162923.GA26064@redhat.com>
 <20190221173422.GY50184@devbig004.ftw2.facebook.com>
 <20190222163441.GA5596@redhat.com>
 <20190222181740.GZ50184@devbig004.ftw2.facebook.com>
 <20190225155725.GA8096@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mNi2wcs42w6UeX4ek2kNcWvb2MWYPhhWXQr+BTcHWzA=;
        b=WGvmDns+blbuyso53uWHKhRtDGSCgonJqeV/qv36MQf+5wzAILLS9xN/7V1A5oKJYC
         5p2rYbnI4yHmrwWtXSCzWvVUjtSsgAk1eZUUcKbS3rJO0Bpeb22uLSBw3duLCHZTcc9d
         VyIkNTGwR7bzeBkNy66nBFRpn2AQzDpNvkjKGdKTDBM9NAiA8b5sjPmjIFOdK370b7tB
         O7OmjnWOa2zPniVkNA/bUUFr+WTIktjJiaO2YksyzzTjxaoutu1ToFUOngyifduCGHqi
         umCHTuczoamZ7P4KTFESx8p6VeI3ZGh3TOAGrPl2SvLVfWxCaIhCm/85udUMsIcaYnKh
         wV4w==
Content-Disposition: inline
In-Reply-To: <20190225155725.GA8096@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guro@fb.com>, Roman Gushchin <guroan@gmail.com>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hello, Oleg.

Sorry about the delay.

On Mon, Feb 25, 2019 at 04:57:25PM +0100, Oleg Nesterov wrote:
> > As long as the task is
> > guaranteed to be trapped by signal stop afterwards (and they are), we
> > likely can use them the same way.  The only thing to be careful about
> > would be ensuring that we don't end up flipping group level frozen
> > state inbetween.  Would something like that work?
> 
> I have no idea because I do not understand what exactly do you mean ;)

Heh, sorry about that.  What I meant was that we can consider a task
which is blocked in vfork wait as already frozen and that if we do so
we need to be careful so that frozen state doesn't do a flip between
vfork wait ending and the task getting parked again in a jobctl stop.

> However. Thinking more about this, I am not sure my concerns were valid.
> Yes, cg freezer can "hang" if it races with vfork(). But probably we should
> blame vfork(), not freezer.

I think we'd need to cover that ground regardless of where blame lies.
It's weird if freezing doesn't complete cuz one of the tasks messed up
while vforking.

> The problem is, even ^Z can "hang" if the foreground process does vfork()
> and the new child stops before exit/exec. Now I recall that I even tried
> to make a patch to fix this using ERESTART_RESTARTBLOCK, but had some nasty
> problems with blocked signals...

Ugh... yeah, these wait non-interruptible wait sites which can be
exposed to userspace are nasty.  They end up adding a unique wait
state visible to userspace which comes with a bunch of corner cases.

> de_thread() should use freezable_schedule() in TASK_KILLABLE too. Currently
> it doesn't, but only because we have other (much more serious) problems with
> cred_guard_mutex/exec. However, this is is fine wrt cg freezer, other threads
> can't be frozen exactly because it is killable.
> 
> Anything else does freezer_do_not_count() in TASK_KILLABLE and waits for
> another freezable process?

Can't find any.  Hopefully, that was it?

> So it seems I have to take my words back, perhaps we can forget about
> freezable_schedule/etc.

I think it'd be great to be able to handle these if at all possible.

Thanks.

-- 
tejun
