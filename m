From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 0/2] Android style loosening of cgroup attach permissions
Date: Fri, 5 Jun 2015 14:28:54 -0700
Message-ID: <CALAqxLUDX94EqG1w+CfCXAgMq6-BfnyRev4pLBfxOagrfh42wQ@mail.gmail.com>
References: <1432179674-19154-1-git-send-email-john.stultz@linaro.org>
	<CALAqxLUXVaf0vzS=Hx+vZK5VqJoWHQ4iA8jG6+sWmiU6O3wbKw@mail.gmail.com>
	<20150603055057.GE20091@mtj.duckdns.org>
	<CALAqxLWkXTgKzq68H6TvPc6Wgbn5_jwVoW5Q9onnHnvQ0bTNiA@mail.gmail.com>
	<20150604183658.GA5682@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150604183658.GA5682-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>

On Thu, Jun 4, 2015 at 11:36 AM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> On Thu, Jun 04, 2015 at 10:11:17AM -0700, John Stultz wrote:
>> On Tue, Jun 2, 2015 at 10:50 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > memcg usage came up a while ago and there wasn't anything major which
>> > can't be achieved (usually better) by following more standard cgroup
>> > usage - changing knobs rather than moving tasks around.
>>
>> Do you have a pointer to that discussion or maybe even just a sense of
>> who was involved so I can trawl the list and better understand it?
>
> I wrote a lengthy explanation of why moving tasks between cgroups is
> problematic from a memcg view: https://lkml.org/lkml/2014/12/19/358
>
> Rather than creating super-cgroups as configuration domains and using
> migration as a reconfiguration mechanism, it's much better to group
> tasks per app and reconfigure the groups themselves using specific
> presets for classes of apps, like foreground, background, audio.

Hmm. So I've not heard from the Android guys on the viability of this,
but one downside to this approach seems like that for cpu-scheduling
at least, using a per-task allocation would make it harder to bound
"background" cpu processing as a whole, no?

For example, In order to keep all background tasks to less then 20% of
the cputime, you'd have to set each process to get .2/nr_tasks (which
you'd have to recalculate & re-assign every time a new task is
launched). But that would end up being wasteful since each task gets
limited by that amount and cannot make use of cputime not used by
other background tasks.

Or am I misunderstanding the suggestion? Or is your concern just
limited to the memcg and this sort of cgroup migration ok for
scheduling?

And I guess, if its ok for scheduling, is it reasonable to consider
the proposed patch to allow "privileged" but non-root tasks to migrate
processes between cgroups?

thanks
-john
