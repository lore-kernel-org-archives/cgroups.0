From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 0/5] cgroup-aware unbound workqueues
Date: Wed, 5 Jun 2019 06:53:19 -0700
Message-ID: <20190605135319.GK374014@devbig004.ftw2.facebook.com>
References: <20190605133650.28545-1-daniel.m.jordan@oracle.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FETSS3J4eD7K515d8ScmcKfF1wyotHso7dwlnNKYVC8=;
        b=O84ji0lXN+RqkutIEaEyEEqQXcFVzeG64E5D+IGzwBJcDRXFIhtWb80kt89787ERae
         SVgqIrHUOdqzFOWmqqrmY63CyKPgJHTijErg98dUmfPqYT4f200Pa3v2DHmAPP/DgulF
         7nlCPUR8C5qMCx8d5XN1RqshszE7/VRzXBHkrkM8ioHtBsYqvXGLKiUWOF8TgpJfByAC
         WxpTcx4EhwfLIK2ozup8V4g1ahyLKPG66YNnH3iOR2HOqHPyAVljLcZGRtEvSJDYYBBK
         ph5a0gf262q4Ydh7OMHdU6YtIKKeID7muJi8gChJSfg446PN8vB787GwyVShso3Jk9H1
         cbxQ==
Content-Disposition: inline
In-Reply-To: <20190605133650.28545-1-daniel.m.jordan@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: hannes@cmpxchg.org, jiangshanlai@gmail.com, lizefan@huawei.com, bsd@redhat.com, dan.j.williams@intel.com, dave.hansen@intel.com, juri.lelli@redhat.com, mhocko@kernel.org, peterz@infradead.org, steven.sistare@oracle.com, tglx@linutronix.de, tom.hromatka@oracle.com, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Hello, Daniel.

On Wed, Jun 05, 2019 at 09:36:45AM -0400, Daniel Jordan wrote:
> My use case for this work is kernel multithreading, the series formerly known
> as ktask[2] that I'm now trying to combine with padata according to feedback
> from the last post.  Helper threads in a multithreaded job may consume lots of
> resources that aren't properly accounted to the cgroup of the task that started
> the job.

Can you please go into more details on the use cases?

For memory and io, we're generally going for remote charging, where a
kthread explicitly says who the specific io or allocation is for,
combined with selective back-charging, where the resource is charged
and consumed unconditionally even if that would put the usage above
the current limits temporarily.  From what I've been seeing recently,
combination of the two give us really good control quality without
being too invasive across the stack.

CPU doesn't have a backcharging mechanism yet and depending on the use
case, we *might* need to put kthreads in different cgroups.  However,
such use cases might not be that abundant and there may be gotaches
which require them to be force-executed and back-charged (e.g. fs
compression from global reclaim).

Thanks.

-- 
tejun
