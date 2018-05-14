From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 0/7] psi: pressure stall information for CPU, memory,
 and IO
Date: Mon, 14 May 2018 20:15:50 +0000
Message-ID: <01000163604b7e9e-c2729157-aed2-4f5b-bebe-1bf16261ab88-000000@email.amazonses.com>
References: <20180507210135.1823-1-hannes@cmpxchg.org> <010001635f4e8be9-94e7be7a-e75c-438c-bffb-5b56301c4c55-000000@email.amazonses.com> <20180514185520.GA7398@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ug7nbtf4gccmlpwj322ax3p6ow6yfsug; d=amazonses.com; t=1526328950;
        h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type:Feedback-ID;
        bh=Q8qPqzBa5m7L/sRi/d6xL7H4RD0c77gF8yCVTDEi6rk=;
        b=HxsLc3w88slSx0f4GXVHXAgrxm6md9d1u9vuvLsucwQX3+2ngehU0q74ZtQX+y5e
        uiLWKg49n0EAZtwjAIPTEI61EFXDBA1teINOz9K/gorb9BekJwGtj1tFDjHpBsPO+lo
        dx6PuiKr2uJOzbnyT4Mec+SCao2GSuXlcEOxu7ok=
In-Reply-To: <20180514185520.GA7398@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Mon, 14 May 2018, Johannes Weiner wrote:

> Since I'm using the same model and infrastructure for memory and IO
> load as well, IMO it makes more sense to present them in a coherent
> interface instead of trying to retrofit and change the loadavg file,
> which might not even be possible.

Well I keep looking at the loadavg output from numerous tools and then in
my mind I divide by the number of processors, guess if any of the threads
would be doing I/O and if I cannot figure that out groan and run "vmstat"
for awhile to figure that out.

Lets have some numbers there that make more sense please.

