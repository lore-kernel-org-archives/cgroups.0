From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 6/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Tue, 8 May 2018 10:06:48 -0400
Message-ID: <20180508140648.GB2900@cmpxchg.org>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-7-hannes@cmpxchg.org>
 <024fba07-eece-3878-0924-ea9fd601542d@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yV9mx4MM9CtIkOlDtJkY37nJ1rCbjTHtcSVrNOCcgDI=; b=U6x1hkMZxnJLIho9M2MCnsN3HZ
        3WUWZjtucFaPS6iaV+jGPbGmowAee7OLQqcrevbhxFusQMnxtowpbQdOJx6pf2Eb43o70X6Hbfnj4
        RtGy/cDVCSEzA/fNjJQcpHcDAMgm3LtIetIYW+eroT0c57D/vZ72PoyR3aef3i1ueeAQ=;
Content-Disposition: inline
In-Reply-To: <024fba07-eece-3878-0924-ea9fd601542d@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Mon, May 07, 2018 at 05:42:36PM -0700, Randy Dunlap wrote:
> On 05/07/2018 02:01 PM, Johannes Weiner wrote:
> > + * The ratio is tracked in decaying time averages over 10s, 1m, 5m
> > + * windows. Cumluative stall times are tracked and exported as well to
> 
>                Cumulative
> 

> > +/**
> > + * psi_memstall_leave - mark the end of an memory stall section
> 
>                                     end of a memory

Thanks Randy, I'll get those fixed.
