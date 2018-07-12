From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/10] psi: cgroup support
Date: Thu, 12 Jul 2018 13:08:21 -0700
Message-ID: <20180712200821.GN72677@devbig577.frc2.facebook.com>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-10-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QDWhokhxPbRHqNeP+G9O/mtYZ0lyz3BTOD9tObyaEQw=;
        b=V5gqgOg3pmg6RX4kQtl0dsS8DOwsJ/ygyvEadMnbmOUU8pTUsi8Nsb+FqldfJsMjRo
         woKvSeGxqNp9ODD/hCj9UcZwCE1cnpg6ukDFHt++tk2NTHC+cIE7/LtEzHe8rA9+re/y
         Sx3Pgki8hxzrv4jSLF7+LpzivCRZe9bcrqx48HhgxM0c+8rEeTWgBhBuQeAJ3WQ9hKJa
         qqogSpTTlevgST8BZ/nzFk4ludqBRjT3aJBA80CbY0dvsjnMJe7xvl8vGCWud2ROsMzh
         XCrfVzHK95knXddegf8oGw6MBYGfPHv2xauN3KL/nJotANMOpxIgEZsIpkbqIdwTLr8D
         YUsw==
Content-Disposition: inline
In-Reply-To: <20180712172942.10094-10-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Jul 12, 2018 at 01:29:41PM -0400, Johannes Weiner wrote:
> On a system that executes multiple cgrouped jobs and independent
> workloads, we don't just care about the health of the overall system,
> but also that of individual jobs, so that we can ensure individual job
> health, fairness between jobs, or prioritize some jobs over others.
> 
> This patch implements pressure stall tracking for cgroups. In kernels
> with CONFIG_PSI=y, cgroup2 groups will have cpu.pressure,
> memory.pressure, and io.pressure files that track aggregate pressure
> stall times for only the tasks inside the cgroup.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route with the rest of the patchset.

Thanks.

-- 
tejun
