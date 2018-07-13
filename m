From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory,
 and IO v2
Date: Fri, 13 Jul 2018 18:14:06 -0400
Message-ID: <20180713221042.GA30013@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712164422.a53cc0f9c26b078dbc7e5731@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7PgyzSNJ2bqfKN8F6PdixT1ZQ9Zdxvkc+fOPVFGcypE=;
        b=sQxoz6MkrCfzDoTQIGPLrKd4xVZIMBDrFsvmmbmc+kAXLuPFVzlBm5DjzRN15UUcP+
         D7v/yop7r0jW80AiPLdBdouqkREe6MC+FUAQJ4gfG0ZakjNWam5rQa0H5Y7FH2RuwHH6
         s5s7RZkRnpgIG7TuhiZhNE3q/4Y2z0J9iDU9ihUo5g4GXwZCWKCxjBnYuRTEE2ypCC/i
         RIANcG9WiWGFY9p6utjE8yzYIxvUz1vpALUKT3z5Sps64dBwKb6oxhuMU2uWTsHkl+ed
         b4XL+3azzT4UCDcQ60eOhDO0R2cSNk0SWITJ1ctbRX4y+0OPC3Oq9ilN8F67S2O5SNkd
         cYww==
Content-Disposition: inline
In-Reply-To: <20180712164422.a53cc0f9c26b078dbc7e5731@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Jul 12, 2018 at 04:44:22PM -0700, Andrew Morton wrote:
> On Thu, 12 Jul 2018 13:29:32 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> >
> > ...
> >
> > The io file is similar to memory. Because the block layer doesn't have
> > a concept of hardware contention right now (how much longer is my IO
> > request taking due to other tasks?), it reports CPU potential lost on
> > all IO delays, not just the potential lost due to competition.
> 
> Probably dumb question: disks aren't the only form of IO.  Does it make
> sense to accumulate PSI for other forms of IO?  Networking comes to
> mind...

It's conceivable, although I haven't thought too much about it yet. If
that turns out to be a state we might want to track, we can easily add
a task state to identify such stalls and add /proc/pressure/net e.g.

"io" in this case means only the block layer / filesystems. I think
keeping this distinction makes sense in the interest of identifying
which type of hardware resource is posing a pressure problem.
