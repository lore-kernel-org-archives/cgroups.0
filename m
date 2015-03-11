From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v2 1/2] cgroups: allow a cgroup subsystem to reject a fork
Date: Wed, 11 Mar 2015 16:16:30 +1100
Message-ID: <CAOviyajuq5QgwmByVzF34RVyRs+fad=82i2pJH12y1kB5X6bWg@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
	<1425010639-16492-1-git-send-email-cyphar@cyphar.com>
	<1425010639-16492-2-git-send-email-cyphar@cyphar.com>
	<20150309030636.GC13283@htj.duckdns.org>
	<CAOviyaip7Faz98YWzGoTaXGYVb72sfD+ZL4Xa89reU9+=43jFA@mail.gmail.com>
	<20150309065902.GP13283@htj.duckdns.org>
	<CAOviyaj3mf66ho15WrD8qB=ECxKWYTAkWodxWaFVMWeZG4d0FQ@mail.gmail.com>
	<20150310124701.GB28730@htj.duckdns.org>
	<CAOviyai7yJrbGb+uYpK35tw7R-KM0jWQ-BmhpyTqnRFJsVYdUA@mail.gmail.com>
	<20150310151728.GD28730@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150310151728.GD28730@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello Tejun,

On Wed, Mar 11, 2015 at 2:17 AM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Mar 11, 2015 at 01:51:06AM +1100, Aleksa Sarai wrote:
>> Actually, I'm fairly sure we can do it all inside cgroup_post_fork() because
>> inside cgroup_post_fork() we have access to both the old css_set and the new
>> one. Then it's just a matter of reverting and re-applying the charge to the
>> hierarchies.
>
> But the problem isn't whether we know both the old and new ones.  The
> problem is that we can only abort before the fork commit point and the
> "old" one may change between the abort point and post-commit point so
> we need to trycharge the old one at the possible abort point, remember
> to which css it got charged and then check whether the association has
> changed inbetween at the post commit point and readjust if so.

Actually, it appears I was wrong. Until we hit cgroup_post_fork()'s setting up
of the task's css_set, cgroup_can_fork() ends up charging init_css_set *every
time*. Which means a check to see if it changed will always show that it had
changed. The issue is that we need to access the css_set which is going to be
saved as the task's css_set in order to decide if the task should fork.

We know that the task will have its css_set set to task_css_set(current), and
we could just use that in cgroup_can_fork(). The only question is, can
task_css_set(current) change between cgroup_can_fork() and cgroup_post_fork()?

If it can change between the two calls, then we're in trouble -- there'd be no
reliable way of checking that the future css_set allows for the fork without
going through the registration of the css_set *proper* in cgroup_post_fork()
unless we hold css_set_rwsem for the entirety of the can_fork() to post_fork()
segment (which I can't imagine is a good idea).

--
Aleksa Sarai (cyphar)
www.cyphar.com
