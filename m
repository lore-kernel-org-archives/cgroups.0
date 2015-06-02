From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 0/2] Android style loosening of cgroup attach permissions
Date: Tue, 2 Jun 2015 12:07:23 -0700
Message-ID: <CALAqxLUXVaf0vzS=Hx+vZK5VqJoWHQ4iA8jG6+sWmiU6O3wbKw@mail.gmail.com>
References: <1432179674-19154-1-git-send-email-john.stultz@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432179674-19154-1-git-send-email-john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>

On Wed, May 20, 2015 at 8:41 PM, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> As a heads up, this is just a first RFC and not a submission.
>
> Android currently loosens the cgroup attchment permissions, allowing
> tasks with CAP_SYS_NICE to be able to allow tasks to move arbitrary
> tasks across cgroups.
>
> At first glance, overloading CAP_SYS_NICE seems a bit hackish, but this
> shows that there is a active and widely deployed use for different cgroup
> attachment rules then what is currently available.
>
> I've tried to rework the patches so this attachment policy is build
> time configurable, and wanted to send them out for review so folks
> might give their thoughts on this implementation and what they might
> see as a better way to go about achieving the same goal.
>
> Thoughts and feedback would be appriciated!

Ping? Not sure if I hit folks at a busy time or if I didn't cc the right folks?

thanks
-john
