From: Daniel Bristot de Oliveira <daolivei@redhat.com>
Subject: Re: [PATCH v2] cgroup: disable irqs while holding css_set_lock
Date: Tue, 7 Jun 2016 17:05:05 -0300
Message-ID: <6f15f27f-3757-5413-4292-1386e95bc278@redhat.com>
References: <1465325475-30593-1-git-send-email-bristot@redhat.com>
 <20160607193008.GA31708@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160607193008.GA31708@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>, "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Juri Lelli <juri.lelli@arm.com>, cgroups@vger.kernel.org

On 06/07/2016 04:30 PM, Tejun Heo wrote:
> Is this something in mainline?  This forces all task free path to be
> irq-safe, which *could* be fine but it's weird to make cgroup free
> path irq-safe for something which isn't in mainline.

you mean, mainline linux kernel? if so, yes it is. I was running the
v4.7-rc2 from Linus, as is.... no external patches applied.
