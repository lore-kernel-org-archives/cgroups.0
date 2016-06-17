From: Daniel Bristot de Oliveira <daolivei@redhat.com>
Subject: Re: [PATCH v2] cgroup: disable irqs while holding css_set_lock
Date: Fri, 17 Jun 2016 16:59:37 -0300
Message-ID: <4353aea6-c1e9-80d2-be44-75340d0aaf01@redhat.com>
References: <1465325475-30593-1-git-send-email-bristot@redhat.com>
 <20160607193008.GA31708@htj.duckdns.org>
 <6f15f27f-3757-5413-4292-1386e95bc278@redhat.com>
 <38469b61-7cc5-5fec-4de3-0e9a616dfe95@redhat.com>
 <20160616220315.GH3262@mtj.duckdns.org>
 <20160616221434.GI3262@mtj.duckdns.org>
 <cf514889-8a4d-1ef4-cf4a-fd1a9b9bcb1d@redhat.com>
 <20160617053625.GL31708@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160617053625.GL31708@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Daniel Bristot de Oliveira <daolivei@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>, "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Juri Lelli <juri.lelli@arm.com>, cgroups@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>


Hi Tejun,

On 06/17/2016 02:36 AM, Tejun Heo wrote:
> Please use _irq and _irqsave
> appropriately depending on the circumstances.

ack! I will do it!

Cooking a v3:
- using _irq and _irqsave appropriately, and
- using raw_spin locks functions.

Thanks! -- Daniel


