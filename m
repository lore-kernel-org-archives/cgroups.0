From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 3/5] psi: introduce state_mask to represent stalled
 psi states
Date: Mon, 28 Jan 2019 16:22:08 -0500
Message-ID: <20190128212208.GA1416@cmpxchg.org>
References: <20190124211518.244221-1-surenb@google.com>
 <20190124211518.244221-4-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=R1tczXKUFzCTDG0EEeYL9B/rEiyBaMRbEigEvPcalsM=;
        b=BWUNZDIv09sdTYAuXBiMqvx25t8xYdms70LlJhXdraVVD4ND8QZS1Egu8kl28LrAv4
         2rsNe0xfjtXsa/7pAXDQX6XO7sQieqd+EoOUKyCtprrkAymp9xe1Aeo74Y3eoOJVKeVx
         I0w6f357EMaAsZhJCUprEfPEHCLSP0tmMJuLaozqSHfrax7T2Pd23uVXFhJM/TXo9Rtj
         PtLwtSrHs9eF41prnQYcst3HKBz6IZj/I4ryQ30PPfy07J7OPxoEMq7LNSjHJp/VE7vL
         sg4s3VlxembefLFtixuvyf9Ov0Z+CqLqVM1dYMADBiaWsKBM2idCLIzQtE30kWIsBQOi
         9yig==
Content-Disposition: inline
In-Reply-To: <20190124211518.244221-4-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Thu, Jan 24, 2019 at 01:15:16PM -0800, Suren Baghdasaryan wrote:
> The psi monitoring patches will need to determine the same states as
> record_times(). To avoid calculating them twice, maintain a state mask
> that can be consulted cheaply. Do this in a separate patch to keep the
> churn in the main feature patch at a minimum.
> This adds 4-byte state_mask member into psi_group_cpu struct which
> results in its first cacheline-aligned part to become 52 bytes long.
> Add explicit values to enumeration element counters that affect
> psi_group_cpu struct size.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
