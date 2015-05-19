From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v12 8/8] cgroup: implement the PIDs subsystem
Date: Tue, 19 May 2015 10:00:55 +0200
Message-ID: <20150519080055.GA3644@twins.programming.kicks-ass.net>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
 <1431960667-26593-9-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431960667-26593-9-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>

On Tue, May 19, 2015 at 12:51:07AM +1000, Aleksa Sarai wrote:

> However, it should be noted that organisational operations (adding and
> removing tasks from a PIDs hierarchy) will *not* be prevented.

This is how you spell: broken controller.
