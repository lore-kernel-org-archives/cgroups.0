From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Thu, 19 Jul 2018 11:26:14 +0200
Message-ID: <20180719092614.GY2512@hirez.programming.kicks-ass.net>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180718120318.GC2476@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/XzYF6OgunbOCgX1qSMgWlG2svJbh/a+gYsM8px3vOQ=; b=2UrTct1TTh99ANKw7NpiSZmc+
        0NZS3UQ6cBIcbHNb4sN2U+yetfGdkVYM0uRe9VyDSKvu+927ANZXnZBiX/GXDa04DwqA2tqTRncD/
        xdHZzyQEwEYW/DUCzBD7mf1mAJXwp1szVCkqCLUg6tHzhv++zvnmjWxYOmpXUroolyDMtQg4+oinU
        iLLnhysu4TV6jUByFlkrOYUbE/lsL9VbH1f7BQOYcRGy+75PWgQI+DAeMQsKZbOUqwZBCdShBagdy
        LqMslZdDXEK1K+/QaB3kq1Quhtnt7uOQeZ7yWYM8PGxK/wVNZrqxvAP6gKUzex5zLwSqgIZPGio6S
      
Content-Disposition: inline
In-Reply-To: <20180718120318.GC2476@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Jul 18, 2018 at 02:03:18PM +0200, Peter Zijlstra wrote:

> Leaving us just 5 bytes short of needing a single cacheline :/
> 
> struct ponies {
>         unsigned int               tasks[3];                                             /*     0    12 */
>         unsigned int               cpu_state:2;                                          /*    12:30  4 */
>         unsigned int               io_state:2;                                           /*    12:28  4 */
>         unsigned int               mem_state:2;                                          /*    12:26  4 */
> 
>         /* XXX 26 bits hole, try to pack */
> 
>         /* typedef u64 */ long long unsigned int     last_time;                          /*    16     8 */
>         /* typedef u64 */ long long unsigned int     some_time[3];                       /*    24    24 */
>         /* typedef u64 */ long long unsigned int     full_time[2];                       /*    48    16 */
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         /* typedef u64 */ long long unsigned int     nonidle_time;                       /*    64     8 */
> 
>         /* size: 72, cachelines: 2, members: 8 */
>         /* bit holes: 1, sum bit holes: 26 bits */
>         /* last cacheline: 8 bytes */
> };
> 
> ARGGH!

It _might_ be possible to use curr->se.exec_start for last_time if you
very carefully audit and place the hooks. I've not gone through it in
detail, but it might just work.
