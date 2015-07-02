From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 41/51] writeback: make wakeup_flusher_threads() handle
 multiple bdi_writeback's
Date: Wed, 1 Jul 2015 22:37:06 -0400
Message-ID: <20150702023706.GK26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-42-git-send-email-tj@kernel.org>
 <20150701081528.GB7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gZE5rRkleVv5qvKpdR93dmf+2P7DHgy+djScPV5Oeeg=;
        b=cP4OVYXMjpWeURatIu/DoMJ4X5dsIDCSuwIKLn43+fcr12UWKcNFjNqaxwsnHPDWAb
         Ao688xO+fTpJJnaIoemUCUoXqc0XeYrMYA8LCXGjgNWPqO7WIu+Sw/eXGix3kddKgQrA
         CM+Ir7yK3Gak6VGCM1xVfewJiwl1yHPZJoexi++mLaX/bxGskBxW5xSAx+NTe1Gu6wMJ
         LTlyzVzRvR1NApjZrCYx8ftopmE0Pr4OB2JcEI7q1qD0stf5o0mjfrO6dZA2w07nJST7
         9yqTm3T2nrx0yw4fzfilUue+4OLAso7jPK8Ixa0EIZTKCRTP5wINHD4Iskc30tleDvgA
         Jzcw==
Content-Disposition: inline
In-Reply-To: <20150701081528.GB7252@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello,

On Wed, Jul 01, 2015 at 10:15:28AM +0200, Jan Kara wrote:
> I was looking at who uses wakeup_flusher_threads(). There are two usecases:
> 
> 1) sync() - we want to writeback everything
> 2) We want to relieve memory pressure by cleaning and subsequently
>    reclaiming pages.
> 
> Neither of these cares about number of pages too much if you write enough.

What's enough tho?  Saying "yeah let's try about 1000 pages" is one
thing and "let's try about 1000 pages on each of 100 cgroups" is a
quite different operation.  Given the nature of "let's try to write
some", I'd venture to say that writing somewhat less is an a lot
better behavior than possibly trying to write out possibly huge amount
given that the amount of fluctuation such behaviors may cause
system-wide and how non-obvious the reasons for such fluctuations
would be.

> So similarly as we don't split the passed nr_pages argument among bdis, I

bdi's are bound by actual hardware.  wb's aren't.  This is a purely
logical construct and there can be a lot of them.  Again, trying to
write 1024 pages on each of 100 devices and trying to write 1024 * 100
pages to single device are quite different.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
