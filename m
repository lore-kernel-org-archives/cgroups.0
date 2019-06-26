From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 0/7] introduce cpu.headroom knob to cpu controller
Date: Wed, 26 Jun 2019 10:26:35 +0200
Message-ID: <20190626082634.GA22035@blackbody.suse.cz>
References: <20190408214539.2705660-1-songliubraving@fb.com>
 <20190410115907.GE19434@e105550-lin.cambridge.arm.com>
 <A2E9A149-9EAA-478D-A096-1D4D4BA442B3@fb.com>
 <20190521134730.GA12346@blackbody.suse.cz>
 <D9376488-F290-4917-9124-292AA649948C@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D9376488-F290-4917-9124-292AA649948C@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Song Liu <songliubraving@fb.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, Kernel Team <Kernel-team@fb.com>, "peterz@infradead.org" <peterz@infradead.org>, "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Hello Song and I apology for late reply.

I understand the motivation for the headroom attribute is to achieve
side load throttling before the CPU is fully saturated since your
measurements show that something else gets saturated earlier than CPU
and causes grow of the observed latency.

The second aspect of the headroom knob, i.e. dynamic partitioning of the
CPU resource is IMO something which we already have thanks to
cpu.weight.

As you wrote, plain cpu.weight of workloads didn't work for you, so I
think it'd be worth figuring out what is the resource whose saturation
affects the overall observed latency and see if a protection/weights on
that resource can be set (or implemented).

On Tue, May 21, 2019 at 04:27:02PM +0000, Song Liu <songliubraving@fb.com> wrote:
> The overall latency (or wall latency) contains: 
> 
>    (1) cpu time, which is (a) and (d) in the loop above;
How do you measure this CPU time? Does it include time spent in the
kernel? (Or can there be anything else unaccounted for in the following
calculations?)

>    (2) time waiting for data, which is (b);
Is your assumption of this being constant supported by the measurements?

The last note is regarding semantics of the headroom knob, I'm not sure
it fits well into the weight^allocation^limit^protection model. It seems
to me that it's crafted to satisfy the division to one main workload and
side workload, however, the concept doesn't generalize well to arbitrary
number of siblings (e.g. two cgroups with same headroom, third with
less, who is winning?).

HTH,
Michal
