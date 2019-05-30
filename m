From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm: fix page cache convergence regression
Date: Thu, 30 May 2019 10:13:56 -0700
Message-ID: <20190530171356.GA19630@bombadil.infradead.org>
References: <20190524153148.18481-1-hannes@cmpxchg.org>
 <20190524160417.GB1075@bombadil.infradead.org>
 <20190524173900.GA11702@cmpxchg.org>
 <20190530161548.GA8415@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QXNL9kos3vvhr0YBbrXLE6785Sr0j7K/kyJsGRxCWZo=; b=aCW4rmAy7Pfqx+sC1ow5UzLj5
        S3cVvA1W0r84fyjvp6WDkz705BtgL4tr8bA4RNheok9Z87NBGbO6IxB8x3gy7psxD5OrdO2Fr0Dr3
        BzgQNIlDoeNoC0txb++rY4wo7shwMCprqrJdGMvJ0gKfOVWGdfaC3LP8AhGvLZUfpUzJ8vM2Q722l
        G44gEhQemLG44xdWe2W7d1eUtjnz0TIlF1JHnZOBc4DEJfGBJIVY2E8zqSoJq72uluhFxnEiWwMcx
        5mSIzsVzkijJCx1iiqp0lGzjaxU6+Ye0COktFH1ahbrAL5COgyMbYYt6K6oPY1l7wpncviyxbSSVc
Content-Disposition: inline
In-Reply-To: <20190530161548.GA8415@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, May 30, 2019 at 12:15:48PM -0400, Johannes Weiner wrote:
> Are there any objections or feedback on the proposed fix below? This
> is kind of a serious regression.

I'll drop it into the xarray tree for merging in a week, if that's ok
with you?
