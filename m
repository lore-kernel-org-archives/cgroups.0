From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv13 0/3] rdmacg: IB/core: rdma controller support
Date: Mon, 9 Jan 2017 15:06:40 -0500
Message-ID: <20170109200640.GK12827@mtj.duckdns.org>
References: <1480705637-2986-1-git-send-email-pandit.parav@gmail.com>
 <20170109130221.GD10904@mtj.duckdns.org>
 <CAG53R5U0F6J5zAU8oWXDSS0YgnvaRxnD=++v=LLFfNRxvz_5jg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dkuZJmhvV8mp0ukrOK9V1Mq9dg1D1eDWY0z9fHI1tXM=;
        b=j8W0TZot2qGn0RUeup42bb0XsiAd0rSWONRSrCxRepdCWOSjm4yYMP0325ov2zC0YV
         4Pme8BpgFkbcJn0bAA37wrIR9Q1nQc2jPM4sU8hMm2XmzK8B/fTqDYbQU/i9thgFktoJ
         B5TLpuzEjuOQu+3APK615GGRUW33mp8fb7zCJCf2nPVraoH1bYQjDG5yqh+UP6LqJegK
         xKarC/Xf8j0Cv61UTdrMv+kX1gfpx0fHSVAr/HFoRWrtTGT721DSyhnw5uPUXBMgY2WY
         pMLueh8Uulnpw5aMWapdfs5Ldkkf0uIXtMWXfGxB9s1iAp+8gWmvsHEHZqOCnW1mBjmD
         Jr1Q==
Content-Disposition: inline
In-Reply-To: <CAG53R5U0F6J5zAU8oWXDSS0YgnvaRxnD=++v=LLFfNRxvz_5jg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

On Mon, Jan 09, 2017 at 02:01:26PM -0600, Parav Pandit wrote:
> I will generate new patch in sometime this week with for-4.11 to
> address comments and rebase.
> I will be renaming cgroup_rdma.c to kernel/cgroup/rdma.c (similar to pids.c)
> 
> I will keep the header file name include/linux/cgroup_rdma.h as it is.

Sounds good.  Thanks and happy new year!

-- 
tejun
