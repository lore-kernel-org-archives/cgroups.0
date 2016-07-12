From: Michal Hocko <mhocko@kernel.org>
Subject: Re: bug in memcg oom-killer results in a hung syscall in another
 process in the same cgroup
Date: Tue, 12 Jul 2016 09:19:27 +0200
Message-ID: <20160712071927.GD14586@dhcp22.suse.cz>
References: <CABAubThf6gbi243BqYgoCjqRW36sXJuJ6e_8zAqzkYRiu0GVtQ@mail.gmail.com>
 <20160711064150.GB5284@dhcp22.suse.cz>
 <CABAubThHfngHTQW_AEuW71VCvLyD_9b5Z05tSud5bf8JKjuA9Q@mail.gmail.com>
 <CABAubTjGhUXMeAnFgW8LGck1tgvtu12Zb9fx5BRhDWNjZ7SYLQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CABAubTjGhUXMeAnFgW8LGck1tgvtu12Zb9fx5BRhDWNjZ7SYLQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shayan Pooya <shayan@liveve.org>
Cc: cgroups mailinglist <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org

On Mon 11-07-16 11:33:19, Shayan Pooya wrote:
> >> Could you post the stack trace of the hung oom victim? Also could you
> >> post the full kernel log?
> 
> With strace, when running 500 concurrent mem-hog tasks on the same
> kernel, 33 of them failed with:
> 
> strace: ../sysdeps/nptl/fork.c:136: __libc_fork: Assertion
> `THREAD_GETMEM (self, tid) != ppid' failed.
> 
> Which is: https://sourceware.org/bugzilla/show_bug.cgi?id=15392
> And discussed before at: https://lkml.org/lkml/2015/2/6/470 but that
> patch was not accepted.

OK, so the problem is that the oom killed task doesn't report the futex
release properly? If yes then I fail to see how that is memcg specific.
Could you try to clarify what you consider a bug again, please? I am not
really sure I understand this report.

Thanks!

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
