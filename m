From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 5/5] psi: introduce psi monitor
Date: Thu, 17 Jan 2019 09:13:14 +0100
Message-ID: <20190117081314.GD10486@hirez.programming.kicks-ass.net>
References: <20190110220718.261134-1-surenb@google.com>
 <20190110220718.261134-6-surenb@google.com>
 <20190114102137.GB14054@worktop.programming.kicks-ass.net>
 <CAJuCfpGUWs0E9oPUjPTNm=WhPJcE_DBjZCtCiaVu5WXabKRW6A@mail.gmail.com>
 <20190116132446.GF10803@hirez.programming.kicks-ass.net>
 <CAJuCfpEJW6Uq4GSGEGLKOM4K7ySHUeTGrSUGM1+EJSQ16d8SJg@mail.gmail.com>
 <20190116191728.GA1380@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Y4uxIJ+NmKS4i1/qDFOJcjGOWHA5fYMzGvsJDpvLNMk=; b=Gb3Z2a5/SgLc7y6cDeKRsD6/b
        UGyiZaiVvFOZBwXSKjGIYRsQNt6oZrxmzioVR9lNQDxgqinTD+S5lDERHN1ve0DaliP4AwKyITgCM
        A+UCHwHAEEHzqwPGKMUytNEjA1IxycEObBOFm2SKjW9QKxa4IhnfAgppSs+foYr4ZPx9gJsX9BStQ
        sBlgLXbY4Pr9Ohz+5g94z2E7eFXauAu5PKKbSLuqAPScIthGvavDjNylmSQvJQsT1cvRNkkMqFHVK
        cfKQWe6maqz0v82+VU2+yFeXHBL3SWB5DG6pWbwzELav8dUpHCYgZnkf3mU7rYJrOR8kw1h8KeQfb
    
Content-Disposition: inline
In-Reply-To: <20190116191728.GA1380@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

On Wed, Jan 16, 2019 at 02:17:28PM -0500, Johannes Weiner wrote:

> > > Also, you probably want to use atomic_t for g->polling, because we
> > > (sadly) have architectures where regular stores and atomic ops don't
> > > work 'right'.
> > 
> > Oh, I see. Will do. Thanks!
> 
> Yikes, that's news to me too. Good to know.

See Documentation/atomic_t.txt, specifically the atomic_set() part in
SEMANTICS.

Archs that suffer this include (but are not limited to): parisc,
sparc32-smp, something arc.

And yes, I would dearly love to kill all SMP support for architectures
like that..
