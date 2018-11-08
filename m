From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v15 00/12] Enable cpuset controller in default hierarchy
Date: Thu, 8 Nov 2018 12:28:44 -0800
Message-ID: <20181108202844.GD2509588@devbig004.ftw2.facebook.com>
References: <1541689726-20088-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oFvXt1P0vn6sjABmGNaUrUlafHub2RfoXmi03uK+8m4=;
        b=nsyJe1azy7g8xkNeQnKWBS/6x1Y+xiykM9A/ifEMUFKl9tg2Rr1io4dMm+mCuY4Z3E
         f4U+AQtISuiAUwf63xbkTYq1W+nJgx7yQ56IZ5S8u0BuL0dUVjwQkqEVCtDzak/Vh5Xh
         Wt3MV56PQGBfy9gLi8DiyR1IGQSRBvhLPQrBOqZ+DFlpjhxdEKrxa1rwzGqLsOjM5azF
         rx0HO5XijYzqXJThN6qo0RKo2YEL/BeJ0bLzfxxox8PexvifGqK/NvPIM3xkeZGTiqDM
         0xm1NRao+0QCPIL+iK7Mk3F47APbv2ymemdu0AXUnYP+4dZeRehIyYyPdC/31LHO8S56
         DTzA==
Content-Disposition: inline
In-Reply-To: <1541689726-20088-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

Applied to cgroup/for-4.21.

Thanks a lot, Waiman!

-- 
tejun
