From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 2/9] mm/huge_memory: fix uninitialized compiler warning
Date: Tue, 19 Nov 2019 10:42:17 -0500
Message-ID: <20191119154217.GC382712@cmpxchg.org>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
 <1574166203-151975-3-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=nWs/1bjDvNuzUJtmMQammwiguABeAIM4rx8Ev82Odj4=;
        b=us8sMchDRqbzZLY+8PM7/pe8WsLDZaohdyGl7R3EeSoWSvgvizJcLMF0BSaCEqsdy4
         NSYDM17Ete2jESTbIDna9vtA0dUXsmg6bBXQOCH48RDKNzLBxQ6mlp7dlkil/PAQ5hl4
         kxrZ3bqxv5B9F8bKvIHUq5QUdUopVtt0xgGF3OfR4oa410peA1MSURbcEDbJvRagtXXW
         +SqQC2r8fKOXJEA7CxMEGgKlIO7ejUpU40J+VxnUNJ6vEHK8//vMrnAp2qoHjQxavaiI
         vz7OWx7ODCOY89S+kEdO/+LJrWWnNLTcSyv0Maq4YAOgtfhCfquKCCUXG3oySb+mCvBb
         38tQ==
Content-Disposition: inline
In-Reply-To: <1574166203-151975-3-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com

On Tue, Nov 19, 2019 at 08:23:16PM +0800, Alex Shi wrote:
> ../mm/huge_memory.c: In function ‘split_huge_page_to_list’:
> ../mm/huge_memory.c:2766:9: warning: ‘flags’ may be used uninitialized
> in this function [-Wmaybe-uninitialized]
>   lruvec = lock_page_lruvec_irqsave(head, pgdata, flags);
>   ~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Like with the previous patch, there is no lock_page_lruvec_irqsave()
at this point in the series.
