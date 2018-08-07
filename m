From: peter enderborg <peter.enderborg@sony.com>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory, and
 IO v3
Date: Tue, 7 Aug 2018 13:50:09 +0200
Message-ID: <5576a988-fca9-15a5-5fa8-16f704ea20fb@sony.com>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801151958.32590-1-hannes@cmpxchg.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On 08/01/2018 05:19 PM, Johannes Weiner wrote:
>
> A kernel with CONFIG_PSI=y will create a /proc/pressure directory with
> 3 files: cpu, memory, and io. If using cgroup2, cgroups will also have
> cpu.pressure, memory.pressure and io.pressure files, which simply
> aggregate task stalls at the cgroup level instead of system-wide.
>
Usually there are objections to add more stuff to /proc. Is this an exception?
