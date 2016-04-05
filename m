From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Tue, 5 Apr 2016 05:42:52 -0700
Message-ID: <20160405124252.GA4348@infradead.org>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
 <1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
 <20160404193640.GA7822@mtj.duckdns.org>
 <CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
 <20160405012504.GG24661@htj.duckdns.org>
 <20160405090627.GA26425@infradead.org>
 <CAG53R5WBBUj6=B81Q-zEwL_xy3_yXUofJ6p921baqnqeVocDPQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5WBBUj6=B81Q-zEwL_xy3_yXUofJ6p921baqnqeVocDPQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Tue, Apr 05, 2016 at 05:39:21AM -0700, Parav Pandit wrote:
> I am not really trying to address OFED issues here. I am sure you
> understand that if ib_core.ko kernel module is in-kernel module than,
> for all the fixes/enhancements that goes to it would require people to
> upgrade to newer kernel, instead of just modules upgrade. Such heavy
> weight upgrade slows down the adoption which i am trying to avoid here
> by placing knobs in right kernel module's hand.

What a load of rubbish.  The Linux kernel is one program and should be
upgraded together.

> Its like making ib_core.ko from module to in kernel component, if I
> understand correctly nobody wants to do that.

We allow splitting subsystems out where it's easily doable to avoid the
resources consumption if they're all built in.  For cgroups it's not
really practical, but that doesn't mean you can upgrade invidual parts
of a complex program without a lot of precaution.
