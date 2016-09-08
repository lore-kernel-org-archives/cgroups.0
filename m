From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 8 Sep 2016 15:50:15 +0530
Message-ID: <CAG53R5XkJGmatR2Yet9o44ANhMTZ3oJeFbEmrDxzasSSn_Hk0A@mail.gmail.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <1472632647-1525-2-git-send-email-pandit.parav@gmail.com> <20160831093836.GC3694@leon.nu>
 <CAG53R5U9_QVOAAnbqxWG80G=ROSYjgRXrNkJU1BpcpHCfVOe8A@mail.gmail.com> <20160908061219.GK18398@leon.nu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Yix+AYWECN4vh65uCmwEHlAQIfGB3bvt0/97BhyQs3M=;
        b=AfSJlIRfAoZH6sDiPkgloKiHRVF5BQOc9TMi1hRGHGnNfjUbqJZkx78xCmk7FEvjKt
         OR6ZlrxRgX/t+7Bgk5KYxLXt6i5rzB5Jy8QR9GpnMybluzN6R9HxQPi6NM2oiGWyO2wU
         /1voj/v+P6jbNYOeZJzCGM1Pf0fMQhoRRsB29gMpxFZPE7JiCBtuHI6VJHkfWnKIN+5E
         mFdUB3cHu1r9YZH77V/V9h998O17X2QdNV61zpO0e7I1LRmQYj1g1qg20tQOCt0wg1vr
         UiR05+dXXohFTAUfSUlt5aFNTmh96NZufjCAI5BOSf7Ib7wLAE1nocT2qxrR4G2+UL3Z
         swww==
In-Reply-To: <20160908061219.GK18398@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

On Thu, Sep 8, 2016 at 11:42 AM, Leon Romanovsky <leon@kernel.org> wrote:
> On Wed, Sep 07, 2016 at 08:37:23PM +0530, Parav Pandit wrote:
>> Did you get a chance to review the series?
>
> We need to decide on fundamental question before reviewing it, which is
> "how to fit rdmacg to new ABI model".

From last discussion with Matan in this email thread, it appears that -
only broken case are:
(a) HW vendor driver specific resources (if they have crazy big list),
which cannot be abstracted out well enough, won't be controlled by
rdma cgroup.
(b) Such resource objects are not well defined today with new ABI model.
If such objects are well defined today, lets call them out and discuss
with Doug, Tejun, Christoph and larger group, whether they qualify for
inclusion or not.

rdma cgroup currently supports including handful of HW resource that
can be abstracted (at least at functionality level).

Please include any other option issue, if any.
