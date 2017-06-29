From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [v3 1/6] mm, oom: use oom_victims counter to synchronize oom victim selection
Date: Fri, 30 Jun 2017 05:13:13 +0900
Message-ID: <201706300513.BGC60962.LQFJOOtMOFVFSH@I-love.SAKURA.ne.jp>
References: <201706220040.v5M0eSnK074332@www262.sakura.ne.jp>
        <20170622165858.GA30035@castle>
        <201706230537.IDB21366.SQHJVFOOFOMFLt@I-love.SAKURA.ne.jp>
        <201706230652.FDH69263.OtOLFSFMHFOQJV@I-love.SAKURA.ne.jp>
        <20170629184748.GB27714@castle>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170629184748.GB27714@castle>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: guro@fb.com
Cc: linux-mm@kvack.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hannes@cmpxchg.org, tj@kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Roman Gushchin wrote:
> On Fri, Jun 23, 2017 at 06:52:20AM +0900, Tetsuo Handa wrote:
> > Tetsuo Handa wrote:
> > Oops, I misinterpreted. This is where a multithreaded OOM victim with or without
> > the OOM reaper can get stuck forever. Think about a process with two threads is
> > selected by the OOM killer and only one of these two threads can get TIF_MEMDIE.
> > 
> >   Thread-1                 Thread-2                 The OOM killer           The OOM reaper
> > 
> >                            Calls down_write(&current->mm->mmap_sem).
> >   Enters __alloc_pages_slowpath().
> >                            Enters __alloc_pages_slowpath().
> >   Takes oom_lock.
> >   Calls out_of_memory().
> >                                                     Selects Thread-1 as an OOM victim.
> >   Gets SIGKILL.            Gets SIGKILL.
> >   Gets TIF_MEMDIE.
> >   Releases oom_lock.
> >   Leaves __alloc_pages_slowpath() because Thread-1 has TIF_MEMDIE.
> >                                                                              Takes oom_lock.
> >                                                                              Will do nothing because down_read_trylock() fails.
> >                                                                              Releases oom_lock.
> >                                                                              Gives up and sets MMF_OOM_SKIP after one second.
> >                            Takes oom_lock.
> >                            Calls out_of_memory().
> >                            Will not check MMF_OOM_SKIP because Thread-1 still has TIF_MEMDIE. // <= get stuck waiting for Thread-1.
> >                            Releases oom_lock.
> >                            Will not leave __alloc_pages_slowpath() because Thread-2 does not have TIF_MEMDIE.
> >                            Will not call up_write(&current->mm->mmap_sem).
> >   Reaches do_exit().
> >   Calls down_read(&current->mm->mmap_sem) in exit_mm() in do_exit(). // <= get stuck waiting for Thread-2.
> >   Will not call up_read(&current->mm->mmap_sem) in exit_mm() in do_exit().
> >   Will not clear TIF_MEMDIE in exit_oom_victim() in exit_mm() in do_exit().
> 
> That's interesting... Does it mean, that we have to give an access to the reserves
> to all threads to guarantee the forward progress?

Yes, for we don't have __GFP_KILLABLE flag.

> 
> What do you think about Michal's approach? He posted a link in the thread.

Please read that thread.
