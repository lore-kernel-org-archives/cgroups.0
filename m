From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [RFC PATCH 0/3] cgroup: fsio throttle controller
Date: Fri, 18 Jan 2019 12:10:08 +0100
Message-ID: <20190118111008.GA25335@xps-13>
References: <20190118103127.325-1-righi.andrea@gmail.com>
 <E5872191-EE96-442E-B668-DD148157E665@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i9Jz6mADl+SAlcH6gEeO3JwA6zj1h7g3kXeXLvf3Qh4=;
        b=c7OvutspFyLKMOanYTqFOhtdpU7ojaNNVvJVsg4XAm+1GYeuC7XX9Xu+fKTrDD6Huu
         HJQC3lrph0tk/EsV0XUd1Uf2YVoCFHoBspiiB6qOnYfiJisjF8hdIXAyPe5z0IHOoERf
         d+ZVQ0rTBjEHLZ350xYAXGHdc5PO3yHvLCpmBlgXIoF5PgovBkJrD0JFOG83e9eW/pQo
         0UN0MNfCoR8n6vvDrnB2feSg8BPvSiNlewlZInoDo6eYsvbChrGuKDovg3aeWkKNVf2/
         g7lCxkVgPp/ab1W9Eygu/cE19L/uL89L1PKjNyjA2ytquXYqi+lv1HgVlHIxy9u+eEsx
         nYZQ==
Content-Disposition: inline
In-Reply-To: <E5872191-EE96-442E-B668-DD148157E665@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Josef Bacik <josef@toxicpanda.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 18, 2019 at 12:04:17PM +0100, Paolo Valente wrote:
> 
> 
> > Il giorno 18 gen 2019, alle ore 11:31, Andrea Righi <righi.andrea@gmail.com> ha scritto:
> > 
> > This is a redesign of my old cgroup-io-throttle controller:
> > https://lwn.net/Articles/330531/
> > 
> > I'm resuming this old patch to point out a problem that I think is still
> > not solved completely.
> > 
> > = Problem =
> > 
> > The io.max controller works really well at limiting synchronous I/O
> > (READs), but a lot of I/O requests are initiated outside the context of
> > the process that is ultimately responsible for its creation (e.g.,
> > WRITEs).
> > 
> > Throttling at the block layer in some cases is too late and we may end
> > up slowing down processes that are not responsible for the I/O that
> > is being processed at that level.
> > 
> > = Proposed solution =
> > 
> > The main idea of this controller is to split I/O measurement and I/O
> > throttling: I/O is measured at the block layer for READS, at page cache
> > (dirty pages) for WRITEs, and processes are limited while they're
> > generating I/O at the VFS level, based on the measured I/O.
> > 
> 
> Hi Andrea,
> what the about the case where two processes are dirtying the same
> pages?  Which will be charged?
> 
> Thanks,
> Paolo

Hi Paolo,

in this case only the first one will be charged for the I/O activity
(the one that changes a page from clean to dirty). This is probably not
totally fair in some cases, but I think it's a good compromise, at the
end rewriting the same page over and over while it's already dirty
doesn't actually generate I/O activity, until the page is flushed back
to disk.

Obviously I'm open to other better ideas and suggestions.

Thanks!
-Andrea
