From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Fix comments with paths pointing to renamed or moved
 files.
Date: Thu, 23 May 2019 14:35:32 -0400
Message-ID: <20190523143532.0319e253@gandalf.local.home>
References: <20190521155430.14941-1-langspielplatte@black-mesa.xyz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190521155430.14941-1-langspielplatte@black-mesa.xyz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Lukas Prause <langspielplatte@black-mesa.xyz>
Cc: lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, will.deacon@arm.com, rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-pm@vger.kernel.org, Lennart Glauer <mail@lennart-glauer.de>

On Tue, 21 May 2019 17:54:30 +0200
Lukas Prause <langspielplatte@black-mesa.xyz> wrote:

> This patch corrects renamed or moved paths in comments.
> 
> Signed-off-by: Lukas Prause <langspielplatte@black-mesa.xyz>
> Signed-off-by: Lennart Glauer <mail@lennart-glauer.de>
> ---
>  kernel/cgroup/cpuset.c       |  2 +-
>  kernel/locking/mutex-debug.h |  2 +-
>  kernel/power/power.h         |  2 +-
>  kernel/sched/core.c          |  2 +-
>  kernel/trace/trace.h         | 14 +++++++-------

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

>  5 files changed, 11 insertions(+), 11 deletions(-)

