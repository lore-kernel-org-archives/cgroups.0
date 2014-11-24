From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] cgroups: Documentation: fix wrong cgroupfs paths
Date: Mon, 24 Nov 2014 10:45:30 -0700
Message-ID: <20141124104530.78a0050e@lwn.net>
References: <1416847159-3895-1-git-send-email-sj38.park@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1416847159-3895-1-git-send-email-sj38.park@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: SeongJae Park <sj38.park@gmail.com>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 01:39:19 +0900
SeongJae Park <sj38.park@gmail.com> wrote:

>   6) Attach that task to the new cgroup by writing its PID to the
> -    /sys/fs/cgroup/cpuset/tasks file for that cgroup.
> +    /sys/fs/cgroup/cpuset tasks file for that cgroup.

That one looks like it was correct before the change...?  What am I
missing here?

Thanks,

jon
