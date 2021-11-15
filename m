From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 1/4] cputime, cpuacct: Include guest time in user time
 in cpuacct.stat
Date: Mon, 15 Nov 2021 11:06:16 -1000
Message-ID: <YZLLyFnT95o4Sa8X@slm.duckdns.org>
References: <20211115164607.23784-1-arbn@yandex-team.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pdkroTh+57X81CRfLMuPticZu0w7m2cSqwASgcC59+4=;
        b=U5gzjH2q2MohYRt0B41/5G0ExzIjAyoP/j4H7zZLFx0s9O5evQXZN+dbUqRZ/ZQCHm
         CDbldbLbMp446MOTK9ZZ+KanNspkl3KFS1UW1fqVBrb7cikP8L31CYK/UGpzEYV8chVL
         i+HKHjkxktj4+JMuJxeIxcV5MhhQu4bnKJsC3j+VeU2T9csUYxa/rO4BhsHogNHq3sVM
         vaHP/gEylf9S+g4eAhX1YdCTg8l8hd06saa7WEDaqWh9OBIWAqRD0+UuCEKEjyKdWScx
         NjqWGeJZUw1faoaJYYDsKMTAlDC6D5BNiEbp42TjXznB/OYrx+nS8uaTlt6+E3bkgzFV
         OeFw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211115164607.23784-1-arbn@yandex-team.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <arbn@yandex-team.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Daniel Jordan <daniel.m.jordan@oracle.com>, stable@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Schatzberg <schatzberg.dan@gmail.com>

Hello,

Ingo, Peter, this looks fine to be sans a couple typos in the descriptions.
Please let me know if you wanna take them through sched tree. Otherwise,
I'll route them through cgroup tree in a few days.

Thanks.

-- 
tejun
