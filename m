From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v9 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Tue, 14 Apr 2015 10:33:41 +1000
Message-ID: <CAOviyajqc_ip2Lpa5NTLLXxQ7JghYXg1UL3vXDdpbbnhmsfXEQ@mail.gmail.com>
References: <1428799917-15141-1-git-send-email-cyphar@cyphar.com>
	<1428799917-15141-4-git-send-email-cyphar@cyphar.com>
	<20150413142439.GA2596@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150413142439.GA2596@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hi Tejun,

> Ummm... is this really necessary?  Can't we do something like the
> following?
>
> #define SUBSYS_TAG(tag)                                         \
>         __##tag,                                                \
>         tag = __##tag - 2,

Is which part necessary? That's what TAG() does. I can remove the
UNUSED_IDENT() if you want, that was just to make sure you don't get clashes
with other unused idents. COUNT() is so that we don't have to manually add
CGROUP_<TAG>_COUNT for every tag we add.

--
Aleksa Sarai (cyphar)
www.cyphar.com
