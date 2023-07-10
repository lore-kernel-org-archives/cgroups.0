From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 4/9] cgroup/cpuset: Allow suppression of sched domain
 rebuild in update_cpumasks_hier()
Date: Mon, 10 Jul 2023 11:01:36 -1000
Message-ID: <ZKxxsPKf4uGoJWdX@slm.duckdns.org>
References: <20230627143508.1576882-1-longman@redhat.com>
 <20230627143508.1576882-5-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689022898; x=1691614898;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zzk4Zb/UOMk4q6SsaPq5WbyWefCvWA/AqIp31W/KVD8=;
        b=H6BC9RtRP0P20hEKbP+Uhd6OQuHBhPT9SfnS0pwXP24XbpLNWqk0FExxrS9awU95x2
         8B4Bbnjjw9RL05xU9E/YaRNOlTka+eSss8TVQdG7S1iNyRISMOYUtbKg9udky0slv/FF
         mDUFVKGHwjoZtEma/F37Rl2Dy1nhtW2iOQHwtEYwU0e9eiv5aEtkCvnCBP5t20/XtSzD
         5QMXCpb5ArjpjC1/08Euri6cpZpygC+4GlKZLWycDUd4d/ZfPRvtOu3L6QV3NPlRylKp
         TelCtPjzjGufaKH2E4Std+TYmAwWsMF9WkpohjwncUY0OcQU4dzzT6f4F6Uz+CYsSj5n
         7NbA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230627143508.1576882-5-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>

On Tue, Jun 27, 2023 at 10:35:03AM -0400, Waiman Long wrote:
> A single partition setup and tear-down operation can lead to
> multiple rebuild_sched_domains_locked() calls which is a waste of
> effort. This can partly be mitigated by adding a flag to suppress the
> rebuild_sched_domains_locked() call in update_cpumasks_hier(). Since
> a Boolean flag has already been passed as the 3rd argument to
> update_cpumasks_hier(), we can extend that to a full flag word.
> 
> The sched domain rebuild suppression is now enabled in
> update_sibling_cpumasks() as all it callers will do the sched domain
> rebuild after its return later on anyway.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Applied 1-3 to cgroup/for-6.6.

Thanks.

-- 
tejun
