From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 0/2] Another pass at Android style loosening of
 cgroup attach permissions
Date: Tue, 4 Oct 2016 17:29:47 -0400
Message-ID: <20161004212947.GM4205@htj.duckdns.org>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
 <20161004161630.GC4205@htj.duckdns.org>
 <CALAqxLUPMxpngbZCSFW9wS+LbZJbfSUxTDEXX2x-FUmuN4H+QQ@mail.gmail.com>
 <20161004193838.GH4205@htj.duckdns.org>
 <20161004201840.GA27018@mail.hallyn.com>
 <20161004203301.GK4205@htj.duckdns.org>
 <20161004212643.GA27842@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=thmYxwzUC3ocJVq3ODoSrpOMQ29TS4l1yev1CLR3A+E=;
        b=Z2Wr6riIMmJiERVw7P2JaBrAv0LOlFkWHRCMSkdk6/AdNWTPl7a1xYbf9Vq1l1EhAw
         WMkpu1fnK9vNsmSRN5fV565A9U67gVaBpo25x8M7zE6vF6vjb8DEgfuriPHHuygKbnIG
         MXTwJc0kU93czW1HE/1N07zc47ZSwoZcZqoi/VdPEX8nPrwW2ZJv9yLx8R00b8Bt+l1X
         yB4Wn1E6O+/5MzpJDO3ELhk7hOYiJx6TdI6YHoUhINkNHE+gfmOducCnEqS7reNoVT0R
         2yruBeqimkwFR1E+7DdBO2UAXrD8vQkWq1KUH5U8fL/y6SHNyTYnCinPrpJnKkrGTryE
         w/+w==
Content-Disposition: inline
In-Reply-To: <20161004212643.GA27842@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>

On Tue, Oct 04, 2016 at 04:26:43PM -0500, Serge E. Hallyn wrote:
> Quoting Tejun Heo (tj@kernel.org):
> > Hello, Serge.
> > 
> > On Tue, Oct 04, 2016 at 03:18:40PM -0500, Serge E. Hallyn wrote:
> > > how about changing the GLOBAL_ROOT_UID check with a targeted
> > > capability check, like
> > > 
> > > 	if (!ns_capable(tcred->user_ns, CAP_SYS_NICE) &&
> > >             !uid_eq(cred->euid, tcred->uid) &&
> > >             !uid_eq(cred->euid, tcred->suid))
> > > 		ret = -EACCES;
> > > 
> > > where the actual capability to use may require some thought.
> > 
> > Yeah, that's the direction I'm thinking too.  We can't use
> > CAP_SYS_NICE in general tho.  Let's see if a dedicated CAP sticks.
> 
> One possibility would be to let each cgroup subsystem define
> a move_caps capability mask which is required over the target
> task.  And add a new CAP_CGROUP which always suffices?

As I wrote in another reply, I really don't wanna do that.  It brings
in the question about control knob permissions too and makes the
permission checks a lot more difficult to predit.  I'd much rather
just get rid of the extra checks, at least on the v2 hierarchy.  The
extra checks are protecting against pulling in random processes into a
delegated subtree and v2 hierarchy already has a protection against
that.

Thanks.

-- 
tejun
