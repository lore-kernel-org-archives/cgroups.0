From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/6] psi: eliminate lazy clock mode
Date: Mon, 17 Dec 2018 15:57:54 +0100
Message-ID: <20181217145754.GB2218@hirez.programming.kicks-ass.net>
References: <20181214171508.7791-1-surenb@google.com>
 <20181214171508.7791-4-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zgswlOL0Z7zZLXeaLuuRwh49voJotlcz14ISMgP0uR4=; b=M8mTiHARUZd3NYq8v22Dx+iAh
        cp6yCkrxK0ooOVnNfugF5ib49vuIHzMiMkE3jrJ0oLChFH2Pn7K08WyPBpaHroLO4dQJU2xpKOR4b
        OtEf4e3xkqBDgRuGLGUsv7mGCBjFn/BEGjMXYVnyL+4eLG3/uHRFSMZK/YtBOmGLD4MN984Yz03Mi
        IT2KeszNtK8yc7EdHlOtnDw5bip8plUz/462TxIXYdV7JR04Q3D/FfLYh9GkF3+f9235eK/G5v4dT
        107jpxyJPz/PsAcMxj1Wt4L0aIqU9wi/3zP9U5LL5J31bwrDn6dZseP42zJz1k4XBIDPVXym0BtNO
      
Content-Disposition: inline
In-Reply-To: <20181214171508.7791-4-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Fri, Dec 14, 2018 at 09:15:05AM -0800, Suren Baghdasaryan wrote:
> Eliminate the idle mode and keep the worker doing 2s update intervals
> at all times.

That sounds like a bad deal.. esp. so for battery powered devices like
say Andoird.

In general the push has been to always idle everything, see NOHZ and
NOHZ_FULL and all the work that's being put into getting rid of any and
all period work.


