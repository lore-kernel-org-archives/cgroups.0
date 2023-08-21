From: Qais Yousef <qyousef@layalina.io>
Subject: [PATCH 0/6] Backport rework of deadline bandwidth restoration for 6.4.y
Date: Mon, 21 Aug 2023 23:19:50 +0100
Message-ID: <20230821221956.698117-1-qyousef@layalina.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1692656421; x=1693261221;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VcwuxIDWqi7zySJDkuXgYqXHdkQMVuMBWMZbaaDC588=;
        b=qPwDksHT/apYM4Jvja9KqlHNLBgDkFxR+Em5jcqWkunkVhGcI4z9bDHRikk613dh2d
         c1WmiFB+ntsqeuWHUTFAFxyOylUclWW9vrHIq/uWinYw/hZAWWSzeOyFf9iFpsUJNdRb
         F4B5seudrovo7mAiGhBbgeQe+dQu2eTagkhE4cYqsVsd2/4GX9/KaX3rAPZsytFLOcxC
         oLRsoOjx+yFbiIU9BDEgCeFgUjpFXVXAQazWJXK9spiFb5zT1Dib7bADStWbIBcEmyDC
         PeX7L0vheQGnkVCD3hQDF1lLUaDYLeQyRy9eKjs2FPocnq9CR1+sQXc8jaFfu6zHYgrr
         yB7w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stable@vger.kernel.org
Cc: Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Peter Zijlstra <peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>, Ingo Molnar <mingo@kernel.org>, Hao Luo <haoluo@google.com>, John Stultz <jstultz@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Qais Yousef <qyousef@layalina.io>

This is a backport of the series that fixes the way deadline bandwidth
restoration is done which is causing noticeable delay on resume path. It also
converts the cpuset lock back into a mutex which some users on Android too.
I lack the details but AFAIU the read/write semaphore was slower on high
contention.

Compile tested against some randconfig for different archs. Only boot tested on
x86 qemu.

Based on v6.4.11

Original series:

	https://lore.kernel.org/lkml/20230508075854.17215-1-juri.lelli@redhat.com/

Thanks!
