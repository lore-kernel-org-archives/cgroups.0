From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 0/2] Android style loosening of cgroup attach
 permissions
Date: Wed, 3 Jun 2015 14:50:57 +0900
Message-ID: <20150603055057.GE20091@mtj.duckdns.org>
References: <1432179674-19154-1-git-send-email-john.stultz@linaro.org>
 <CALAqxLUXVaf0vzS=Hx+vZK5VqJoWHQ4iA8jG6+sWmiU6O3wbKw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vnc3o+nIBPze3rqtu8BdjXPsl+xj963m9QJP09UztaM=;
        b=A0GQ7lQaWIRRKnGQ8hGlDJ9IYZFnzRu3rVQpBrRGDpSf4fd2nQSnxYwbPsQyuz4pZQ
         aJw2sXf83thrzNc+6brRNNbzLtw5aSumbpX62r507GxxcAPNI6gehK3mzrY2UggFmovy
         mA3AngSATRVfahWVN9QC+ZXAzTm7tnbniFiyPSJoBUSgHGMd7eVL4yQ5jy/VnpzxY+sh
         rCzfvM3YPn5+i8VguNuPuwx9UMGuCF5tubWwmXPY4QuSS4O/Yc0O9d+KFVCIRlXyk9yR
         zetlL35IwmlhRavb5QF0iJ8OmuZXh2rHESyNn4dMcpsuerv4E+ePK30/jA9nWcKuSrUm
         0UYg==
Content-Disposition: inline
In-Reply-To: <CALAqxLUXVaf0vzS=Hx+vZK5VqJoWHQ4iA8jG6+sWmiU6O3wbKw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Johannes Weiner <hannes@cmpxchg.org>

Hello, John.

On Tue, Jun 02, 2015 at 12:07:23PM -0700, John Stultz wrote:
> On Wed, May 20, 2015 at 8:41 PM, John Stultz <john.stultz@linaro.org> wrote:
> > As a heads up, this is just a first RFC and not a submission.
> >
> > Android currently loosens the cgroup attchment permissions, allowing
> > tasks with CAP_SYS_NICE to be able to allow tasks to move arbitrary
> > tasks across cgroups.
> >
> > At first glance, overloading CAP_SYS_NICE seems a bit hackish, but this
> > shows that there is a active and widely deployed use for different cgroup
> > attachment rules then what is currently available.
> >
> > I've tried to rework the patches so this attachment policy is build
> > time configurable, and wanted to send them out for review so folks
> > might give their thoughts on this implementation and what they might
> > see as a better way to go about achieving the same goal.
> >
> > Thoughts and feedback would be appriciated!
> 
> Ping? Not sure if I hit folks at a busy time or if I didn't cc the right folks?

Can you explain why this is necessary?  android's cgroups usage is
pretty weird at this point.  IIRC, it moves tasks between fg and bg
cgroups with memory immigration turned on which basically forces memcg
to walk every single page relabeling them on each fg/bg switch, which
is a pretty silly thing to do and for this android kernel also removes
a rcu sync operation which makes break things on removal of cgroups,
which android doesn't do.

memcg usage came up a while ago and there wasn't anything major which
can't be achieved (usually better) by following more standard cgroup
usage - changing knobs rather than moving tasks around.

Given that, I'm not sure this patchset makes sense for upstream.

Thanks.

-- 
tejun
