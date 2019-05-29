From: Dave Chiluk <chiluk+linux@indeed.com>
Subject: [PATCH v3 0/1] sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices
Date: Wed, 29 May 2019 14:08:45 -0500
Message-ID: <1559156926-31336-1-git-send-email-chiluk+linux@indeed.com>
References: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=9M83j5VgZqnbq4QKIC40z5RykjHLdbDcFYqEBFQAM9Q=;
        b=BgnltxIEsPclx/Vr/vTO+Gsl82dS1ePz6T2lP33ZTGsNESYjGtxIeObAnRKRmFAxOA
         Y74UbJTVWozTlkVex8yk1ziJ9mntkDto672j/G+Jtq1KcPlxdkM8kwH0tqXPesKj1dpF
         YxZobEBmWukUm2HLt5X+VxhllyQnhcBY9RLLc=
In-Reply-To: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>, Peter Oskolkov <posk@posk.io>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org

Changelog v3
	- Reworked documentation to better describe behavior of slice expiration
	  per feedback from Peter Oskolkov

Changelog v2
	- Fixed some checkpatch errors in the commit message.
