From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory, and
 IO v4
Date: Mon, 17 Sep 2018 15:40:48 +0200
Message-ID: <20180917134048.GF24106@hirez.programming.kicks-ass.net>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
 <20180905214303.GA30178@cmpxchg.org>
 <20180907110407.GQ24106@hirez.programming.kicks-ass.net>
 <20180907150955.GC11088@cmpxchg.org>
 <CAJuCfpG1=pXOg=1GwC33Uy0BcXNq-BsR6dO0JJq4Jnm5TyNENQ@mail.gmail.com>
 <29f0bb2c-31d4-0b2e-d816-68076b90e9d3@sony.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Fs+QYYqcmEZO/wmJmpvm1aMwM9ZKoQb5PjxXJDxeGjE=; b=TyohzSKszInybKOAi2HVmX1Nu
        joJTTXJOLHWRPDXbvtUGbm4/zLrzIuEwS5r/vAtXFKMz+ygGgdgqSpNVnSGcv3VZ3S54h0fQ3xODJ
        7bT8oN1o0MxtGbVqJxIgGLLcRnVYZ+9pn9ATi152WjgTdJoes145tMo9ebjKW9CZpUZ/vZzIJQe4f
        fuZ0beSr7DmVmts65VtEd/uRkCtXN7FxAH6rVCiL938lU7tcAxLmSjGttCJv1l0ruLCGdXj+fjG3T
        Ds/0rlDJl2QaC0mXi/kkgNMRI+TX8/zPrAOzjMZgaMiAKty3e9fe2xvwCraeNTzRETs2EbU9y828Z
      
Content-Disposition: inline
In-Reply-To: <29f0bb2c-31d4-0b2e-d816-68076b90e9d3@sony.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peter enderborg <peter.enderborg@sony.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm <linux-mm@kvack.org>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com


A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?
