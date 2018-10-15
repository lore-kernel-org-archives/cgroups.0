From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v13 00/11] cpuset: Enable cpuset controller in default
 hierarchy
Date: Mon, 15 Oct 2018 09:35:40 -0700
Message-ID: <20181015163540.GQ270328@devbig004.ftw2.facebook.com>
References: <1539366951-8498-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t0IESHF1ZWVIQ9LLdT48/Dib/xD5iVXdavDQf2nKJoQ=;
        b=aB/luPtq6Fyw3ZPiaiNEe6MADBTomOHOTAtnyZQs1B+xXIlKXKE9Ic0sF/I9O5DoMl
         UgWeLl5fmFy5ZzPiNr7YMfIWhDunnb5R6Xt28XgU19rycd4c60rvntUay/Xe4myc9Ui+
         TrIgO2Kvc0ETwqiLP6yfNA2SiDK/Xb/viRUA6vzPZCA/IeI0zW8bTxiZD3U3ADU6h6eb
         UzQT0xjdK1SU5Vdvj56+MNelWqZh+DTNKJt6l4R1TVheuXeUhXUAlObogHfQoQ87LGDW
         232Q/C5PYCgKV2ZfyIMIUkvhT6iS8bnyoy9UO3jvT1dy19/wt8gdffGYmIE/o3AEBZzM
         erQw==
Content-Disposition: inline
In-Reply-To: <1539366951-8498-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hello, Waiman.

This looks great to me.  I have only one small nit in terms of
interface.  Currently, cpuset.partition file uses -1, 0, 1; however,
given that this is consistent with how cgroup.type behaves (something
can be set but may be invalid), I wonder whether using a similar
syntax would be more consistent.  e.g. sth like cpuset.type which
takes "normal" or "partition" and shows one of "normal", "partition"
and "partition invalid".  I'd be perfectly happy with that being a
follow-up patch.

Peter, does the patchset look good to you?  It does everything we want
it to in terms of sched domain partitioning and is compliant all
cgroup2 conventions.  If so, I'll apply the series to the cgroup devel
branch.

Thank you very much for the work and persistence!

-- 
tejun
