From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH 08/10] blkcg: implement blk-ioweight
Date: Fri, 14 Jun 2019 22:50:34 +0200
Message-ID: <87blyzc2n9.fsf@toke.dk>
References: <20190614015620.1587672-1-tj@kernel.org> <20190614015620.1587672-9-tj@kernel.org> <87pnngbbti.fsf@toke.dk> <20190614150924.GB538958@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190614150924.GB538958@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org, Josef Bacik <jbacik@fb.com>

Tejun Heo <tj@kernel.org> writes:

> Hello, Toke.
>
> On Fri, Jun 14, 2019 at 02:17:45PM +0200, Toke Høiland-Jørgensen wrote:
>> One question: How are equal-weight cgroups scheduled relative to each
>> other? Or requests from different processes within a single cgroup for
>> that matter? FIFO? Round-robin? Something else?
>
> Once each cgroup got their hierarchical weight and current vtime for
> the period, they don't talk to each other.  Each is expected to do the
> right thing on their own.  When the period ends, the timer looks at
> how the device is performing, how much each used and so on and then
> make necessary adjustments.  So, there's no direct cross-cgroup
> synchronization.  Each is throttled to their target level
> independently.

Right, makes sense.

> Within a single cgroup, the IOs are FIFO. When an IO has enough vtime
> credit, it just passes through. When it doesn't, it always waits
> behind any other IOs which are already waiting.

OK. Is there any fundamental reason why requests from individual
processes could not be interleaved? Or does it just not give the same
benefits in an IO request context as it does for network packets?

Thanks for the explanations! :)

-Toke
