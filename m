From: Qais Yousef <qyousef@layalina.io>
Subject: [PATCH 4/6] cgroup/cpuset: Iterate only if DEADLINE tasks are present
Date: Sun, 20 Aug 2023 16:24:15 +0100
Message-ID: <20230820152417.518806-5-qyousef@layalina.io>
References: <20230820152417.518806-1-qyousef@layalina.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1692545070; x=1693149870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wbdzu9Fe21KuQwmqV5eGRjnoq5R4hfHCD+0YtyLYwM=;
        b=VCpuFZSVGNRhJh4HGieNwuPdqITUj2x6mnc3sAKY+jTmYeKMSY3kaVtPvxw8zuspYa
         Jq/jyP1LITH8rx8WtbESpb+hx7W7asgQ2mp9woLhZ8Rq6SyRXsBZzKZscvMYi3Tn3R8d
         HQPtbxx8Sw+uSthcyqUEvvfJ3e6xRgJvz94B6Yf+apIcbPeXZ7fIvjjcZR78AV2tjv0x
         eXXy5Ba/qXMjLWi+0mtDoK2I0hhMTf9xHHOsgoFB2qjNVfaPaYBu/pojSZeGhHn70/lI
         5oD546XYoIbHfv/bFLqupElmvf1zlW30V1zatd9r0KByw2oQ9/gor1ZhA+guXfB0KtJC
         9MnA==
In-Reply-To: <20230820152417.518806-1-qyousef@layalina.io>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stable@vger.kernel.org
Cc: Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Peter Zijlstra <peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>, Ingo Molnar <mingo@kernel.org>, Hao Luo <haoluo@google.com>, John Stultz <jstultz@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Qais Yousef <qyousef@layalina.io>

From: Juri Lelli <juri.lelli@redhat.com>

commit c0f78fd5edcf29b2822ac165f9248a6c165e8554 upstream.

update_tasks_root_domain currently iterates over all tasks even if no
DEADLINE task is present on the cpuset/root domain for which bandwidth
accounting is being rebuilt. This has been reported to introduce 10+ ms
delays on suspend-resume operations.

Skip the costly iteration for cpusets that don't contain DEADLINE tasks.

Reported-by: Qais Yousef (Google) <qyousef@layalina.io>
Link: https://lore.kernel.org/lkml/20230206221428.2125324-1-qyousef@layalina.io/
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
(cherry picked from commit c0f78fd5edcf29b2822ac165f9248a6c165e8554)
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/cgroup/cpuset.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5f57829bb986..eca07ff71656 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1092,6 +1092,9 @@ static void dl_update_tasks_root_domain(struct cpuset *cs)
 	struct css_task_iter it;
 	struct task_struct *task;
 
+	if (cs->nr_deadline_tasks == 0)
+		return;
+
 	css_task_iter_start(&cs->css, 0, &it);
 
 	while ((task = css_task_iter_next(&it)))
-- 
2.34.1

