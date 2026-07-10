Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CE9367B73
	for <cgroups@vger.kernel.org>; Fri, 10 Jul 2026 03:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783654198; cv=none; b=F8nB/uo+SZE0E3T1VpsiiZ9ZCTGfJMuyAm+r98dnLusdjeuYzwy8vqLhOYEBLPqR0mM8Ee/BNcaJfL0URLzEi8TaFgWzjL0p9ItrseI298JfLSb5tv8ko3K/0K2TiyKj6lHGl6gI56s39+tCHsH8P7Yk6dBbpwvyO1VIQYBtTwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783654198; c=relaxed/simple;
	bh=MNtb2Qrr3nNt+ub4rjVucp13CHEPWughXQYJLAqNpy4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=a2HAQ44ba/ynskx+08HJY2HfFVOqM0/Y8EyA1Xn8ItGWlxiqJGML0sOPtbOp5g+BhgbtP4WrDqlKTCYblyxzCr/SdxwkwOqKAW3Z9YVTVoKUkh2HNgaEq64fIN1ymjC7QYU/3xljgg2rj86loAdMBhmKZ0juhqfO7Y8LcLAnfhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FOw3hfY3; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FOw3hfY3"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2c7c61b5292so7034635ad.0
        for <cgroups@vger.kernel.org>; Thu, 09 Jul 2026 20:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783654197; x=1784258997; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cx1US55ZcQE2IXAHU74DmTXGa2F7H+sEKzQcFe01wfY=;
        b=FOw3hfY3Oj5i9E3RdC0nhn5AdEWFb5cLVgRgArGb4bb6kp/M6RdpixAkzx0OUPJDS/
         OCzD2dxGCeiV1VB4CXInwLgPPekz+xhtXDl4y2+YmSa5pu0nmL8y3IIK72XOV5kZDmln
         Utgz1Mii77S2ODs5veYjNP1vVJpupanprFN5EE7ZUg4o85bOuNpcpiMghscP5Ijsz71E
         rXtG6SZTWDTNwYG77d3fQGou5JIQZ8OqqhKiRxQ/0WaXggRpIzvnSYDPbftCBkkPlogi
         9Utiz4nYmMvhnv8wEbcHsy3/cBDSIf/YTUzVFSx/EMMjTv//mq/relr7ibH0sRUlLyJa
         bZmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783654197; x=1784258997;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cx1US55ZcQE2IXAHU74DmTXGa2F7H+sEKzQcFe01wfY=;
        b=a8HAJnn5PoGwpvQFGkNyLSnKrpr6ZxGoweQzvogbUupGzVPMj9gW4xlOD+K5zHDCai
         8KaPftjCRG6qVNw5hrY441cQ/CSH9YaI+U1OAnzNHBS462Zehbqp6s9E1XW3hsy0eZMW
         4qAgjOp07i7Z9gJFRLgFYrlduW0bUrCSk6xqgspNhj7+7u0kZILr2B7ruu40xqB28le8
         g45Lj2TJc26cSiFWk5VopmNTIyKXcUkhQCt8TpppqYbWFM0+TtBtLdc1tUuKADktzXy5
         3VAo7GQnSGzok4mtAGpM2xG8LlOuKamn9kdvxr0BHnMDez39GePVYPszs7t35ja7TOLj
         x2Rg==
X-Forwarded-Encrypted: i=1; AHgh+Rqu9USreXO0Sh61yUkUeirZklvrHLDTpnGqcw9msQBX92/b9Fv6ltUKXCeFIu/RB7St4AKy7V3D@vger.kernel.org
X-Gm-Message-State: AOJu0YyPmeFhvSk0VbMG515PD/vgBSonViUckf9lhJp6MxsWiZY1+6qw
	voUrg1BHO29i7WFpLNMiKrQV/6Ewx3GkOuxpxyiDJOElyv7yv+7r2tYs
