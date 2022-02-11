From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 00/12] locking: Separate lock tracepoints from
 lockdep/lock_stat (v1)
Date: Fri, 11 Feb 2022 11:39:13 +0100
Message-ID: <20220211103913.GR23216@worktop.programming.kicks-ass.net>
References: <20220208184208.79303-1-namhyung@kernel.org>
 <20220209090908.GK23216@worktop.programming.kicks-ass.net>
 <CAM9d7cgq+jxu6FJuKhZkprn7dO4DiG5pDjmYZzneQYTfKOM85g@mail.gmail.com>
 <YgTXUQ9CBoo3+A+c@hirez.programming.kicks-ass.net>
 <CAM9d7cgPFLjQyopX04MwG6Leq6DwDJF2q6BxOL_Nw6J2LEZF4g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=OF/IgiH+v6IN/Pzp4IQTqAUh7fLzy/AMqRrw5uRs6QM=; b=LbJP76jKebDs3mjRSiss+VrY7f
 dyaOfWlffhDUHwB5AhCZaYYvYgwPKcloLfHaKYcpTn89ucITWQacDwWZdCUpXsJ1W4aPGDu1CoKWg
 Rfzrrf4xgw1gmNI7TdQWjDRc8mKeLyhdnOKMRPCY5pRyEN3Wib9vTBUNOwdD95nCv5VqFC6/0V7FQ
 Haq8I+dR+Ow1pT7b6qWtQv5lKaUKPND5wFWM1sqdcOOios9N3Wn/zaVMAzaStBFXvrfKDhY+htVJN
 9uOg2NJnn422jyJBwlc67KqBfJSE0Vw19ZHFnLq5WuwjQtRMOFXBa8cNi2XxrR2RAgKJ34Y8iRUb+
 Lw5VTLVQ==;
Content-Disposition: inline
In-Reply-To: <CAM9d7cgPFLjQyopX04MwG6Leq6DwDJF2q6BxOL_Nw6J2LEZF4g@mail.gmail.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namhyung Kim <namhyung@kernel.org>
Cc: rcu <rcu@vger.kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, intel-gfx <intel-gfx@lists.freedesktop.org>, Boqun Feng <boqun.feng@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Radoslaw Burny <rburny@google.com>, Byungchul Park <byungchul.park@lge.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Waiman Long <longman@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Thu, Feb 10, 2022 at 09:55:27PM -0800, Namhyung Kim wrote:

> So you are ok with adding two new tracepoints, even if they are
> similar to what we already have in lockdep/lock_stat, right?

Yeah, I don't think adding tracepoints to the slowpaths of the various
locks should be a problem.
