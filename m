From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv13 0/3] rdmacg: IB/core: rdma controller support
Date: Tue, 6 Dec 2016 07:35:49 +0530
Message-ID: <CAG53R5UokWTZ+YutTY7_nLJ3ad5VLqT02--BtARQ8BHBBpVOdg@mail.gmail.com>
References: <1480705637-2986-1-git-send-email-pandit.parav@gmail.com> <20161205193528.GC30331@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=oYAddvAaDAm79dE3J8GQBBmTAv0GdxhLJTMqXV64qxo=;
        b=sYDr8l8B6YcJqid+1k7uU17pEhD9lv/MMCWp3rYBYfKfA/WgN7csDH9Zn9Jl01+OH1
         oBSc63IeQa2Pn29MOrUH6XmicUpsbU4z71fxqhy7bRXBRIW/q1v/JO86k75P5yDsujrP
         agBCIIPpeTWQW+pLsUDPEMfsy6z8HZi6ladmd5fd7wSOGrioRDz88MKaNMDMfr0Hkz4B
         ppIEMYrpdfTE8d0nZkhBOuVgrLUR6J1/oo891jFdDk2ANX7xyLqsQ5jKmw18+IGx+/f3
         OgqzEO/5byNwX2xCxC0LlCJ85s/dOEtPk9cXADNYyeWGGXaFjwuIcugGRlg9MvDZ0WzK
         I5Hg==
In-Reply-To: <20161205193528.GC30331@mtj.duckdns.org>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

ok. Thanks Tejun.

Parav

On Tue, Dec 6, 2016 at 1:05 AM, Tejun Heo <tj@kernel.org> wrote:
> Parav, it's a bit too late for this cycle.  Let's target v4.11.  I'll
> review the patches after the merge window.  Please ping me if I don't.
>
> Thanks.
>
> --
> tejun
