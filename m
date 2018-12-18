From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/6] psi: introduce psi monitor
Date: Tue, 18 Dec 2018 11:46:22 +0100
Message-ID: <20181218104622.GB15430@hirez.programming.kicks-ass.net>
References: <20181214171508.7791-1-surenb@google.com>
 <20181214171508.7791-7-surenb@google.com>
 <20181217162223.GD2218@hirez.programming.kicks-ass.net>
 <CAJuCfpHGsDnE-eAHY1QnX949stA3cvNA=078q1swqVnz95aJfg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eVdR9lHYgwIxzuSNH4ypjLBCr5/5VTkW/iKHFipJKEw=; b=acARrZ8SMv7OG02VMWkIkr5Dd
        /0APdno5I3UgmIndDgCVAu6y/HDffHq8/7LAe+BENcI5bUOt5NFlpAqo4Rxj+IRJ1LYjHxo2dHdx4
        +XOc94/R7CtzYrhn9vscgao/MUV5O15SSwsLbTA0D9TNm6xoAnshjwKojdfeF6yZfjDC0eUMMjTrp
        LCPr122DPJzkWwYPYtBh/OSgHxErOHaKJrkblvkOxCCHlGucpMi75hNn2QOm7xEMx9gnlKI+4be8B
        0JRtOkmwpTvU1e5BR4IAJ3QT/7orXG6ETq/G5VuPpztkvixdW+D0DeXAtXb/FldnQxfAQpaN+/DUz
    
Content-Disposition: inline
In-Reply-To: <CAJuCfpHGsDnE-eAHY1QnX949stA3cvNA=078q1swqVnz95aJfg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

On Mon, Dec 17, 2018 at 05:21:05PM -0800, Suren Baghdasaryan wrote:
> On Mon, Dec 17, 2018 at 8:22 AM Peter Zijlstra <peterz@infradead.org> wrote:

> > How well has this thing been fuzzed? Custom string parser, yay!
> 
> Honestly, not much. Normal cases and some obvious corner cases. Will
> check if I can use some fuzzer to get more coverage or will write a
> script.
> I'm not thrilled about writing a custom parser, so if there is a
> better way to handle this please advise.

The grammar seems fairly simple, something like:

  some-full = "some" | "full" ;
  threshold-abs = integer ;
  threshold-pct = integer, { "%" } ;
  threshold = threshold-abs | threshold-pct ;
  window = integer ;
  trigger = some-full, space, threshold, space, window ;

And that could even be expressed as two scanf formats:

 "%4s %u%% %u" , "%4s %u %u"

which then gets your something like:

  char type[5];

  if (sscanf(input, "%4s %u%% %u", &type, &pct, &window) == 3) {
  	// do pct thing
  } else if (sscanf(intput, "%4s %u %u", &type, &thres, &window) == 3) {
  	// do abs thing
  } else return -EFAIL;

  if (!strcmp(type, "some")) {
  	// some
  } else if (!strcmp(type, "full")) {
  	// full
  } else return -EFAIL;

  // do more

which seems like a lot less error prone. Alternatively you can use 4
formats:

  "some %u%% %u" "some %u %u"
  "full %u%% %u" "full %u %u"

and avoid the whole 'type' thing.


