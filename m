From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH 1/2] mm: add sysctl to control global OOM logging behaviour
Date: Wed, 8 Nov 2017 22:45:00 +0900
Message-ID: <201711082245.BGF12900.VFFOLJHOOMtSFQ@I-love.SAKURA.ne.jp>
References: <20171108091843.29349-1-dmonakhov@openvz.org>
	<24fb6865-6cc5-2af0-3a99-ea9495791f66@I-love.SAKURA.ne.jp>
	<87inelklnd.fsf@openvz.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <87inelklnd.fsf@openvz.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dmonakhov@openvz.org, linux-mm@kvack.org
Cc: cgroups@vger.kernel.org, vdavydov.dev@gmail.com

Dmitry Monakhov wrote:
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:
> 
> > On 2017/11/08 18:18, Dmitry Monakhov wrote:
> >> Our systems becomes bigger and bigger, but OOM still happens.
> >> This becomes serious problem for systems where OOM happens
> >> frequently(containers, VM) because each OOM generate pressure
> >> on dmesg log infrastructure. Let's allow system administrator
> >> ability to tune OOM dump behaviour
> >
> > Majority of OOM killer related messages are from dump_header().
> > Thus, allow tuning __ratelimit(&oom_rs) might make sense.
> >
> > But other lines
> >
> >   "%s: Kill process %d (%s) score %u or sacrifice child\n"
> >   "Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n"
> >   "oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n"
> This still may result in hundreds of messages per second.

Then, it means that your system is invoking the OOM killer one hundred times
per second (every 10 milliseconds). I think that such system is far from properly
configured.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
