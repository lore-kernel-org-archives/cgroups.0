From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC 1/2] cgroups: allow a cgroup subsystem to reject a
 fork
Date: Mon, 23 Feb 2015 15:49:07 +0100
Message-ID: <20150223144907.GZ5029@twins.programming.kicks-ass.net>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1424660891-12719-2-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424660891-12719-2-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Feb 23, 2015 at 02:08:10PM +1100, Aleksa Sarai wrote:
> NOTE: I'm not sure if I'm doing enough cleanup inside copy_process(),
> because a bunch of stuff happens between the last valid goto to the
> bad_fork_free_pid label and cgroup_post_fork().
> 
> What is the correct way of doing cleanup this late inside
> copy_process()?

Its not; you're past the point of fail. You've already exposed the new
process.

If you want to allow fail, you'll have to do it earlier.
