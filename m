Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAB84AF175
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 13:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946726; cv=none; b=GxhiE1Lr1jiFusyynELthmJedZSmn1D+hGOo2hOoSm1KlBV4pAARhzDIKxzKZYHc9q1CZD/It9JSBS9zAoJ9Rz9sdC6b774eDHpDbrw0zNBFnAMMk4MywHZQa1rc2a/IHOyfWf0zoLC44ooSOYR53BCa84gJYGLHRdNw+Hifw2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946726; c=relaxed/simple;
	bh=jkf3NIV6i5WK+xvvDgj01dYKgr6AdTZFc9y2z4i9lrg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nW7DjOLZwNN/TbBqIXHqJ55iDovUhSAij04xC/UJgNyaHl69lJz3kyOzYLhSM0eYg6iwBEVllpRUZl+tSA43A79Q+wyMlKipvCLVa/qQG1Hmh9P4GNLfnzm8cBQiivB20BGHdy6iAo9DCWmqHah24FNkGgBIQj1OPStFSFEBKaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H1DvETWa; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H1DvETWa"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-340f56c44b0so3277237eec.1
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 06:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790946723; x=1791551523; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ppJ2lJlxiBbwCIcEtdAIsNmyh5ErNbBhGmGmQubrIQE=;
        b=H1DvETWaymNt52kDXwme9GAQC0MQF9B86vtm7HejOeFPAd4ZJhN0I/4814zT3UfhBS
         tninhfbduuT5jS06qpzoiJtQi4XxB1AU9QIqel0v5SA/45t4TH1WZ64tsG3gCuBqrpUM
         /mY/4317ntXEaT5l0WOsRawII74vWXNq/kZ3BxkHgkxmdKXum7Ab7oGf82yrnj87Ya4k
         rqenRlNQZwlYikLYQ3/8+QmKy/wqmHcSZcKT71XpKQ3D9+I8KrmnP0/oOidHXvY86Vcu
         zUFPZt1i6Vdt5pYVp4/dACN3hTtosLzHs7TI9OXzgBR9oiXW4q67VCbOJ4gaIaVhOj7u
         7PgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790946723; x=1791551523;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ppJ2lJlxiBbwCIcEtdAIsNmyh5ErNbBhGmGmQubrIQE=;
        b=0hCoq5OFP7Bk9BFMA0x0xgdo9xyiZ795k1k0NBwALNk2xW1QIAlzv3SWI/8Rd38HUS
         IBEgSDIwBlf+oCnwBDncmwIrnsbHnq/cW3uvKNnWX4iC75z96HWg8OkaaiV5k80b46Cf
         eVGY0a1SV7SyfpYjpBIAHb8lACQoZJ7XGEq9AAqx9Iziyu8bZRWyu2CsKpnhTpB0rEOq
         NQkeFpPXyUIAwuxpJLPu0bG/E0VCXXa7EKgZ5h0gTZD/WvF60NrQncwBYEu5fLMgxKrf
         MlcmnDSEV5ZIkUPw17QI9oMZSd4iytBT4kQDFiQi/n6W4h1uEawPYtd74wkKVG94EE3T
         2pig==
X-Forwarded-Encrypted: i=1; AKwUvByDMdJcCwIGXwtUpqEOw0GBpOM96yN8/JxSpTmF55sMentFjAHRAuDo4TeGnmGPBJVbI/Mml2TH@vger.kernel.org
X-Gm-Message-State: AFq9FYKMqKRsSXW6HKtJ1YkGbQ8ZDBZogjENLlUm0RODnUBGWvkrcFsX
	gUZlF9IvgBbQmiAGo5sM0t2tzN7C66bx8F5t2lpSL74hHDlmnnXniLOB
X-Gm-Gg: AYBFou3qDTBGnELOZEt36wtbCipwCuuwW3s1XRA8z1BFOLnLejJzgDvAaT/CUNb4upV
	XdQymNz1oCO2d9YQ2lzRpTT9wZtRzLTg3roCXOq7zZO3yERmLSr3f5zvPW78Ahji+r+Vs9ZfUNG
	clR/9anusYyKs6C1TrrHGVsCimO168CRFoKEqP1FSdZTKiVg0k1yTa2Vc8GSnSBKvtqaRPwzsue
	houQFVaO1G/dXroJoFf9JuMAdt6CZaCzKeNecIsAW99w6aq7Xv1vtYuukW9G2BKLY8ZG6er1C/I
	EWBLZ35GgdN7IXiUDoBYXK1vS1XrPJZ5p5vOHw2taRhlGfKOu6/Q0ASOa+9uyCABjNTfjh8s730
	SzO80L/gSMsg8K7d0edoDrgrGH2Ix3hSDzjKGolYmeEXDXfZ+LP45OBepNmZd+xGIaHeQZzPonR
	q8Sb5XO0NzeWssdKn0mfUE3xLzIKCjFTcTjWiAlmzdM+VRQiuewLxS/SFcySIotUCw
X-Received: by 2002:a05:7301:182f:b0:34b:68eb:fc04 with SMTP id 5a478bee46e88-34f15091e7emr2922189eec.11.1790946722396;
        Fri, 02 Oct 2026 06:12:02 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f0672c739sm7309347eec.3.2026.10.02.06.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 06:12:02 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 02 Oct 2026 21:10:31 +0800
Subject: [PATCH v5 11/12] docs: cgroup-v2: Document kernel-noise isolation
 via isolated partitions
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-wujing-dhm-v5-11-78a6996d87ad@gmail.com>
References: <20261002-wujing-dhm-v5-0-78a6996d87ad@gmail.com>
In-Reply-To: <20261002-wujing-dhm-v5-0-78a6996d87ad@gmail.com>
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
 linux-kselftest@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0

Document that creating a cpuset isolated partition updates the
kernel-noise housekeeping masks (HK_TYPE_KERNEL_NOISE and
HK_TYPE_MANAGED_IRQ) in addition to the sched-domain mask, and
that destroying it restores the boot configuration.

No boot-time kernel parameters such as nohz_full= or rcu_nocbs=
are required; writing "isolated" to cpuset.cpus.partition is the
only mechanism needed.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 86a2a0099178e..611c6f7ca4efe 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2784,6 +2784,23 @@ Cpuset Interface Files
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

