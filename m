From: zzuedu2000@163.com
Subject: Re: [PATCH] cgroup: Refactor two assignments in css_task_iter_next_css_set()
Date: Mon, 15 Jun 2020 07:22:24 +0800
Message-ID: <20200614232224.1804-1-zzuedu2000@163.com>
References: <1592158208.5303.27.camel@HansenPartnership.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=SOGSMjP33qpL7ktNpZ
        lBjEhRk3kAp4OIE+OmxCw5kOM=; b=mnHKcxVeVzwxurr41nI19pY9PG8iqDcOa3
        ZY1WReuIr0YbNRQKvxkX7rx/9z9jbEbVgBKPROzjBeruIk5kr13EtnnWViphk20l
        kUc4F/BpsDzbq2md+zXZnTr0sYZD2dIRSi4KDc3d4O8aGPN17tZJBHmRTno5f/ih
        ddlA9kHkk=
In-Reply-To: <1592158208.5303.27.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James.Bottomley@HansenPartnership.com
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Markus.Elfring@web.de, songmuchun@bytedance.com, buddy.zhang@aliyun.com

On Sun, 2020-06-14 at 18:10 +0800, James.Bottomley@xxxxxxx wrote:

> it's arguable that having two statements instead of one makes the code
> marginally more readable.

Above the function there is a similar line of code:
l = it->tcset_pos->next;
One line of code makes the code style consistent and more readable


Regards,

Wei Fenghai

