From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Memcached with cfs quota 400% performance boost after bind to 4
 cpus
Date: Fri, 17 Sep 2021 15:01:31 +0200
Message-ID: <YUSRqyfE2DjJhtHc@hirez.programming.kicks-ass.net>
References: <9f907d99-1cdb-37db-49ae-8e31c7ea8fe7@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/rZz1r8xXREUazeDrzdFdL0EcUy/UUby58bFIJOi0A0=; b=r/AfEsfrDvBads4CkLPNVdmVgN
        YmZ7tAS6VQTIS26ucECW/cgtPnh1nzChv3KEIXdE4TPaIIJkglxPHAXXOXHs+puJvGTuXid9ZfcqX
        IXtUT5yFJJnKINP4cnaC/e7m/lDU9ySoCq25uftbN+M/F2PziqZzx412M7a8vgmNwUubwGZI3oJr2
        jlEm5scesU9I0F4UKhBwC3tbpWrQ/wSKiGbezE81+1/cZMEABogIEB5J+LF74PPpLGTQyOzc1/Orm
        uUKtXo4MzGcJr8OB1ESnSort7alvZpcKPjhr3EGKFxnSk89hIoll2Dvqo7zjItfgJ7TiBeSaqTbVf
        RQj4s+Gw==;
Content-Disposition: inline
In-Reply-To: <9f907d99-1cdb-37db-49ae-8e31c7ea8fe7@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Jianchao <jianchao.wan9@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Sep 17, 2021 at 08:35:36PM +0800, Wang Jianchao wrote:
> Hi list
> 
> I have a test environment with following,

(forgets to specify the actual hardware...)
