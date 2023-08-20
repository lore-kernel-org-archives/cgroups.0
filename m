From: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Subject: [PATCH 0/6] Backport rework of deadline bandwidth restoration for 5.10.y
Date: Sun, 20 Aug 2023 16:21:38 +0100
Message-ID: <20230820152144.517461-1-qyousef@layalina.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1692544910; x=1693149710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t1WFhLLujM0Chr+SFgokCgNMU6zRltqI69DEFgLDAHM=;
        b=FMj8AIFOKHOUOs579dCdiNT8N9nIRUXe7vWEEWi+4Ym7tht9mCp4KrM4gNByXZBOQS
         liHslt2h7iNO+t9RjBUVr6zhUuLjZrbr6SlXX69mcq40hax5tGHdWVypHuDiDKxDGa66
         6KDlvXoSmrIhW8xUf1WNaYiqN0C/LW+Vv10l6/Hf5tIiFYVnWaVUvTnNKieks6eia793
         JJH67O2xM8d+UKQyFjTUvOvh2eKW9GyZ6OchggLkde6n86jE0iyaPRBzCC0dZlMBLibs
         orLYy7XlIYntl9+EgUSbotcn9c0JET16VFwoS11Cn59mceRqjM8iLfjqeol16WJmBl0y
         xVHQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Stultz <jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>

This is a backport of the series that fixes the way deadline bandwidth
restoration is done which is causing noticeable delay on resume path. It also
converts the cpuset lock back into a mutex which some users on Android too.
I lack the details but AFAIU the read/write semaphore was slower on high
contention.

Compile tested against some randconfig for different archs and tested against
android13-5.10 GKI kernel.

My testing is limited to resume path only; and general phone usage to make sure
nothing falls apart. Would be good to have some deadline specific testing done
too.

Based on v5.10.191

Original series:

	https://lore.kernel.org/lkml/20230508075854.17215-1-juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/

Thanks!
