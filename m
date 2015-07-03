From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 44/51] writeback: implement bdi_wait_for_completion()
Date: Fri, 3 Jul 2015 13:02:10 -0400
Message-ID: <20150703170210.GD5273@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-45-git-send-email-tj@kernel.org>
 <20150701160437.GG7252@quack.suse.cz>
 <20150702030624.GM26440@mtj.duckdns.org>
 <20150703123642.GL23329@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iIMS7Cgkn4P9BxBDQMlj9bjQv3odGwaFP8uFzzzrf08=;
        b=QcYT1ewxD+eWOmX4L9FZ/RHoSPAumqKMU1FYW4Zpyi4x6hMmPJnZxXPaZYbL3hM71M
         A19/jM7eqL1L1zZHwCsLKfiJiewo6AF0XZvFkeU0+yeC6QHDrzSFY2umqDwi/HTYS4Gd
         anAJq53nd5Q6gPFIqld/RNebvg6e8q2SK9BqGfQ8OTe99CKjrMUtu+ERyD2R6CfKuziz
         bve9KoX/3KnxrYfhrB0hv3qarTh+r6xU+nbeAdRW/1VvjwVa9vHPeWRBC3RBYVhk7OM3
         2FpSrqojThDvzT3HYl7lYjt3l86tdnEz+ad5NoPR6EJr+MiN1qTji8cdnvqFV7FgwpVx
         NBNg==
Content-Disposition: inline
In-Reply-To: <20150703123642.GL23329@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello,

On Fri, Jul 03, 2015 at 02:36:42PM +0200, Jan Kara wrote:
> Let me phrase my objection this differently: Instead of implementing custom
> synchronization mechanism, you could as well do:
> 
> int count_submitted;	/* Number of submitted works we want to wait for */
> struct completion done;
> ...
> submit works with 'done' as completion.
> ...
> while (count_submitted--)
> 	wait_for_completion(&done);
> 
> And we could also easily optimize that loop and put it in
> kernel/sched/completion.c. The less synchronization mechanisms we have the
> better I'd think...

And what I'm trying to say is that we most likely don't want to build
it around completions.  We really don't want to roll "event count" and
"wakeup count" into the same mechanism.  There's nothing completion
provides that such event counting mechanism needs or wants.  It isn't
that attractive from the completion side either.  The main reason we
have completions is for stupid simple synchronizations and we wanna
keep it simple.

I do agree that we might want a generic "event count" mechanism but at
the same time combining a counter and wait_event is usually pretty
trivial.  Maybe atomic_t + waitqueue is a useful enough abstraction
but then we would eventually end up having to deal with all the
different types of waits and timeouts.  We might end up with a lot of
thin wrappers which really don't do much of anything.

If you can think of a good way to abstract this, please go head.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
