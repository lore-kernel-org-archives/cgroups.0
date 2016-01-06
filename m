From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv1 6/6] rdmacg: Added documentation for rdma controller.
Date: Wed, 6 Jan 2016 17:57:14 -0500
Message-ID: <20160106225714.GI3660@htj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <1452020286-9508-7-git-send-email-pandit.parav@gmail.com>
 <20160105215309.GG5995@mtj.duckdns.org>
 <CAG53R5WD18VK3sVuVnPR7yjEBqRjHAoUkCpZKzSd9-PYZrx-YA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mhAJbBA22xsYcrM124e/7zSgOsrHXuZ74jC3gFu69OQ=;
        b=D0GcJSBxL9p9bBoWn61YeB91qWAWzoRkQmoCKT/e7Tdq4dEmCgfI8lxhQdDiXTx10D
         2ncbI465CBP/6J6QjQOZbIblb36uugBJdt9gES4g2roMLC7KtPYGUkwAWG1xwTf4Gs+8
         nVOgZm75psDsdrOjmRHFLb9r6JTnscp1SHMNF7RtrK3RXJNMA6weCUthljuWigfl3Xb8
         VQUH1K1HE7kmX9i9gqFXXN5RVwoeQUMKWrlBba4btD8HpVHgQJzlI0P1V5qo95coq2TP
         L3gKLbECEm8pyia7rGKEwI+oWk+w4AjXI7HIPSVLyLAnBFM+/o5ezQfp26F9ruxCEE/4
         GEUg==
Content-Disposition: inline
In-Reply-To: <CAG53R5WD18VK3sVuVnPR7yjEBqRjHAoUkCpZKzSd9-PYZrx-YA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello,

On Thu, Jan 07, 2016 at 04:14:26AM +0530, Parav Pandit wrote:
> Yes. I read through. I can see two changes to be made in V2 version of
> this patch.
> 1. rdma.resource.verb.usage and rdma.resource.verb.limit to change
> respectively to,
> 2. rdma.resource.verb.stat and rdma.resource.verb.max.
> 3. rdma.resource.verb.failcnt indicate failure events, which I think
> should go to events.

What's up with the ".resource" part?  Also can't the .max file list
the available resources?  Why does it need a separtae list file?

> I roll out new patch for events post this patch as additional feature
> and remove this feature in V2.
> 
> rdma.resource.verb.list file is unique to rdma cgroup, so I believe
> this is fine.

Please see above.

> We will conclude whether to have rdma.resource.hw.<files> or not in
> other patches.
> I am in opinion to keep "resource" and "verb" or "hw" tags around to
> keep it verbose enough to know what are we trying to control.

What does that achieve?  I feel that it's getting overengineered
constantly.

Thanks.

-- 
tejun
