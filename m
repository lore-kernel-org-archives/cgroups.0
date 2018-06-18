From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v10 6/9] cpuset: Make generate_sched_domains() recognize
 isolated_cpus
Date: Mon, 18 Jun 2018 16:58:44 +0200
Message-ID: <20180618145844.GB13097@localhost.localdomain>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-7-git-send-email-longman@redhat.com>
 <64a0ea0d-c873-f53e-654e-1dd60f833478@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <64a0ea0d-c873-f53e-654e-1dd60f833478@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 18/06/18 22:44, Waiman Long wrote:

[...]

> 
> Sorry, that one is bogus. Please ignore that.
> 

OK, ignoring this should actually "fix" the odd behaviour I was talking
about.
