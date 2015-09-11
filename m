From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Fri, 11 Sep 2015 21:56:31 +0530
Message-ID: <CAG53R5X5z-H15f1FzCFFqao=taYeHyJnXAZT2mPzAHYOkyq-_Q@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
	<20150908152340.GA13749@mtj.duckdns.org>
	<CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
	<20150910164946.GH8114@mtj.duckdns.org>
	<CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
	<20150910202210.GL8114@mtj.duckdns.org>
	<CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
	<20150911040413.GA18850@htj.duckdns.org>
	<55F25781.20308@redhat.com>
	<20150911145213.GQ8114@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=GskArJ3orGnxyQjLuWY+rnLpRI3bwpAexTygHPQI9Zs=;
        b=jo2Y4YlTWz4KDLNbS0RvZSvA0X6UIld63MsKvbwAXhqhL39w+CWnd8/qFvJehpHJFA
         hLAgAoBMldfiriQo7rxrDVo8nKhqpttKzOXzdaHkilL0YIMq9xFqt8b4pkbSDAqqv0h5
         WkG8re6mbt6LFTFcL7tURxTeSI5W48CNnm8upVkr0dXoW/h0ZMs18cl0C6jLkkh280Gc
         yZeU9S5XKqK2veOfI5ddaYzJo3c02XNUgY7V0Id7RcXlZt16j4qNWNQnBxuWK+9QiPuP
         ORBDwdyOFsQC4EYVt/wAI+yOne1w0dsFNCpgGMOlGmN8/447YvBFS8uf3BZUcAh0mKSM
         HGlw==
In-Reply-To: <20150911145213.GQ8114@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

> If the resource isn't and the main goal is preventing runaway
> hogs, it'll be able to do that but is that the goal here?  For this to
> be actually useful for performance contended cases, it'd need higher
> level abstractions.
>

Resource run away by application can lead to (a) kernel and (b) other
applications left out with no resources situation.
Both the problems are the target of this patch set by accounting via cgroup.

Performance contention can be resolved with higher level user space,
which will tune it.
Threshold and fail counters are on the way in follow on patch.

> Thanks.
>
> --
> tejun
