From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V2 0/8] cpusets: Isolate CPUs via sysfs using cpusets
Date: Mon, 7 Apr 2014 09:41:14 +0530
Message-ID: <CAKohpomW3jpQEqFxD3m_br8GchJyq9-KSxW2x7JLCRqDgf4SAg@mail.gmail.com>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
	<1396773020.11763.17.camel@marge.simpson.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1396773020.11763.17.camel@marge.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Lists linaro-kernel <linaro-kernel@lists.linaro.org>, Linaro Networking <linaro-networking@linaro.org>, Arvind Chauhan <Arvind.Chauhan@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hi Mike,

On 6 April 2014 14:00, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> I wonder if adding a quiesce switch is really necessary.
>
> Seems to me that if you don't have load balancing turned off, you can't
> be very concerned about perturbation, so this should be tied into the
> load balancing on/off switch as an extension to isolating cores from the
> #1 perturbation source, the scheduler.

Its more about not doing any background activities on these CPU which can
be avoided. So, even if a add_timer() is issued from these isolated CPUs, it
should goto the set chosen for doing background activity, unless add_timer_on()
has been issued, in which case user wants that code to execute on the
isolated core.

Probably, yes, people would be disabling load_balancing between these
cpusets to avoid migration of tasks to isolated core as well.. Atleast we
are using it :)

> I also didn't notice a check for is_cpu_exclusive() at a glance, which
> would be a bug, but one that would go away if this additional isolation
> were coupled to the existing isolation switch.

Yeah, there is no check for that. But I didn't got your point completely.
Why do I need to check for exclusivity on the isolated CPUs? So, that
same CPU isn't isolated as well as non-isolated on two separate sets?

Thanks for your feedback.

--
viresh
