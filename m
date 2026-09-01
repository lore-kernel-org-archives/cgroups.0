Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3AD397692;
	Tue,  1 Sep 2026 03:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788233960; cv=none; b=rJtH+rnEvB5+HTi/vABH2gi3XXCLZJox60Z/KLAabfnwOtG2aq1jolQcfAPrCQyO4gZyNQ0K+6Z7GxI4NXSxl0DOZeetrXvsqejPE3NhSfgAgq8sB96dx5Xa4d/z5grx6frKrqp9m9mjQI70ApOiUHZoXblpDagotS7Vr7fPjPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788233960; c=relaxed/simple;
	bh=FBOtULf8CFZAYjOEQAV7Wvs/y0/TtvPhPtil2Ikh2io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kASIu0R+RNTc60cXHFJNGdb8xVJ0GJf0D8B6AI/ph4V4z95L7Etb4NoD5NaxSjVyzKJNW320sZIIiIz+ElJrdX8crL/A8xwwF50jo9uTmOWEdDnOqbBU3slfNIOdeSSsvBxgSuCaLdrAGawC1BOQ3OufawoDW7yG3NafBtjYdh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=EJbNNeKu; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="EJbNNeKu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Po
	P8bWYIQUl0297J3WZJS5T0aRa8xkK9bNJ6Q0/k/TA=; b=EJbNNeKurn3/OsXjQJ
	Kv0Rnfms3+JPrg561jrtKnyhCqu0Yf1llndCdzPTYsvHGOBtx43DHA6HThv6VO9f
	2bhM+wbJXoRlf4hngjgtsAEre31YiTrk4NONPRLuCJ58cDCIfyUVSpAfH0wpNmwM
	khadxnDFfAp4fkjEkkui3PrZs=
Received: from sky.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgD3XxDDSJZq1szbQA--.21368S2;
	Tue, 01 Sep 2026 11:38:44 +0800 (CST)
From: Junnan Zhang <zhangjn_dev@163.com>
To: zhangjn_dev@163.com,
	Michal Koutny <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shouxin Sun <sunshx@chinatelecom.cn>
Subject: Re: [PATCH v3] cgroup: avoid flushing global workqueue in cgroup1_pidlist_destroy_all
Date: Tue,  1 Sep 2026 11:38:42 +0800
Message-ID: <20260901033842.40345-1-zhangjn_dev@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <FIXME-fill-in-Michals-message-id>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgD3XxDDSJZq1szbQA--.21368S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWr45Jry5KFWrtF15Jr47urg_yoWrWry7pa
	yYyw4Fywn5Wry09ayIy3yIgF1rAa1rGayDJr1rGrW0yw15WrnYgryI9ayUWa4UAFZ5Jr1q
	vrZ8WFs8ur4qqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUUku7UUUUU=
X-CM-SenderInfo: x2kd0wxmqbvvry6rljoofrz/xtbCxQSDGWqWSMSy1wAA3O

Hi Michal,

Thanks for the review.

> a) a single reader taking more than hung_task_timeout_secs (that'd be
>    a softlockup earlier),
> b) starvation of cgroup1_pidlist_destroy_all() by many (queued)
>    cgroup_pidlist_start() callers which goes against the second-long
>    caching of pidlists,
> c) there is large number of nr_cgroups * nr_pidnses which makes the
>    caching ineffective

An honest caveat first: this was reported by a customer on a production
Kubernetes node. A guest memory dump was taken at the time, but it
couldn't be analyzed with crash, so I can't give you the exact
nr_cgroups/nr_pidnses.

That said, I believe c) alone is sufficient, and neither a) nor b) is
needed to explain the 120s stall, because the flush latency is
backlog x per-work latency rather than the latency of any single work:

- backlog: flush_workqueue() waits for all works already queued on the
  shared wq, which drains serially (WQ_PERCPU, max_active=1). Container
  churn constantly runs cgroup destruction, and each destroyed cgroup
  queues one work per cached (type, ns) pidlist, so the queue ahead of
  the flusher grows with churn rate x nr_cgroups.

- per-work latency: each destroy work must acquire the owner's
  pidlist_mutex, contending with readers (kubelet/cadvisor/runtime
  scraping cgroup.procs). pidlist_array_load() runs entirely under
  that mutex (css_set walk, kvmalloc, sort), so on a node with frequent
  scraping each work can sit tens of ms behind a reader.

A few thousand queued works each delayed by tens of ms already exceed
hung_task_timeout_secs -- no single reader needs to hold the mutex for
that long (so a) doesn't apply), and each individual work does get the
mutex eventually, so it's not sustained starvation either (so b)
doesn't apply).

More on b): the second-long caching only helps readers that re-read
within that 1s window (e.g. a single `cat` doing several seq_file
iterations). Periodic scrapers like kubelet/cadvisor, with typical
intervals of 10-30s, never hit the cache at all: every scrape round
rebuilds the pidlist under the mutex and queues an expiry work 1s
later. So heavy reader traffic and the existence of the cache are not
in conflict -- the cache is simply ineffective for this access
pattern. It also means the wq steadily carries ~nr_cgroups expiry
works per scrape round, on top of the works queued by churn, which is
what the flusher ends up waiting behind.

On nr_pidnses specifically: containers typically share the pod/host
pid namespace, so in the common case the multiplier is really
nr_cgroups x scraping frequency rather than nr_pidnses. I can't confirm
the customer's pidns usage for the same reason as above.

> OTOH, I'm surprised this v1-issue popped up only now

cgroup v1 is legacy but still the default on widely deployed enterprise
distros, and per-node cgroup density plus metrics scraping frequency
have grown a lot in recent years, so the backlog needed to trip this
only became common recently. Triggering it also requires all three
conditions at once -- many cgroups, frequent full-sweep scraping, and
sustained create/destroy churn -- which is presumably why it isn't
seen more often: missing any one of them, the queue never builds up.
That's my best explanation -- admittedly not provable without an
analyzable dump.

> What's the point of the workqueue after this change? (Mainly the
> expiration + having process context for the handler.)

It still serves the normal path: the deferred expiry that makes the
pidlist cache work, and process context for freeing. The patch only
removes the flush from the cgroup-removal path where, as you noted,
the orphan list guarantees the pidlists head won't be used after cgrp
removal.

If the lack of exact field numbers is a blocker, I can put together a
synthetic reproducer (N cgroups with concurrent cgroup.procs readers
plus destroy churn) and report measured flush_workqueue() latency with
and without the patch. Would that address your concern?

Thanks,
Junnan

