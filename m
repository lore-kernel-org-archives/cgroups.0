From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH v2 4/5] sched/cpuacct: fix user/system in shown
 cpuacct.usage*
Date: Fri, 10 Sep 2021 15:03:26 -0400
Message-ID: <20210910190326.nwv7kktt42nucoit@oracle.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210820094005.20596-1-arbn@yandex-team.com>
 <20210820094005.20596-4-arbn@yandex-team.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=DNkfUGSbpjIuVqk5Z5ogMBzidSNn4HDkXcWuWjMkuPY=;
 b=GKMfc2YWGGuQuDLPnozvRVPsrVq+tPttAsxLptDLOmNpqNVPYFB9fbHqYV8o0FchU1VJ
 zk7ZfW9EMNHvYQBXdstrsGLW0kwwat2JyA3cKhf/b5Kht1MD0S1VsVjtRJ2PSdB7zkk4
 NTZPK/K0KLOOeVFQgQsVyVDJxKNvzUQpgxvzsV9vRbDWewrpgZMQDYw6UJNp7dGTWNLA
 gj+/x0J9qtV5DmpDPONOT78iNloB5VHt3MA6yrzAasSVhGtnOK8fKAMmmnzYZ8elscwJ
 V7QHM9ISpqu+FXw64y5z1LZf+pho1GLSDAg/91ZOOpJ8ybserI0rArNhFNy646rySlsY rA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=DNkfUGSbpjIuVqk5Z5ogMBzidSNn4HDkXcWuWjMkuPY=;
 b=tuCILJlVLTdDZMWHAdlxwZMY+8UQxqEwAe+o7kj2CJabHtjVW+5mTxcMG/Bk+9KGSWGz
 YMfqzma63AjJSZvJRRjZDmsDkX0YCWsmwLSWBrubp6JB9cccudbWj4a1tLra3y/Gh8XC
 Z2YMBXEhIkR+l5rNOV912chiX6143Jg3silEcjr+I0MSCR7WYQxvFjkRIj1aaMvkbq9J
 Jo7zrB5Akr3EvXyfwYAIAWL6XiHllBEheis45zCN7VeP/8EMIoD8weim1psqzoi1bS3A
 evyuXUezedKFu1AaoOKT2eanQZ8/8CEe31xqYTYUXN/ySpszXdIT8tjsDD69+oubGJmw Xw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNkfUGSbpjIuVqk5Z5ogMBzidSNn4HDkXcWuWjMkuPY=;
 b=LybJcw7cvr8ltYeqzu+y4m7VFX/qpLyeugDjiPHwxNtEHpqAhxlzkXCB1A8yFJGuz2faIIQSX2sWh/+RBgGnaDTLwFZiw5/l1lMf4RX1QM7CRrSXRQ48KNgJNwHIf2jOI7/YDafmUuLCoOO6DiL0kfI3CqGcs+jQUuTl6Ybb2Zs=
Content-Disposition: inline
In-Reply-To: <20210820094005.20596-4-arbn@yandex-team.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <arbn@yandex-team.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com, boris@bur.io, stable@vger.kernel.org

On Fri, Aug 20, 2021 at 12:40:04PM +0300, Andrey Ryabinin wrote:
> cpuacct has 2 different ways of accounting and showing user
> and system times.
> 
> The first one uses cpuacct_account_field() to account times
> and cpuacct.stat file to expose them. And this one seems to work ok.
> 
> The second one is uses cpuacct_charge() function for accounting and
> set of cpuacct.usage* files to show times. Despite some attempts to
> fix it in the past it still doesn't work. Sometimes while running KVM
> guest the cpuacct_charge() accounts most of the guest time as
> system time. This doesn't match with user&system times shown in
> cpuacct.stat or proc/<pid>/stat.
> 
> Demonstration:
>  # git clone https://github.com/aryabinin/kvmsample
>  # make
>  # mkdir /sys/fs/cgroup/cpuacct/test
>  # echo $$ > /sys/fs/cgroup/cpuacct/test/tasks
>  # ./kvmsample &
>  # for i in {1..5}; do cat /sys/fs/cgroup/cpuacct/test/cpuacct.usage_sys; sleep 1; done
>  1976535645
>  2979839428
>  3979832704
>  4983603153
>  5983604157

Thanks for expanding on this, and fixing broken cpuacct_charge.

For the series,
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
