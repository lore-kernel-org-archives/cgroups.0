From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory,
 and IO v2
Date: Tue, 17 Jul 2018 13:25:15 +0200
Message-ID: <20180717112515.GE7193@dhcp22.suse.cz>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180716155745.10368-1-drake@endlessm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180716155745.10368-1-drake@endlessm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Drake <drake@endlessm.com>
Cc: hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux@endlessm.com, linux-block@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Mon 16-07-18 10:57:45, Daniel Drake wrote:
> Hi Johannes,
> 
> Thanks for your work on psi! 
> 
> We have also been investigating the "thrashing problem" on our Endless
> desktop OS. We have seen that systems can easily get into a state where the
> UI becomes unresponsive to input, and the mouse cursor becomes extremely
> slow or stuck when the system is running out of memory. We are working with
> a full GNOME desktop environment on systems with only 2GB RAM, and
> sometimes no real swap (although zram-swap helps mitigate the problem to
> some extent).
> 
> My analysis so far indicates that when the system is low on memory and hits
> this condition, the system is spending much of the time under
> __alloc_pages_direct_reclaim. "perf trace -F" shows many many page faults
> in executable code while this is going on. I believe the kernel is
> swapping out executable code in order to satisfy memory allocation
> requests, but then that swapped-out code is needed a moment later so it
> gets swapped in again via the page fault handler, and all this activity
> severely starves the system from being able to respond to user input.
> 
> I appreciate the kernel's attempt to keep processes alive, but in the
> desktop case we see that the system rarely recovers from this situation,
> so you have to hard shutdown. In this case we view it as desirable that
> the OOM killer would step in (it is not doing so because direct reclaim
> is not actually failing).

Yes this is really unfortunate. One thing that could help would be to
consider a trashing level during the reclaim (get_scan_count) to simply
forget about LRUs which are constantly refaulting pages back. We already
have the infrastructure for that. We just need to plumb it in.
-- 
Michal Hocko
SUSE Labs
