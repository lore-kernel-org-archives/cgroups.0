From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 0/2] Android style loosening of cgroup attach permissions
Date: Thu, 4 Jun 2015 10:11:17 -0700
Message-ID: <CALAqxLWkXTgKzq68H6TvPc6Wgbn5_jwVoW5Q9onnHnvQ0bTNiA@mail.gmail.com>
References: <1432179674-19154-1-git-send-email-john.stultz@linaro.org>
	<CALAqxLUXVaf0vzS=Hx+vZK5VqJoWHQ4iA8jG6+sWmiU6O3wbKw@mail.gmail.com>
	<20150603055057.GE20091@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150603055057.GE20091-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Tue, Jun 2, 2015 at 10:50 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, John.
>
> On Tue, Jun 02, 2015 at 12:07:23PM -0700, John Stultz wrote:
>> On Wed, May 20, 2015 at 8:41 PM, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> > As a heads up, this is just a first RFC and not a submission.
>> >
>> > Android currently loosens the cgroup attchment permissions, allowing
>> > tasks with CAP_SYS_NICE to be able to allow tasks to move arbitrary
>> > tasks across cgroups.
>> >
>> > At first glance, overloading CAP_SYS_NICE seems a bit hackish, but this
>> > shows that there is a active and widely deployed use for different cgroup
>> > attachment rules then what is currently available.
>> >
>> > I've tried to rework the patches so this attachment policy is build
>> > time configurable, and wanted to send them out for review so folks
>> > might give their thoughts on this implementation and what they might
>> > see as a better way to go about achieving the same goal.
>> >
>> > Thoughts and feedback would be appriciated!
>>
>> Ping? Not sure if I hit folks at a busy time or if I didn't cc the right folks?
>
> Can you explain why this is necessary?  android's cgroups usage is
> pretty weird at this point.  IIRC, it moves tasks between fg and bg
> cgroups with memory immigration turned on which basically forces memcg
> to walk every single page relabeling them on each fg/bg switch, which
> is a pretty silly thing to do and for this android kernel also removes
> a rcu sync operation which makes break things on removal of cgroups,
> which android doesn't do.

So Colin and Rom could likely do a better job explaining this then me,
but my understanding is that from the scheduling side, they use
cgroups to bound cpu usage of tasks in various states (ie: foreground
applications, background applications, audio application, system
audio, and system tasks). This allows for things like audio
applications to be SCHED_FIFO but not run-away hogging infinite cpu,
and background task cpu usage to be similarly limited.

The migration of a task from the foreground to background, or to
elevate a task to audio priority, may be done by system service that
does not run as root. So this patch allows processes with CAP_SYS_NICE
to be able to migrate tasks between cgroups.  I suspect if there was a
specific cap (CAP_SYS_CHANGE_CGROUP) for this, it would be usable
here, but they just overloaded CAP_SYS_NICE.

One example of this:
https://android.googlesource.com/platform/frameworks/base/+/b267554/services/java/com/android/server/os/SchedulingPolicyService.java


As for the move_charge_at_immigrate, that does seem to be true, and
I'm not sure at this moment of the details (Rom, Colin?), but I
suspect it has to do with the memgc mempressure notifiers.

And at least in the current android-3.18 kernel, I don't see any rcu
sync modifications. But maybe I'm missing what you mean?

> memcg usage came up a while ago and there wasn't anything major which
> can't be achieved (usually better) by following more standard cgroup
> usage - changing knobs rather than moving tasks around.

Do you have a pointer to that discussion or maybe even just a sense of
who was involved so I can trawl the list and better understand it?


> Given that, I'm not sure this patchset makes sense for upstream.

Right, I'm not suggesting the patch go in "as-is".  I just wanted to
show what Android is currently using, and start a discussion of what
would be a better approach for Android to use, or what the kernel
might need to be able to support Android's use case.

thanks
-john
