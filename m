From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v6 3/7] psi: rename psi fields in preparation for psi
 trigger addition
Date: Wed, 20 Mar 2019 16:57:25 -0400
Message-ID: <20190320205725.GB19382@cmpxchg.org>
References: <20190319235619.260832-1-surenb@google.com>
 <20190319235619.260832-4-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7TKyPat2diHfhv30jcYBziI63YFmk+7ZB7yCGURrsOk=;
        b=n/tRt29629ySiX3AtuVlLNum1FJJFphZldMMdvbBJx3fBa56guOATGv7CDMkOuBIjc
         lzEk19RcZMpmyKktO8DEh7EwfhTBzl7o9eU0Dnrr5jS4Aaxpqsgj8GpD9CobgAurX7Lm
         jTxmvqZHeXYvEMnn0BCfStSfCjOKIrILFOF43AXJGjAl3Tx/DKnYj2mDeAG4or7XFeZx
         ToNeHbOIFyEwmFGYilxIy66E3+V0mVcRKqxsVdDKARJBx8Lv5Pno2YySaSBM8WEB6JSY
         Zey6IfsC58wGD+Wb1AoP1n+c6OLPw6xLrTGc2fFbfv5kfQaLcwxo95kPNMrGXjaf287S
         FLhg==
Content-Disposition: inline
In-Reply-To: <20190319235619.260832-4-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Tue, Mar 19, 2019 at 04:56:15PM -0700, Suren Baghdasaryan wrote:
> Renaming psi_group structure member fields used for calculating psi totals
> and averages for clear distinction between them and trigger-related fields
> that will be added next.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
