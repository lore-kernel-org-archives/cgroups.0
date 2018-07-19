From: peter enderborg <peter.enderborg@sony.com>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory, and
 IO v2
Date: Thu, 19 Jul 2018 13:29:39 +0200
Message-ID: <143db4db-2613-345d-9b8e-1794b6d8c4fe@sony.com>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180716155745.10368-1-drake@endlessm.com>
 <20180717112515.GE7193@dhcp22.suse.cz> <20180718222157.GG2838@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718222157.GG2838@cmpxchg.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>
Cc: Daniel Drake <drake@endlessm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux@endlessm.com, linux-block@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On 07/19/2018 12:21 AM, Johannes Weiner wrote:
>
> Yes, we currently use a userspace application that monitors pressure
> and OOM kills (there is usually plenty of headroom left for a small
> application to run by the time quality of service for most workloads
> has already tanked to unacceptable levels). We want to eventually add
> this back into the kernel with the appropriate configuration options
> (pressure threshold value and sustained duration etc.)
Is that the same application as googles lmkd for android? Any source
that you might share?