X-Gm-Gg: AfdE7cl0kwSHW0RW3ImQrRyBvn7PuShGyiukN7hcbZsbTMDr58PdrUiQJ7o5b1fkLc5
	ljWv1bENbaLvzgkV9l9xOtLqKMttQ1fj9xaagpSxnJvwBc4ApH17Pxsb4SPYkQml0DjxWBwI+fl
	ptHp+bX5yaQBkydzetI75a2XaL9nj6G+eC4sVrpBUAVWd+FkcxVFoJC05fk+IHnY6VdRzRc4My7
	3Y05zi+/IWxVTZvH8Z+mLW440yrJ6xGZ3pgcYqRdQQtiu5hVQbxCUsU8w0VyWNrXNGXkYqCcMVI
	NDzMSLswTwBfB3Kx13uTCw7CgQRn2VLhLQkM4Fy6bZhPbZlSPFxUS2yyO4dwwyVhrDZE79Y1ZTO
	rdgloOfcrBAQHVc9ClGAGou3yzrr0uzr5wVm5d+Gnmt03ejxU5TBxvM5fSmkd78nSMS2IboSPzu
	UJEZ0uTi2eaqw=
X-Received: by 2002:a17:903:244e:b0:2ca:d91d:d3a7 with SMTP id d9443c01a7336-2ccea2a5de9mr109420575ad.10.1783654196716;
        Thu, 09 Jul 2026 20:29:56 -0700 (PDT)
Received: from [127.0.1.1] ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb56fsm53436465ad.15.2026.07.09.20.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 20:29:56 -0700 (PDT)
From: Jing Wu <realwujing@gmail.com>
Date: Fri, 10 Jul 2026 11:28:21 +0800
Subject: [PATCH v4 10/11] docs: cgroup-v2: document kernel-noise isolation
 via isolated partitions
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-wujing-dhm-v4-10-2e912e5d9645@gmail.com>
References: <20260710-wujing-dhm-v4-0-2e912e5d9645@gmail.com>
In-Reply-To: <20260710-wujing-dhm-v4-0-2e912e5d9645@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Tejun Heo <tj@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Cc: Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org, 
 rcu@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jing Wu <realwujing@gmail.com>, 
 Qiliang Yuan <yuanql9@chinatelecom.cn>
X-Mailer: b4 0.13.0

Document that creating a cpuset isolated partition updates the
kernel-noise housekeeping masks (HK_TYPE_KERNEL_NOISE and
HK_TYPE_MANAGED_IRQ) in addition to the sched-domain mask, and
that destroying it restores the boot configuration.

No boot-time kernel parameters such as nohz_full= or rcu_nocbs=
are required; writing "isolated" to cpuset.cpus.partition is the
only mechanism needed.

Co-developed-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Signed-off-by: Jing Wu <realwujing@gmail.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6efd0095ed995..eaafe6d88c0e5 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2721,6 +2721,23 @@ Cpuset Interface Files
 	kernel boot command line option.  If those CPUs are to be put
 	into a partition, they have to be used in an isolated partition.
 
+	When an isolated partition is created or destroyed, the kernel
+	automatically drives runtime updates of the housekeeping masks
+	for kernel-noise types (nohz_full, RCU NOCB, managed IRQ
+	interrupts).  This extends isolation beyond scheduler domains:
+	the tick is stopped on isolated CPUs, RCU callbacks are
+	offloaded to housekeeping cores, and managed interrupts are
+	migrated away.  No boot-time kernel parameters such as
+	``nohz_full=`` or ``rcu_nocbs=`` are required; writing
+	``isolated`` to ``cpuset.cpus.partition`` is the only mechanism
+	needed.  No additional cgroupfs files are required.
+
+	CPUs with hotplug disabled (typically the boot CPU, CPU 0, on
+	x86-64) cannot be cycled offline for kernel-noise isolation.
+	The kernel emits a one-time warning and keeps those CPUs in
+	the tick and RCU-NOCB housekeeping set, even when they appear
+	in an isolated partition.
+
 
 Device controller
 -----------------

-- 
2.43.0

