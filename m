From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory, and
 IO v4
Date: Fri, 7 Sep 2018 11:09:55 -0400
Message-ID: <20180907150955.GC11088@cmpxchg.org>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
 <20180905214303.GA30178@cmpxchg.org>
 <20180907110407.GQ24106@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TaAYZ9snpOcizEPrlLp2rv+nViYTbC2PtsByXxBogJk=;
        b=ItK8sIVOrcLoFfAyx9kSiK5UqRyUu1Sg1tovdm35w1X0tDNpzKQfFyv3oChOJfdep6
         A/6iN8Xk8OAEMGbJVF785TEs3JeM+dk3+XAMgqSVrGYBItxP3APTS7CpTEUbw4w3m8Ai
         dfkH3U5JiIpKVN8tkDfQRPHtkmSZzxevwPMNCUWK2Q/PIb9xiZoHHRA2+Pqtw4IXWAHH
         DxCNeFaFrl1W/eA1SwgLWaD5OBoZdU6Y91hq4YDiH1EZ34oLZd6f+UBqYWANXGSj7Ria
         TnmAjtKSh4UAeEG2U10a8eXtJkIpkqZNK0QBt7ZuajFXMT3A5eH+bZpFk+J7eBMh/kZs
         1mIA==
Content-Disposition: inline
In-Reply-To: <20180907110407.GQ24106@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Sep 07, 2018 at 01:04:07PM +0200, Peter Zijlstra wrote:
> So yeah, grudingly acked. Did you want me to pick this up through the
> scheduler tree since most of this lives there?

Thanks for the ack.

As for routing it, I'll leave that decision to you and Andrew. It
touches stuff all over, so it could result in quite a few conflicts
between trees (although I don't expect any of them to be non-trivial).
