From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sched/core: fix buffer overflow in cgroup2 property
 cpu.max
Date: Wed, 6 Mar 2019 10:07:19 -0800
Message-ID: <20190306180719.GG50184@devbig004.ftw2.facebook.com>
References: <155189230232.2620.13120481613524200065.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MoZymIeYpEA3JH5PffWyHNM38vDeCAjiLx3pLK1x8l8=;
        b=KQk0ceeQM4K+MkwMcJQYLre2G1RYJpVpVisWfCktSy0qjCYEUhtEIR2nDix5IzCrJT
         ODz7xOVwQqmJs0FujdRPCbuSWqE8dksbzWMhWNb+5q4ovQnxvwtYn9epb7V34UImQ9WH
         0VAp8KH32TYjxtnpkrRkTQIf7m5Ns0kCt+Tld8ScKtCf5J1h8xmLDW9KMlfKTZJKX7Aq
         sUrPqjlqPntBpt3V93NJQMerD80bRlcmOkp7AS9perFdSsvb7p5eUtPOUNZ1yHnVrXYD
         rzWHcXVmEdJmxc0OKmDCADJh74Tjy4cMCo9fCa1K7loJubBHJ1SRDw4b0cXESh6wRa7o
         JIkQ==
Content-Disposition: inline
In-Reply-To: <155189230232.2620.13120481613524200065.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>

On Wed, Mar 06, 2019 at 08:11:42PM +0300, Konstantin Khlebnikov wrote:
> Add limit into sscanf format string for on-stack buffer.
> 
> Fixes: 0d5936344f30 ("sched: Implement interface for cgroup unified hierarchy")
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks and I look forward to the sscanf improvements.  That'd be
really nice to have.

-- 
tejun
